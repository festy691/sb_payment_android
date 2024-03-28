package com.startbutton.sb_payment_sdk.models;

public class DataResponse {
    String reference;
    double amount;
    String email;
    String currency;
    String bankName;
    String accountName;
    String accountNumber;
    String paymentStatus;
    String paymentType;
    String paymentDate;

    public DataResponse(String reference, double amount, String email, String currency, String bankName, String accountName, String accountNumber, String paymentStatus, String paymentType, String paymentDate) {
        this.reference = reference;
        this.amount = amount;
        this.email = email;
        this.currency = currency;
        this.bankName = bankName;
        this.accountName = accountName;
        this.accountNumber = accountNumber;
        this.paymentStatus = paymentStatus;
        this.paymentType = paymentType;
        this.paymentDate = paymentDate;
    }
}
