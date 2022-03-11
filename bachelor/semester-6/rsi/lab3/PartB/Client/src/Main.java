import java.util.Arrays;

public class Main {

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("You have to enter RMI object address in the form: host_address/service_name host_address/service_name host_address/service_name");
            return;
        }

        if (System.getSecurityManager() == null)
        {
            System.setSecurityManager(new SecurityManager());
        }

        String server1 = args[0];
        String server2 = args[1];

        ISorter sorter1;
        ISorter sorter2;

        try {
            sorter1 = (ISorter) java.rmi.Naming.lookup(server1);
            System.out.println("Connected to " + server1);
        } catch (Exception e) {
            System.out.println("Couldn't find " + server1);
            e.printStackTrace();
            return;
        }

        try {
            sorter2 = (ISorter) java.rmi.Naming.lookup(server2);
            System.out.println("Connected to " + server2);
        } catch (Exception e) {
            System.out.println("Couldn't find " + server2);
            e.printStackTrace();
            return;
        }


        try {
            int[] arr1 = {5, 2, 9, 10, 13, 11, 4};
            SorterInput input1 = new SorterInput(arr1);
            int[] res = sorter1.Sort(input1).arr;
            System.out.println("Res 1: " + Arrays.toString(res));
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        try {
            int[] arr2 = {20, 18, 16, 17, 15, 14, 13, 10, 8, 6, 4, 2};
            SorterInput input2 = new SorterInput(arr2);
            int[] res = sorter2.Sort(input2).arr;
            System.out.println("Res 2: " + Arrays.toString(res));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
