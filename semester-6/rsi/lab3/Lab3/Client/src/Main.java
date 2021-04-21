public class Main
{
    public static void main(String[] args)
    {
        ICalcObject remoteObj1;
        double result1;

        ICalcObject2 remoteObj2;
        ResultType result2;
        InputType input2 = new InputType();
        input2.x1 = 12.5;
        input2.x2 = 4.7;
        input2.operation = "add";

        if (args.length < 2)
        {
            System.out.println("You have to enter RMI objects address in the form: //host_address/service_name1 " + "//host_address/service_name2");
            return;
        }

        if (System.getSecurityManager() == null)
        {
            System.setSecurityManager(new SecurityManager());
        }

        var address1 = args[0];
        var address2 = args[1];

        try
        {
            remoteObj1 = (ICalcObject) java.rmi.Naming.lookup(address1);
        }
        catch (Exception ex)
        {
            System.out.println("There was an error while resolving reference to " + address1);
            ex.printStackTrace();
            return;
        }

        try
        {
            remoteObj2 = (ICalcObject2) java.rmi.Naming.lookup(address2);
        }
        catch (Exception ex)
        {
            System.out.println("There was an error while resolving reference to " + address2);
            ex.printStackTrace();
            return;
        }

        try
        {
            result1 = remoteObj1.Calculate(1.1, 2.2);
        }
        catch (Exception ex)
        {
            System.out.println("There was an error while calling remote method");
            ex.printStackTrace();
            return;
        }
        System.out.println("Result1 is " + result1);

        try
        {
            result2 = remoteObj2.Calculate(input2);
        }
        catch (Exception ex)
        {
            System.out.println("There was an error while calling remote method");
            ex.printStackTrace();
            return;
        }
        System.out.println("Result2 is " + result2.result + " " + result2.resultDescription);
    }
}
