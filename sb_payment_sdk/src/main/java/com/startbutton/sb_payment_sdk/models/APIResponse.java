package com.startbutton.sb_payment_sdk.models;

import com.google.gson.annotations.SerializedName;

public class APIResponse {
    @SerializedName("success")
    private boolean error;
    @SerializedName("message")
    private String message;
    @SerializedName("data")
    private Object data;

    public APIResponse(){
        this.error = true;
    }

    public APIResponse(boolean error, String message, Object data) {
        this.error = error;
        this.message = message;
        this.data = data;
    }

    public boolean getError() {
        return error;
    }

    public void setError(boolean error) {
        this.error = error;
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

    public void setData(Object data) {
        this.data = data;
    }
}
