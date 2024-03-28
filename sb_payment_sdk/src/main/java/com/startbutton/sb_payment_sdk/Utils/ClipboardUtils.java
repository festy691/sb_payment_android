package com.startbutton.sb_payment_sdk.Utils;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.widget.Toast;

public class ClipboardUtils {

    public static void copyToClipboard(Context context, String text) {
        // Get the clipboard manager
        ClipboardManager clipboard = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);

        // Create a ClipData object to hold the text
        ClipData clip = ClipData.newPlainText("Copied Text", text);

        // Set the ClipData on the clipboard
        if (clipboard != null) {
            clipboard.setPrimaryClip(clip);
            Toast.makeText(context, "Text copied to clipboard", Toast.LENGTH_SHORT).show();
        }
    }
}