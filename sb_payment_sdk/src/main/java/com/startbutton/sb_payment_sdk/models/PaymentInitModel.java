package com.startbutton.sb_payment_sdk.models;

public class PaymentInitModel {
    private double amount;
    private String email;
    private String currency;
    private String reference;
    private String partner;

    public PaymentInitModel(double amount, String email, String currency, String reference, String partner) {
        this.amount = amount;
        this.email = email;
        this.currency = currency;
        this.reference = reference;
        this.partner = partner;
    }
}
