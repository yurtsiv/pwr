import com.sun.xml.internal.ws.util.StringUtils;
import org.apache.xmlrpc.WebServer;

import java.util.Scanner;

public class ServerRPC {
    public int sub(int x, int y) {
        return x - y;
    }

    public String repeatStr(String str, int times) {
        if (times < 0) {
            throw new IllegalArgumentException("Second param should be >= 0");
        }

        StringBuilder res = new StringBuilder();
        for (int i = 0; i < times; i++) {
            res.append(str);
        }

        return res.toString();
    }

    public String asyncEcho(int waitSecs, String res) {
        try {
            Thread.sleep(waitSecs * 1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        }

        return res;
    }

    public String[][] show() {
        return new String[][] {
                {"sub", "Subtract numbers. Example: sub(1, 2) == -1", "int,int", "int", "sync"},
                {"repeatStr", "Repeat string n times. Example: repeatStr(\"hi\", 2) == \"hihi\".", "String,int", "String", "sync"},
                {"asyncEcho", "Return the passed string after some time. Example: asyncEcho(10, \"Hello\") == \"Hello\"", "int,String", "String", "async"}
        };
    }

    public static void main(String[] args) {
        try {
            System.out.println("Starting XML-RPC server...");
            Scanner sc = new Scanner(System.in);
            System.out.println("Server port: ");
            int port = sc.nextInt();

            WebServer server = new WebServer(port);
            server.addHandler("MyServer", new ServerRPC());

            server.start();
            System.out.println("Server is started");
            System.out.println("Listening on port: " + port);
            System.out.println("Press Ctrl+C to stop the server");
        } catch (Exception exception) {
            System.err.println("Server XML-RPC: " + exception);
        }
    }
}
