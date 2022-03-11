import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;

public class Main {

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Enter RMI address: //host/service_name");
            return;
        }

        try {
            LocateRegistry.createRegistry(1099);
        } catch (RemoteException ex) {
        }

        if (System.getSecurityManager() == null) {
            System.setSecurityManager(new SecurityManager());
        }

        try
        {
            Sorter calculator = new Sorter();
            java.rmi.Naming.rebind(args[0], calculator);

            System.out.println(args[0] + " is registered");
        }
        catch (Exception ex)
        {
            System.out.println(args[0] + " couldn't be registered");
            ex.printStackTrace();
        }
    }
}
