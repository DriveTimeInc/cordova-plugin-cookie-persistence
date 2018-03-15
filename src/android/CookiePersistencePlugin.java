package com.drivetime.mobile.cordova;

import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.lang.StringBuilder;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.ConfigXmlParser;
import org.apache.cordova.LOG;

import android.content.Context;
import android.webkit.CookieManager;
import android.app.Activity;

public class CookiePersistencePlugin extends CordovaPlugin {
    private static final String SERVICE_NAME = "CookiePersistencePlugin";
    private static final String LOG_TAG = "CookiePersistenceCordovaPlugin";

    private static final String COOKIE_FILE_PATH = "WebViewCookies.txt";

    private Context _context;
    private String _url;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        _context = cordova.getActivity().getApplicationContext();
        _url = loadConfig(cordova.getActivity());

        updateCookies(_context, _url);

        LOG.d(LOG_TAG, "initialize complete");
    }

    /**
     * Called when the system is about to start resuming a previous activity.
     */
    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        LOG.d(LOG_TAG, "Paused the activity.");

        if (this._context == null) {
            LOG.d(LOG_TAG, "Paused the activity. _context is NULL");
            return;
        }
        LOG.d(LOG_TAG, "Paused the activity.");

        storeCookies(_context, _url);
    }

    public String loadConfig(Activity activity) {
        ConfigXmlParser parser = new ConfigXmlParser();
        parser.parse(activity);
        return parser.getLaunchUrl();
    }

    public void updateCookies(Context context, String url) {
        String storedCookies = readFile(context, COOKIE_FILE_PATH);
        LOG.d(LOG_TAG, "Cookie File Content: \n" + storedCookies);

        if (setWebViewCookies(url, storedCookies)) {
            LOG.d(LOG_TAG, "UpdateCookies - Complete");
        } else {
            LOG.d(LOG_TAG, "UpdateCookies - Failed");
        }
    }

    public void storeCookies(Context context, String url) {
        String cookies = getWebViewCookies(url);

        if (overwriteFile(context, COOKIE_FILE_PATH, cookies)) {
            LOG.d(LOG_TAG, "storeCookies - Complete");
        } else {
            LOG.d(LOG_TAG, "storeCookies - Failed");
        }
    }

    public boolean setWebViewCookies(String url, String cookieString) {
        LOG.d(LOG_TAG, "setWebViewCookies - Started");

        try {
            CookieManager.getInstance().setCookie(url, cookieString);
            return true;
        } catch (Exception e) {
            LOG.e(LOG_TAG, "Exception: " + e.getMessage());
            return false;
        }
    }

    public String getWebViewCookies(String url) {
        try {
            return CookieManager.getInstance().getCookie(url);
        } catch (Exception e) {
            LOG.e(LOG_TAG, "Exception: " + e.getMessage());
            return null;
        }
    }

    public boolean overwriteFile(Context context, String filePath, String fileContents) {
        try {
            FileOutputStream outputStream = context.openFileOutput(filePath, Context.MODE_PRIVATE);
            outputStream.write(fileContents.getBytes());
            outputStream.close();
            LOG.d(LOG_TAG, "Write File - Contents: " + fileContents);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            LOG.e(LOG_TAG,
                "ERROR: 'overwriteFile' failed to write file. Message: "
                    + e.getMessage() + " FilePath:" + filePath);
            return false;
        }
    }

    public String readFile(Context context, String filePath) {
        try {
            StringBuilder text = new StringBuilder();
            FileInputStream in = context.openFileInput(filePath);
            InputStreamReader inputStreamReader = new InputStreamReader(in);
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String line;

            while ((line = bufferedReader.readLine()) != null) {
                text.append(line);
            }

            LOG.d(LOG_TAG, "Read File - Contents: " + text.toString());
            return text.toString();
        } catch (Exception e) {
            e.printStackTrace();
            LOG.d(LOG_TAG,"ERROR" + e.getMessage());
            return null;
        }
    }
}
