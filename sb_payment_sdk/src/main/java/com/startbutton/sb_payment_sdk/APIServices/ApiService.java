package com.startbutton.sb_payment_sdk.APIServices;

import com.startbutton.sb_payment_sdk.models.ApiResponse;
import com.startbutton.sb_payment_sdk.models.PaymentInitModel;
import com.startbutton.sb_payment_sdk.models.PaystackDetailResponse;
import com.startbutton.sb_payment_sdk.models.TransferDetailResponse;

import io.reactivex.Observable;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface ApiService {
    @GET("your/api/endpoint")
    Observable<ApiResponse> getData();

    @GET("streams/va?")
    Observable<String> streamResponse(@Header("x-environment") String environment, @Header("Content-Type") String contentType, @Header("Authorization") String authorization, @Query("txnRef") String txnRef);

    @POST("transaction/initialize-s2s")
    Call<TransferDetailResponse> postData(@Header("Content-Type") String contentType, @Header("Authorization") String authorization, @Body PaymentInitModel payment);

    @POST("transaction/verify-va-collection/{ref}")
    Call<ApiResponse> confirmTransferStatus(@Header("x-environment") String environment, @Header("Content-Type") String contentType, @Header("Authorization") String authorization, @Path("ref") String ref);

    @GET("transaction/get-payment-details/{token}")
    Call<PaystackDetailResponse> decodeToken(@Header("x-environment") String environment, @Header("Content-Type") String contentType, @Header("Authorization") String authorization, @Path("token") String token);

    @POST("transaction/initialize")
    Call<ApiResponse> initPaystack(@Header("x-environment") String environment, @Header("Content-Type") String contentType, @Header("Authorization") String authorization, @Body PaymentInitModel payment);
}
