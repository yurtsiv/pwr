import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class CalcObject extends UnicastRemoteObject implements ICalcObject
{
    protected CalcObject() throws RemoteException
    {
        super();
    }

    @Override
    public double Calculate(double a, double b) throws RemoteException
    {
        return a + b;
    }
}
