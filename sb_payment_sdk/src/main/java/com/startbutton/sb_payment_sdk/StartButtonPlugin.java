package com.startbutton.sb_payment_sdk;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.startbutton.sb_payment_sdk.interfaces.OnActivityResultListener;
import com.startbutton.sb_payment_sdk.models.APIResponse;
import com.startbutton.sb_payment_sdk.models.BankAccountModel;
import com.startbutton.sb_payment_sdk.models.Payment;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public class StartButtonPlugin {
    private static boolean sdkInitialized = false;
    private static boolean live = false;
    private static String pKey = "";
    private static List<BankAccountModel> bankList = new ArrayList<>();
    private static final String TAG = "START_BUTTON_PLUGIN";
    public static APIResponse initialize(@NonNull String publicKey, boolean isLive) throws ExecutionException, InterruptedException {
        Log.i(TAG, "Initializer started");
        CompletableFuture<APIResponse> runTask = CompletableFuture.supplyAsync(() -> {
            // Your asynchronous task
            APIResponse response = new APIResponse();

            if (sdkInitialized) {
                response.setError(false);
                response.setMessage("SDK Initialized");
                Log.i(TAG, response.getMessage());
                return response;
            }

            if (publicKey.isEmpty()) {
                response.setMessage("publicKey cannot be null or empty");
                response.setError(true);
                Log.e(TAG, response.getMessage());
                return response;
            }

            live = isLive;
            pKey = publicKey;

            // Using cascade notation to build the platform specific info
            try {
                sdkInitialized = true;
                response.setError(false);
                response.setMessage("SDK Initialized");
                Log.i(TAG, response.getMessage());
                return response;
            } catch (Exception e) {
                e.printStackTrace();
                response.setMessage(e.getMessage());
                response.setError(true);
                Log.e(TAG, response.getMessage());
                return response;
            }
        });

        APIResponse result = new APIResponse();
        try {
            bankList.add(new BankAccountModel("0", "0123456789", "Test User1", "Test Bank 1"));
            bankList.add(new BankAccountModel("1", "0129875643", "Test User2", "Test Bank 2"));
            bankList.add(new BankAccountModel("2", "9871234056", "Test User3", "Test Bank 3"));
            result = runTask.get();
            return result;
        } catch (Exception e){
            e.printStackTrace();
            result.setMessage(e.getMessage());
            result.setError(true);
            Log.e(TAG, result.getMessage());
            return result;
        }
    }

    public static void dispose() {
        pKey = "";
        sdkInitialized = false;
    }

    public static boolean isSdkInitialized() {
        return sdkInitialized;
    }

    @NonNull
    public static String getPublicKey() {
        // Validate that the sdk has been initialized
        validateSdkInitialized();
        return pKey;
    }

    static APIResponse performChecks() {
        //validate that sdk has been initialized
        String error = validateSdkInitialized();
        APIResponse response = new APIResponse();

        if(error != null) {
            response.setError(true);
            response.setMessage(error);
            return response;
        }

        //check for null value, and length and starts with pk_
        if (pKey.isEmpty() || !pKey.startsWith("sb_")) {
            response.setError(true);
            response.setMessage("Invalid public key. You must use a valid public key. Ensure that you have set a public key.");
            Log.e(TAG, response.getMessage());
            return response;
        }
        response.setError(false);
        response.setMessage("Check completed");
        Log.i(TAG, response.getMessage());
        return response;
    }

    @Nullable
    private static String validateSdkInitialized() {
        if (!sdkInitialized) {
            return "StartButton SDK has not been initialized. The SDK has to be initialized before use";
        }
        return null;
    }

    public static Object makePayment(Activity activity, Payment charge, OnActivityResultListener listener) {
        APIResponse _checkResponse = performChecks();
        if(_checkResponse.getError()) {
            return _checkResponse;
        }

        Intent intent = new Intent(activity, StartPaymentActivity.class);
        Gson gson = new Gson();
        String jsonArray = gson.toJson(bankList);

        intent.putExtra("email", charge.getEmail());
        intent.putExtra("isLive", live);
        intent.putExtra("pubKey", pKey);
        intent.putExtra("amount", charge.getAmount());
        intent.putExtra("reference", charge.getReference());
        intent.putExtra("currencyType", charge.getCurrencyType().name());
        intent.putExtra("bankList", jsonArray);

        /*StartPaymentActivity paymentActivity = new StartPaymentActivity((responseCode, result) -> {
            // Handle the result from ActivityB here in the utility class
            Log.i(TAG, "Response Code: " + responseCode);
            Log.i(TAG, "Response Data: " + result);
            listener.onActivityResult(responseCode, result);
        });*/

        //activity.startActivity(paymentActivity);
        StartPaymentActivity.setCallback(listener);
        //intent.putExtra("listener", listener);
        activity.startActivity(intent);
        return null;
    }

}
