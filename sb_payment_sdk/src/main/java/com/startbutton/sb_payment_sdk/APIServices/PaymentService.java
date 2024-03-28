package com.startbutton.sb_payment_sdk.APIServices;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.startbutton.sb_payment_sdk.models.ApiResponse;
import com.startbutton.sb_payment_sdk.models.PaymentInitModel;
import com.startbutton.sb_payment_sdk.models.PaystackDetailResponse;
import com.startbutton.sb_payment_sdk.models.TransferDetailResponse;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

public class PaymentService {
    // Private static variable to hold the single instance of the class
    private static PaymentService instance;

    private static String BASE_URL_DEV = "https://api.startbutton.builditdigital.co/";
    private static String BASE_URL_PROD = "https://api.startbutton.builditdigital.co/";
    private static String BASE_URL = BASE_URL_DEV;
    private static ApiService apiService;
    private static ApiService apiServiceStream;
    private static boolean live = false;
    private static OkHttpClient.Builder httpClientBuilder = new OkHttpClient.Builder();

    // Private constructor to prevent instantiation from outside the class
    private PaymentService(boolean isLive) {
        BASE_URL = isLive ? BASE_URL_DEV : BASE_URL_PROD;
        live = isLive;

        httpClientBuilder.connectTimeout(180, TimeUnit.SECONDS); // Increase timeout to 60 seconds
        httpClientBuilder.readTimeout(180, TimeUnit.SECONDS);
        httpClientBuilder.writeTimeout(180, TimeUnit.SECONDS);
        Gson gson = new GsonBuilder().setLenient().create();

        // Initialization code
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .client(httpClientBuilder.build())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .build();

        apiService = retrofit.create(ApiService.class);
    }

    public static ApiService getApiService() {
        if (apiServiceStream == null) {
            // Initialization code
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .client(httpClientBuilder.build())
                    .addConverterFactory(ScalarsConverterFactory.create())
                    .addConverterFactory(StringConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .build();

            apiServiceStream = retrofit.create(ApiService.class);
        }
        return apiServiceStream;
    }

    // Public static method to provide access to the single instance of the class
    public static synchronized PaymentService getInstance(Boolean isLive) {
        // Lazy initialization: create the instance if it doesn't exist yet
        if (instance == null) {
            instance = new PaymentService(isLive);
        }
        return instance;
    }

    /*public Observable<ApiResponse> streamResponse(String token, String ref){
        String contentType = "application/json";
        // Make the API call
        return apiService.streamResponse(live ? "live" : "dev", contentType, "Bearer "+token, ref);
    }*/

    public Call<TransferDetailResponse> initRequest(String token, PaymentInitModel payment){
        String contentType = "application/json";
        // Make the API call
        return apiService.postData(live ? "live" : "dev", contentType, "Bearer "+token, payment);
    }

    public Call<ApiResponse> initPaystack(String token, PaymentInitModel payment){
        String contentType = "application/json";
        // Make the API call
        return apiService.initPaystack(live ? "live" : "dev", contentType, "Bearer "+token, payment);
    }

    public Call<PaystackDetailResponse> decodeToken(String token, String paymentToken){
        String contentType = "application/json";
        // Make the API call
        return apiService.decodeToken(live ? "live" : "dev", contentType, "Bearer "+token, paymentToken);
    }

    public Call<ApiResponse> confirmTransferStatus(String token, String ref){
        String contentType = "application/json";
        // Make the API call
        return apiService.confirmTransferStatus(live ? "live" : "dev", contentType, "Bearer "+token, ref);
    }
}
