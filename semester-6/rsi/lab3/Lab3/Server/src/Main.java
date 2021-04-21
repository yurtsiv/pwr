import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class Main
{

    public static void main(String[] args)
    {
        if (args.length < 2)
        {
            System.out.println("You have to enter RMI objects address in the form: //host_address/service_name1 " + "//host_address/service_name2");
            return;
        }
        if (System.getSecurityManager() == null)
        {
            System.setSecurityManager(new SecurityManager());
        }

        try
        {
            Registry reg = LocateRegistry.createRegistry(1099);
        }
        catch (RemoteException ex)
        {
            ex.printStackTrace();
        }

        // Service1
        try
        {
            var remoteObj1 = new CalcObject();
            java.rmi.Naming.rebind(args[0], remoteObj1);

            System.out.println("Service1 has been successfully registered");
        }
        catch (Exception ex)
        {
            System.out.println("There was an error during service registering service1");
            ex.printStackTrace();
        }

        // Service2
        try
        {
            var remoteObj1 = new CalcObject2();
            java.rmi.Naming.rebind(args[1], remoteObj1);

            System.out.println("Service2 has been successfully registered");
        }
        catch (Exception ex)
        {
            System.out.println("There was an error during service registering service2");
            ex.printStackTrace();
        }
    }
}
