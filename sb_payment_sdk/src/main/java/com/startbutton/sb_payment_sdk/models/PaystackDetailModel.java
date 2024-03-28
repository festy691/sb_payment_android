package com.startbutton.sb_payment_sdk.models;

import java.io.Serializable;

public class PaystackDetailModel implements Serializable {
    String merchantEmail;
    String customerEmail;
    int amount;
    String partner;
    String publicKey;
    String transactionRef;
    String currency;
    String paymentPartnerId;
    String redirectLink;

    public String getMerchantEmail() {
        return merchantEmail;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public int getAmount() {
        return amount;
    }

    public String getPartner() {
        return partner;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public String getCurrency() {
        return currency;
    }

    public String getPaymentPartnerId() {
        return paymentPartnerId;
    }

    public String getRedirectLink() {
        return redirectLink;
    }
}
