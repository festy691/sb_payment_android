package com.startbutton.sb_payment_sdk.models;

import com.google.gson.annotations.SerializedName;

public class ManualVerificationResponse {

    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private String message;

    @SerializedName("data")
    private ManualVerificationModel data;

    // Getters and setters

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(ManualVerificationModel data) {
        this.data = data;
    }

}
