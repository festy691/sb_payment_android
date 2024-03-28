package com.startbutton.sb_payment_sdk.Utils;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Window;
import android.widget.LinearLayout;

import com.startbutton.sb_payment_sdk.R;

public class Loader extends Dialog {

    public Loader(Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_loader);
        getWindow().setLayout(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
        );
        getWindow().setBackgroundDrawableResource(R.color.white_transparent);
    }
}