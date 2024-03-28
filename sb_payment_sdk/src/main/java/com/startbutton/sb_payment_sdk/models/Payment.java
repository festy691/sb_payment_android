package com.startbutton.sb_payment_sdk.models;

public class Payment {
    private double amount;
    private String email;
    private String reference;
    private CurrencyType currencyType;

    public Payment(double amount, String email, CurrencyType currencyType, String reference) {
        this.amount = amount;
        this.email = email;
        this.currencyType = currencyType;
        this.reference = reference;
    }

    // Getters and setters
    public double getAmount() {
        return amount;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public CurrencyType getCurrencyType() {
        return currencyType;
    }

    public void setCurrencyType(CurrencyType currencyType) {
        this.currencyType = currencyType;
    }
}
