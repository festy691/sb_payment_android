package com.startbutton.sb_payment_sdk.models;

import java.io.Serializable;

public class ManualVerificationModel implements Serializable {
    String toAccountNumber;
    String type;
    String customerName;
    int amount;
    String status;
    String transactionReference;
    String createdAt;
    String reference;
    String updatedAt;
    String transactionId;
    boolean isFee;
    String partnerId;
    String businessName;
    String merchantId;
    String transType;
    String customerId;
    boolean otherFeeCollected;

    public ManualVerificationModel(String id, String toAccountNumber, String type, String customerName, int amount, String status, String transactionReference, String createdAt, String reference, String updatedAt, String transactionId, boolean isFee, String partnerId, String businessName, String merchantId, String transType, String customerId, boolean otherFeeCollected) {
        this.toAccountNumber = toAccountNumber;
        this.type = type;
        this.customerName = customerName;
        this.amount = amount;
        this.status = status;
        this.transactionReference = transactionReference;
        this.createdAt = createdAt;
        this.reference = reference;
        this.updatedAt = updatedAt;
        this.transactionId = transactionId;
        this.isFee = isFee;
        this.partnerId = partnerId;
        this.businessName = businessName;
        this.merchantId = merchantId;
        this.transType = transType;
        this.customerId = customerId;
        this.otherFeeCollected = otherFeeCollected;
    }

    public String getToAccountNumber() {
        return toAccountNumber;
    }

    public void setToAccountNumber(String toAccountNumber) {
        this.toAccountNumber = toAccountNumber;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionReference() {
        return transactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public boolean isFee() {
        return isFee;
    }

    public void setFee(boolean fee) {
        isFee = fee;
    }

    public String getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(String partnerId) {
        this.partnerId = partnerId;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(String merchantId) {
        this.merchantId = merchantId;
    }

    public String getTransType() {
        return transType;
    }

    public void setTransType(String transType) {
        this.transType = transType;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public boolean isOtherFeeCollected() {
        return otherFeeCollected;
    }

    public void setOtherFeeCollected(boolean otherFeeCollected) {
        this.otherFeeCollected = otherFeeCollected;
    }
}
