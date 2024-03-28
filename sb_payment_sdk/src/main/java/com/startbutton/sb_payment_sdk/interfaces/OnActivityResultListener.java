package com.startbutton.sb_payment_sdk.interfaces;

import com.startbutton.sb_payment_sdk.models.APIResponse;

public interface OnActivityResultListener {
    void onActivityResult(int resultCode, APIResponse data);
}
