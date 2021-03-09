import org.apache.xmlrpc.XmlRpcClient;

import java.util.Scanner;
import java.util.Vector;

public class ClientRPC {
    public static void main(String[] args) {
        try {
            Scanner sc = new Scanner(System.in);
            System.out.println("Server url: ");
            String url = sc.nextLine();
            XmlRpcClient srv = new XmlRpcClient(url);
            Vector<Integer> params = new Vector<>();
            params.addElement(13);
            params.addElement(21);
            Object result = srv.execute("MyServer.echo", params);

            int returnVal = (Integer) result;
            System.out.println("Result of MyServer.echo: " + returnVal);

            AC cb = new AC();
            Vector<Integer> params2 = new Vector<>();
            params2.addElement(3000);
            srv.executeAsync("MyServer.execAsy", params2, cb);
            System.out.println("Called asynchronously");
        } catch (Exception e) {
            System.err.println("XML-RPC client: " + e);
        }
    }
}
