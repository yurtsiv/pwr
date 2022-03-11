import org.apache.xmlrpc.XmlRpcClient;

import java.util.List;
import java.util.Vector;
import java.util.stream.Collectors;

public class ClientRPC {
    private static String SERVER_NAME = "MyServer";

    static void mainMenu(Vector<Vector<String>> methods, XmlRpcClient srv) {
        AC callback = new AC();

        while (true) {
            List<String> options = methods.stream().map(m -> m.get(0) + " " + m.get(1)).collect(Collectors.toList());

            int option = UserInteraction.selectOption("Choose method", options);

            String[] paramsTypes = methods.get(option).get(2).split(",");
            Vector<Object> params = new Vector<>();

            for (String type : paramsTypes) {
                if (type.equals("int")) {
                    params.addElement(UserInteraction.getInt("Enter an int", Integer.MIN_VALUE, Integer.MAX_VALUE));
                } else if (type.equals("String")) {
                    params.addElement(UserInteraction.getStr("Enter a string"));
                } else {
                    throw new IllegalArgumentException("Unsupported param type");
                }
            }

            boolean asyncMethod = methods.get(option).get(4).equals("async");
            String methodName = SERVER_NAME + "." + methods.get(option).get(0);

            try {
                if (asyncMethod) {
                    srv.executeAsync(methodName, params, callback);
                } else {
                   Object result = srv.execute(methodName, params);
                   System.out.println("Result: " + result);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        try {
            String url = UserInteraction.getStr("Server URL: ");
            XmlRpcClient srv = new XmlRpcClient(url);

            Vector<Vector<String>> methods = (Vector<Vector<String>>) srv.execute(SERVER_NAME + ".show", new Vector<>());
            mainMenu(methods, srv);
        } catch (Exception e) {
            System.err.println("XML-RPC client: " + e);
        }
    }
}