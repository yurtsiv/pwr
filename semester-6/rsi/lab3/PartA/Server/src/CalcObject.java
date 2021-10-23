import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Arrays;

public class CalcObject extends UnicastRemoteObject implements ICalcObject
{
    private String[] students = new String[]{"Kacper Szkodziński", "Robert Hejda", "Vladyslav Shpychko"};
    private String groupName = "Z03-58k";

    protected CalcObject() throws RemoteException
    {
        super();
    }

    @Override
    public double Calculate(double a, double b) throws RemoteException
    {
        return a + b;
    }

    @Override
    public String StudentInGroup(String firstName, String lastName) throws RemoteException {
        var fullName = firstName + " " + lastName;

        var inGroupText = Arrays.stream(students).anyMatch(s -> s.equals(firstName + " " + lastName))
                ? " jest w grupie "
                : " nie jest w grupie ";

        return fullName + inGroupText + groupName;
    }
}
