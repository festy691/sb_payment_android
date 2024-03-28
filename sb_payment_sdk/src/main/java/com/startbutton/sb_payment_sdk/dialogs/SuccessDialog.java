package com.startbutton.sb_payment_sdk.dialogs;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;

import com.startbutton.sb_payment_sdk.R;
import com.startbutton.sb_payment_sdk.interfaces.OnTap;

public class SuccessDialog extends Dialog {

    public Activity c;
    public Dialog d;
    public Button continueBtn;

    private static OnTap callback;
    public static void setCallback(OnTap callbackFunction) {
        callback = callbackFunction;
    }

    // Example method where you have the result
    private void returnResult() {
        if (callback != null) {
            callback.onActivityResult("Transaction processing");
        }
        dismiss();
    }


    public SuccessDialog(Activity a) {
        super(a);
        // TODO Auto-generated constructor stub
        this.c = a;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_success_dialog);
        continueBtn = (Button) findViewById(R.id.confirmTranBtn);
        continueBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                returnResult();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        // Set dialog not dismissable
        setCancelable(false);
    }
}