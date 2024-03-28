package com.startbutton.sb_payment_sdk.models;

import com.google.gson.annotations.SerializedName;

public class TransferDetailModel {
    @SerializedName("accountNumber")
    private long accountNumber;

    @SerializedName("reference")
    private String reference;

    @SerializedName("expiryTime")
    private String expiryTime;

    @SerializedName("bankName")
    private String bankName;

    @SerializedName("accountName")
    private String accountName;

    public String getAccountNumber() {
        return String.valueOf(accountNumber);
    }

    public String getReference() {
        return reference;
    }

    public String getExpiryTime() {
        return expiryTime;
    }

    public String getBankName() {
        return bankName;
    }

    public String getAccountName() {
        return accountName;
    }
}
