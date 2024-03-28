package com.startbutton.sb_payment_sdk;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupMenu;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import com.startbutton.sb_payment_sdk.APIServices.ApiService;
import com.startbutton.sb_payment_sdk.APIServices.PaymentService;
import com.startbutton.sb_payment_sdk.Utils.ClipboardUtils;
import com.startbutton.sb_payment_sdk.Utils.LoaderUtil;
import com.startbutton.sb_payment_sdk.dialogs.ExpireDialog;
import com.startbutton.sb_payment_sdk.dialogs.SuccessDialog;
import com.startbutton.sb_payment_sdk.interfaces.OnActivityResultListener;
import com.startbutton.sb_payment_sdk.models.APIResponse;
import com.startbutton.sb_payment_sdk.models.ApiResponse;
import com.startbutton.sb_payment_sdk.models.BankAccountModel;
import com.startbutton.sb_payment_sdk.models.DataResponse;
import com.startbutton.sb_payment_sdk.models.ManualVerificationModel;
import com.startbutton.sb_payment_sdk.models.PaymentInitModel;
import com.startbutton.sb_payment_sdk.models.PaystackDetailModel;
import com.startbutton.sb_payment_sdk.models.PaystackDetailResponse;
import com.startbutton.sb_payment_sdk.models.TransferDetailModel;
import com.startbutton.sb_payment_sdk.models.TransferDetailResponse;

import java.lang.reflect.Type;
import java.text.NumberFormat;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.concurrent.Executor;

import co.paystack.android.Paystack;
import co.paystack.android.PaystackSdk;
import co.paystack.android.Transaction;
import co.paystack.android.model.Card;
import co.paystack.android.model.Charge;
import io.reactivex.disposables.Disposable;
import io.reactivex.observers.DisposableObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
public class StartPaymentActivity extends AppCompatActivity {
    public static final String TAG = "StartButton Activity";
    private TextView countdownTextView;
    private TextView totalAmountTextView;
    private TextView emailTextView;
    private TextView accountNumberTextView;
    private TextView accountNameTextView;
    private TextView bankNameTextView;
    private TextView modeTextView;
    private Button confirmationBtn;
    private Button switchBtn;
    private Button switchPaymentBtn;
    private Button warningBtn;
    private LinearLayout timerLayout;

    View copyAccBtn;
    View copyRefBtn;
    ImageView closeBtn;
    TextView refTextView;
    private LinearLayout cardPaymentLayout;
    private ConstraintLayout transferLayout;
    private CountDownTimer countDownTimer;

    private EditText mCardNumber;
    private EditText mCardExpiry;
    private EditText mCardCVV;
    ProgressBar progressIndicator;

    TransferDetailModel transferDetailModel;
    PaystackDetailModel paystackDetailModel;
    ManualVerificationModel manualVerificationModel;

    private final long startTimeInMillis = 1800000; // 30 minutes
    private long timeLeftInMillis = startTimeInMillis;
    //private OnActivityResultListener listener;
    String email;
    String pubKey;
    double amount;
    boolean isLive;
    String reference;
    String currencyType;
    String accountList;
    BankAccountModel accountModel;
    private List<BankAccountModel> bankList;
    private static OnActivityResultListener callback;

    private boolean isTransfer = true;
    private boolean isPaying = false;

    public StartPaymentActivity(){

    }

    // Constructor or setter method to set the callback
    public StartPaymentActivity(OnActivityResultListener callback) {
        this.callback = callback;
    }

    // Method to set the callback if using a setter
    public static void setCallback(OnActivityResultListener callbackFunction) {
        callback = callbackFunction;
    }

    // Example method where you have the result
    private void returnResult(String message, Object data) {
        if (callback != null) {
            APIResponse response = new APIResponse();
            response.setError(false);
            response.setMessage(message);
            response.setData(data);
            Intent resultIntent = new Intent();
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(response);
            resultIntent.putExtra("response", jsonResponse);
            callback.onActivityResult(RESULT_OK, response);
        }
        finish();
    }

    // Example method where you have the error result
    private void returnErrorResult(String message) {
        if (callback != null) {
            APIResponse response = new APIResponse();
            response.setError(true);
            response.setMessage(message);
            response.setData(null);
            Intent resultIntent = new Intent();
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(response);
            resultIntent.putExtra("response", jsonResponse);
            callback.onActivityResult(RESULT_CANCELED, response);
        }
        finish();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start_payment);

        // Set status bar color
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(getResources().getColor(R.color.lightOrange)); // Replace with your desired color
        }

        initData();

        initializeTransfer();

        startTimer();
    }

    private void startTimer() {
        countDownTimer = new CountDownTimer(timeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                timeLeftInMillis = millisUntilFinished;
                updateCountdownText();
            }

            @Override
            public void onFinish() {
                // Timer finished
                countdownTextView.setText("Timer finished");
                ExpireDialog expireDialog = new ExpireDialog(StartPaymentActivity.this);
                expireDialog.setCallback((data) -> {
                    // Handle the result here
                    if (data != null) {
                        toggleTransferOption();
                    }
                });
                expireDialog.show();
            }
        }.start();
    }

    private void updateCountdownText() {
        int minutes = (int) (timeLeftInMillis / 1000) / 60;
        int seconds = (int) (timeLeftInMillis / 1000) % 60;

        String timeLeftFormatted = String.format("%02d:%02d", minutes, seconds);
        countdownTextView.setText(timeLeftFormatted);
    }

    private void initData(){
        Intent intent = getIntent();
        email = intent.getStringExtra("email");
        reference = intent.getStringExtra("reference");
        pubKey = intent.getStringExtra("pubKey");
        isLive = intent.getBooleanExtra("isLive", false);
        amount = intent.getDoubleExtra("amount", 100);
        currencyType = intent.getStringExtra("currencyType");
        accountList = intent.getStringExtra("bankList");

        // Get currency formatter for the default locale
        Locale specificLocale = new Locale("en", currencyType.split("")[0]+currencyType.split("")[1]); // Example: United States
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(specificLocale);

        countdownTextView = findViewById(R.id.timerView);
        totalAmountTextView = findViewById(R.id.total);
        emailTextView = findViewById(R.id.emailView);
        accountNameTextView = findViewById(R.id.accountName);
        accountNumberTextView = findViewById(R.id.accountNumber);
        bankNameTextView = findViewById(R.id.bankName);
        modeTextView = findViewById(R.id.modeTextView);
        confirmationBtn = findViewById(R.id.confirmPaymentBtn);
        switchBtn = findViewById(R.id.switchButton);
        switchPaymentBtn = findViewById(R.id.switchPaymentBtn);
        mCardNumber = findViewById(R.id.cardNumberField);
        mCardExpiry = findViewById(R.id.cardExpiryField);
        mCardCVV = findViewById(R.id.cardCvvField);
        progressIndicator = findViewById(R.id.loader);
        copyRefBtn = findViewById(R.id.copyRefBtn);
        copyAccBtn = findViewById(R.id.copyBtn);
        refTextView = findViewById(R.id.transactionRef);
        closeBtn = findViewById(R.id.closeBtn);

        closeBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                returnErrorResult("Transaction canceled");
            }
        });

        Objects.requireNonNull(mCardExpiry).addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if(s.toString().length() == 2 && !s.toString().contains("/")) {
                    s.append("/");
                }
            }
        });

        Objects.requireNonNull(mCardNumber).addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                // Remove previous space characters
                String text = s.toString().replaceAll(" ", "");

                StringBuilder formattedText = new StringBuilder();
                for (int i = 0; i < text.length(); i++) {
                    if (i > 0 && i % 4 == 0) {
                        formattedText.append(" "); // Add a space after every fourth character
                    }
                    formattedText.append(text.charAt(i));
                }

                // Set the formatted text back to the EditText
                mCardNumber.removeTextChangedListener(this);
                mCardNumber.setText(formattedText.toString());
                mCardNumber.setSelection(formattedText.length());
                mCardNumber.addTextChangedListener(this);
            }
        });

        /*TextView changeBankView = findViewById(R.id.changeBankView);

        changeBankView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPopupMenu(v);
            }
        });*/

        warningBtn = findViewById(R.id.button2);
        timerLayout = findViewById(R.id.linearLayout);
        transferLayout = findViewById(R.id.constraintLayout);
        cardPaymentLayout = findViewById(R.id.cardPaymentLayout);

        confirmationBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmTransferStatus(transferDetailModel.getReference());
            }
        });

        switchBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toggleTransferOption();
            }
        });

        switchPaymentBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toggleTransferOption();
            }
        });

        totalAmountTextView.setText(currencyFormatter.format(amount));

        emailTextView.setText(email);

        // Create Gson instance
        Gson gson = new Gson();

        // Define the type of the collection using TypeToken
        Type listType = new TypeToken<List<BankAccountModel>>(){}.getType();

        // Parse JSON array string to list of Person objects
        bankList = gson.fromJson(accountList, listType);

        accountModel = bankList.get(0);

        accountNameTextView.setText(accountModel.getAccountName());
        accountNumberTextView.setText(accountModel.getAccountNumber());
        bankNameTextView.setText(accountModel.getBankName());
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (countDownTimer != null) {
            countDownTimer.cancel();
        }
    }

    void toggleTransferOption(){
        isTransfer = !isTransfer;
        if(!isTransfer){
            initializePaystackTransact();
            warningBtn.setVisibility(View.INVISIBLE);
            transferLayout.setVisibility(View.INVISIBLE);
            timerLayout.setVisibility(View.INVISIBLE);
            cardPaymentLayout.setVisibility(View.VISIBLE);
            if (countDownTimer != null) {
                countDownTimer.cancel();
            }

            confirmationBtn.setText(R.string.pay_now);
            modeTextView.setText(R.string.debit_card);
            confirmationBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(isTransfer) {
                        SuccessDialog successDialog = new SuccessDialog(StartPaymentActivity.this);
                        successDialog.setCallback((data) -> {
                            // Handle the result here
                            if (data != null) {
                                confirmTransferStatus(transferDetailModel.getReference());
                            }
                        });
                        successDialog.show();
                    } else {
                        Log.d(TAG, "Charging Card");
                        performCharge();
                    }
                }
            });

        } else {
            initializeTransfer();
            warningBtn.setVisibility(View.VISIBLE);
            transferLayout.setVisibility(View.VISIBLE);
            timerLayout.setVisibility(View.VISIBLE);
            cardPaymentLayout.setVisibility(View.INVISIBLE);

            timeLeftInMillis = startTimeInMillis;
            startTimer();

            confirmationBtn.setText(R.string.i_ve_sent_the_money);
            modeTextView.setText(R.string.bank_transfer);

            confirmationBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(isTransfer) {
                        confirmTransferStatus(transferDetailModel.getReference());
                    } else {
                        Log.d(TAG, "Charging Card");
                        performCharge();
                    }
                }
            });

        }
    }

    private void showPopupMenu(View view) {
        PopupMenu popupMenu = new PopupMenu(this, view);

        // Create an ArrayList to hold the options
        List<BankAccountModel> options;
        options = bankList;

        // Dynamically populate the popup menu
        for (BankAccountModel option : options) {
            popupMenu.getMenu().add(option.getBankName());
        }

        // Set up the item click listener
        popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                // Handle item click here
                String title = item.getTitle().toString();
                for (BankAccountModel option : bankList) {
                    if (option.getBankName().equals(title)) {
                        // Found the matching item
                        accountModel = option;
                        accountNameTextView.setText(accountModel.getAccountName());
                        accountNumberTextView.setText(accountModel.getAccountNumber());
                        bankNameTextView.setText(accountModel.getBankName());
                        //Toast.makeText(MainActivity.this, "Found item: " + option, Toast.LENGTH_SHORT).show();
                        break; // Stop iterating once found
                    }
                }
                return true;
            }
        });

        // Show the popup menu
        popupMenu.show();
    }

    private void performCharge() {
        Intent intent = getIntent();

        String cardNumber = mCardNumber.getText().toString().replace(" ","");
        String cardExpiry = mCardExpiry.getText().toString();
        String cvv = mCardCVV.getText().toString();

        String[] cardExpiryArray = cardExpiry.split("/");
        int expiryMonth = Integer.parseInt(cardExpiryArray[0]);
        int expiryYear = Integer.parseInt(cardExpiryArray[1]);
        int amountToPay = Integer.parseInt(String.valueOf(paystackDetailModel.getAmount() * 100).split("\\.")[0]);

        if(cardNumber.length() != 16 || cvv.length() != 3 || cardExpiry.length() != 5){
            Toast.makeText(StartPaymentActivity.this, "Please enter a valid card details", Toast.LENGTH_SHORT).show();
            return;
        }
        Card card = new Card(cardNumber, expiryMonth, expiryYear, cvv);

        Charge charge = new Charge();
        charge.setAmount(amountToPay);
        charge.setEmail(email);
        charge.setCard(card);
        isPaying = true;
        progressIndicator.setVisibility(View.VISIBLE);
        confirmationBtn.setText("");
        confirmationBtn.setClickable(false);

        PaystackSdk.chargeCard(this, charge, new Paystack.TransactionCallback() {
            @Override
            public void onSuccess(Transaction transaction) {
                isPaying = false;
                progressIndicator.setVisibility(View.INVISIBLE);
                confirmationBtn.setText(R.string.pay_now);
                confirmationBtn.setClickable(true);
                parseResponse(transaction.getReference());
                SuccessDialog successDialog = new SuccessDialog(StartPaymentActivity.this);
                successDialog.setCallback((data) -> {
                    // Handle the result here
                    if (data != null) {
                        LocalDateTime now = null;
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            now = LocalDateTime.now();
                        }

                        // Define the format for ISO 8601
                        DateTimeFormatter formatter = null;
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                        }

                        // Format the date and time in ISO 8601 format
                        String isoDateTime = "";
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            isoDateTime = now.format(formatter);
                        }
                        DataResponse response = new DataResponse(transaction.getReference(), amount, email, currencyType, "", "","", "successful", "Card", isoDateTime);
                        Gson gson = new Gson();
                        String jsonData = gson.toJson(response);
                        returnResult("Transaction successful", jsonData);
                    }
                });
                successDialog.show();
            }

            @Override
            public void beforeValidate(Transaction transaction) {
                isPaying = false;
                progressIndicator.setVisibility(View.INVISIBLE);
                confirmationBtn.setText(R.string.pay_now);
                confirmationBtn.setClickable(true);
                Log.d(TAG, "beforeValidate: " + transaction.getReference());
            }

            @Override
            public void onError(Throwable error, Transaction transaction) {
                isPaying = false;
                progressIndicator.setVisibility(View.INVISIBLE);
                confirmationBtn.setText(R.string.pay_now);
                confirmationBtn.setClickable(true);
                Log.e(TAG, "onError: " + error.getLocalizedMessage());
                Log.e(TAG, "onError: " + error);
            }

        });
    }

    private void parseResponse(String transactionReference) {
        String message = "Payment Successful - " + transactionReference;
        Log.d(TAG, message);
    }

    void initializePaystack(String publicKey) {
        PaystackSdk.initialize(getApplicationContext());
        PaystackSdk.setPublicKey(publicKey);
    }

    void initializeTransfer(){
        PaymentService apiService = PaymentService.getInstance(isLive);
        PaymentInitModel payment = new PaymentInitModel(amount * 100, email, currencyType, reference, "");

        LoaderUtil.showDialog(this, false);
        Call<TransferDetailResponse> call = apiService.initRequest(pubKey, payment);

        String NETWORK_TAG = "INITIALIZE TRANSFER";
        Log.d(NETWORK_TAG, call.request().headers().toString());
        Log.d(NETWORK_TAG, call.request().url().toString());
        Log.d(NETWORK_TAG, Objects.requireNonNull(call.request().body()).toString());

        call.enqueue(new Callback<TransferDetailResponse>() {
            @Override
            public void onResponse(Call<TransferDetailResponse> call, Response<TransferDetailResponse> response) {
                if (response.isSuccessful()) {
                    TransferDetailResponse apiResponse = response.body();
                    // Handle successful response
                    // Create Gson instance

                    Log.d(NETWORK_TAG, apiResponse.getData().toString());
                    Log.d(NETWORK_TAG, apiResponse.getMessage());

                    APIResponse result = new APIResponse(!apiResponse.isSuccess(), apiResponse.getMessage(), apiResponse.getData());
                    transferDetailModel = (TransferDetailModel) result.getData();

                    Log.d(NETWORK_TAG, transferDetailModel.getAccountNumber());
                    Log.d(NETWORK_TAG, transferDetailModel.getReference());

                    accountNameTextView.setText(transferDetailModel.getAccountName());
                    accountNumberTextView.setText(transferDetailModel.getAccountNumber());
                    bankNameTextView.setText(transferDetailModel.getBankName());

                    String isoDateString = transferDetailModel.getExpiryTime();//.replace("Z","");
                    // Parse the given date string to LocalDateTime
                    LocalDateTime currentTime = null;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        currentTime = LocalDateTime.now();
                    }
                    ZoneId userTimeZone = null;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        userTimeZone = ZoneId.systemDefault();
                    }

                    Instant instant = null;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        instant = Instant.parse(isoDateString);
                    }

                    // Convert the given ISO date to the user's timezone
                    ZonedDateTime givenTime = null;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        givenTime = instant.atZone(userTimeZone);
                    }

                    // Calculate the difference between the current time and the given time
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        Duration duration = Duration.between(currentTime, givenTime);
                        timeLeftInMillis = duration.getSeconds() * 1000;
                        startTimer();
                    }

                    copyRefBtn.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            ClipboardUtils.copyToClipboard(StartPaymentActivity.this, transferDetailModel.getReference());
                        }
                    });

                    copyAccBtn.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            ClipboardUtils.copyToClipboard(StartPaymentActivity.this, transferDetailModel.getAccountNumber());
                        }
                    });

                    refTextView.setText(transferDetailModel.getReference());

                    LoaderUtil.hideDialog();
                    streamTransferResponse(transferDetailModel.getReference());
                } else {
                    Log.e(NETWORK_TAG, response.message());
                    // Handle error response
                    APIResponse result = new APIResponse(true, response.message(), null);
                    returnErrorResult(result.getMessage());
                    LoaderUtil.hideDialog();
                }
            }

            @Override
            public void onFailure(Call<TransferDetailResponse> call, Throwable t) {
                Log.e(NETWORK_TAG, t.getMessage());
                // Handle network errors
                APIResponse result = new APIResponse(true, t.getMessage(), null);
                returnErrorResult(result.getMessage());
                LoaderUtil.hideDialog();
            }
        });
    }

    void initializePaystackTransact(){
        PaymentService apiService = PaymentService.getInstance(isLive);
        PaymentInitModel payment = new PaymentInitModel(amount * 100, email, currencyType, "", "Paystack");

        LoaderUtil.showDialog(this, false);

        Call<ApiResponse> call = apiService.initPaystack(pubKey, payment);

        String NETWORK_TAG = "INITIALIZE PAYSTACK";
        Log.d(NETWORK_TAG, call.request().headers().toString());
        Log.d(NETWORK_TAG, call.request().url().toString());
        Log.d(NETWORK_TAG, Objects.requireNonNull(call.request().body()).toString());

        call.enqueue(new Callback<ApiResponse>() {
            @Override
            public void onResponse(Call<ApiResponse> call, Response<ApiResponse> response) {
                if (response.isSuccessful()) {
                    ApiResponse apiResponse = response.body();
                    // Handle successful response
                    // Create Gson instance

                    Log.d(NETWORK_TAG, apiResponse.getData().toString());
                    Log.d(NETWORK_TAG, apiResponse.getMessage());

                    APIResponse result = new APIResponse(!apiResponse.isSuccess(), apiResponse.getMessage(), apiResponse.getData());
                    String token = result.getData().toString().split("#/")[1];
                    decodePaystackToken(token);
                } else {
                    Log.e(NETWORK_TAG, response.message());
                    // Handle error response
                    APIResponse result = new APIResponse(true, response.message(), null);
                    returnErrorResult(result.getMessage());
                    LoaderUtil.hideDialog();
                }
            }

            @Override
            public void onFailure(Call<ApiResponse> call, Throwable t) {
                Log.e(NETWORK_TAG, t.getMessage());
                // Handle network errors
                APIResponse result = new APIResponse(true, t.getMessage(), null);
                returnErrorResult(result.getMessage());
                LoaderUtil.hideDialog();
            }
        });
    }

    void decodePaystackToken(String token){
        PaymentService apiService = PaymentService.getInstance(isLive);
        Call<PaystackDetailResponse> call = apiService.decodeToken(pubKey, token);

        String NETWORK_TAG = "DECODE PAYSTACK";
        Log.d(NETWORK_TAG, call.request().headers().toString());
        Log.d(NETWORK_TAG, call.request().url().toString());

        call.enqueue(new Callback<PaystackDetailResponse>() {
            @Override
            public void onResponse(Call<PaystackDetailResponse> call, Response<PaystackDetailResponse> response) {
                if (response.isSuccessful()) {
                    PaystackDetailResponse apiResponse = response.body();
                    // Handle successful response
                    // Create Gson instance

                    Log.d(NETWORK_TAG, apiResponse.getData().toString());
                    Log.d(NETWORK_TAG, apiResponse.getMessage());

                    APIResponse result = new APIResponse(!apiResponse.isSuccess(), apiResponse.getMessage(), apiResponse.getData());
                    paystackDetailModel = (PaystackDetailModel) result.getData();
                    initializePaystack(paystackDetailModel.getPublicKey());
                    LoaderUtil.hideDialog();
                } else {
                    Log.e(NETWORK_TAG, response.message());
                    // Handle error response
                    APIResponse result = new APIResponse(true, response.message(), null);
                    returnErrorResult(result.getMessage());
                    LoaderUtil.hideDialog();
                }
            }

            @Override
            public void onFailure(Call<PaystackDetailResponse> call, Throwable t) {
                Log.e(NETWORK_TAG, t.getMessage());
                // Handle network errors
                APIResponse result = new APIResponse(true, t.getMessage(), null);
                returnErrorResult(result.getMessage());
                LoaderUtil.hideDialog();
            }
        });
    }

    void confirmTransferStatus(String ref){
        PaymentService apiService = PaymentService.getInstance(isLive);
        isPaying = true;
        progressIndicator.setVisibility(View.VISIBLE);
        confirmationBtn.setText("");
        confirmationBtn.setClickable(false);

        Call<ApiResponse> call = apiService.confirmTransferStatus(pubKey, ref);

        String NETWORK_TAG = "MANUAL CONFIRMATION";
        Log.d(NETWORK_TAG, call.request().headers().toString());
        Log.d(NETWORK_TAG, call.request().url().toString());

        call.enqueue(new Callback<ApiResponse>() {
            @Override
            public void onResponse(Call<ApiResponse> call, Response<ApiResponse> response) {
                if (response.isSuccessful()) {
                    ApiResponse apiResponse = response.body();
                    // Handle successful response
                    // Create Gson instance

                    Log.d(NETWORK_TAG, apiResponse.getData().toString());
                    Log.d(NETWORK_TAG, apiResponse.getMessage());

                    APIResponse result = new APIResponse(!apiResponse.isSuccess(), apiResponse.getMessage(), apiResponse.getData());
                    isPaying = false;
                    progressIndicator.setVisibility(View.INVISIBLE);
                    confirmationBtn.setText(R.string.i_ve_sent_the_money);
                    confirmationBtn.setClickable(true);

                    SuccessDialog successDialog = new SuccessDialog(StartPaymentActivity.this);
                    successDialog.setCallback((data) -> {
                        // Handle the result here
                        if (data != null) {
                            LocalDateTime now = null;
                            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                now = LocalDateTime.now();
                            }

                            // Define the format for ISO 8601
                            DateTimeFormatter formatter = null;
                            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                            }

                            // Format the date and time in ISO 8601 format
                            String isoDateTime = "";
                            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                isoDateTime = now.format(formatter);
                            }
                            DataResponse dataResponse = new DataResponse(transferDetailModel.getReference(), amount, email, currencyType, "", "","", "successful", "Card", isoDateTime);
                            Gson gson = new Gson();
                            String jsonData = gson.toJson(dataResponse);
                            returnResult("Transaction successful", jsonData);
                        }
                    });
                    successDialog.show();
                } else {
                    Log.e(NETWORK_TAG, response.message());
                    // Handle error response
                    APIResponse result = new APIResponse(true, response.message(), null);
                    //returnErrorResult(result.getMessage());
                    isPaying = false;
                    progressIndicator.setVisibility(View.INVISIBLE);
                    confirmationBtn.setText(R.string.i_ve_sent_the_money);
                    confirmationBtn.setClickable(true);
                }
            }

            @Override
            public void onFailure(Call<ApiResponse> call, Throwable t) {
                Log.e(NETWORK_TAG, t.getMessage());
                // Handle network errors
                APIResponse result = new APIResponse(true, t.getMessage(), null);
                //returnErrorResult(result.getMessage());
                isPaying = false;
                progressIndicator.setVisibility(View.INVISIBLE);
                confirmationBtn.setText(R.string.i_ve_sent_the_money);
                confirmationBtn.setClickable(true);
            }
        });
    }

    void streamTransferResponse(String ref){
        String NETWORK_TAG = "STREAM SERVICE";
        ApiService apiService = PaymentService.getApiService();

        String contentType = "application/json";

        Log.d(NETWORK_TAG, "Starting Streaming Service ========================>");
        Disposable disposable = apiService.streamResponse(isLive ? "live" : "dev", contentType, "Bearer "+pubKey, ref)
            .subscribeOn(Schedulers.io())
            .observeOn(Schedulers.from(new Executor() {
                private final Handler handler = new Handler(Looper.getMainLooper());

                @Override
                public void execute(Runnable command) {
                    handler.post(command);

                    Log.d(NETWORK_TAG, "Handler started ========================>");
                }
            }))
            .subscribeWith(new DisposableObserver<String>() {
                @Override
                public void onNext(String apiResponse) {
                    // Handle API response
                    Log.d(NETWORK_TAG, apiResponse.split("data: ")[1]);
                    Log.d(NETWORK_TAG, "Receiving Streaming Service update ========================>");
                    Gson gson = new Gson();

                    // Convert the string to a JSON object
                    JsonObject jsonObject = gson.fromJson(apiResponse.split("data: ")[1], JsonObject.class);
                    Log.d(NETWORK_TAG, jsonObject.get("status").getAsString());
                    if(Objects.equals(jsonObject.get("status").getAsString(), "successful") || Objects.equals(jsonObject.get("status").getAsString(), "initiated")){
                        isPaying = false;
                        progressIndicator.setVisibility(View.INVISIBLE);
                        confirmationBtn.setText(R.string.i_ve_sent_the_money);
                        confirmationBtn.setClickable(true);

                        SuccessDialog successDialog = new SuccessDialog(StartPaymentActivity.this);
                        successDialog.setCallback((data) -> {
                            // Handle the result here
                            if (data != null) {
                                LocalDateTime now = null;
                                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                    now = LocalDateTime.now();
                                }

                                // Define the format for ISO 8601
                                DateTimeFormatter formatter = null;
                                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                    formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                                }

                                // Format the date and time in ISO 8601 format
                                String isoDateTime = "";
                                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                                    isoDateTime = now.format(formatter);
                                }
                                DataResponse response = new DataResponse(transferDetailModel.getReference(), amount, email, currencyType, "", "","", "successful", "Card", isoDateTime);
                                String jsonData = gson.toJson(response);
                                returnResult("Transaction successful", jsonData);
                            }
                        });
                        successDialog.show();
                    }
                }

                @Override
                public void onError(Throwable e) {
                    // Handle error
                    Log.e(NETWORK_TAG, e.getMessage());
                    Log.e(NETWORK_TAG, "Receiving Streaming Message Error ========================>");

                }

                @Override
                public void onComplete() {
                    // Handle completion
                    Log.d(NETWORK_TAG, "Stopping Streaming Service ========================>");
                }
            });

        // Dispose the disposable when no longer needed
        //disposable.dispose();
    }
}