package com.startbutton.sb_payment_sdk.models;

public class BankAccountModel {
    private String id;
    private String accountNumber;
    private String accountName;
    private String bankName;

    public BankAccountModel(String id, String accountNumber, String accountName, String bankName){
        this.id = id;
        this.accountNumber = accountNumber;
        this.accountName = accountName;
        this.bankName = bankName;
    }

    public String getId () {
        return this.id;
    }

    public void setId (String id) {
        this.id = id;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
}
