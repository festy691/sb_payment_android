package com.startbutton.sb_payment_sdk.Utils;

import android.content.Context;

public class LoaderUtil {

    private static Loader loader;

    public static void showDialog(Context context, boolean isCancelable) {
        hideDialog();
        if (context != null) {
            try {
                loader = new Loader(context);
                loader.setCanceledOnTouchOutside(true);
                loader.setCancelable(isCancelable);
                loader.show();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void hideDialog() {
        if (loader != null && loader.isShowing()) {
            try {
                loader.dismiss();
                loader = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
