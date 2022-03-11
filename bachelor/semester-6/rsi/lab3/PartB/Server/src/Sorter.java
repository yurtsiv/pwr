import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Arrays;

public class Sorter extends UnicastRemoteObject
        implements ISorter
{
    private static final long serialVersionUID = 101L;
    public Sorter() throws RemoteException {
        super();
    }


    @Override
    public SorterResult Sort(SorterInput sorterInput) throws RemoteException {
        Arrays.sort(sorterInput.arr);
        return new SorterResult(sorterInput.arr);
    }
}