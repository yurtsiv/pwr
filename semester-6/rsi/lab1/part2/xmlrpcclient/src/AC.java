import org.apache.xmlrpc.AsyncCallback;

import java.net.URL;

public class AC implements AsyncCallback {
    @Override
    public void handleResult(Object result, URL url, String method) {
        System.out.println("Result of async method " + method + ": " + result);
    }

    @Override
    public void handleError(Exception e, URL url, String method) {
        System.err.println("Error in async method " + method + ": " + e);
    }
}
