import org.apache.xmlrpc.WebServer;

import java.util.Scanner;

public class ServerRPC {
    public Integer echo(int x, int y) {
        return x + y;
    }

    public int execAsy(int x) {
        System.out.println("execAsy is called. Calculating...");

        try {
            Thread.sleep(x);
        } catch (InterruptedException e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        }

        System.out.println("execAsy finished");

        return 123;
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
