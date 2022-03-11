import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ISorter extends Remote {
    SorterResult Sort(SorterInput calculatorInput) throws RemoteException;
}
