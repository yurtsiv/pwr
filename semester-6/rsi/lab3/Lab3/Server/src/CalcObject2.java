import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class CalcObject2 extends UnicastRemoteObject implements ICalcObject2
{
    public CalcObject2() throws RemoteException
    {
        super();
    }

    @Override
    public ResultType Calculate(InputType input) throws RemoteException
    {
        ResultType result = new ResultType();
        result.resultDescription = "Operation " + input.operation;

        var x1 = input.GetX1();
        var x2 = input.GetX2();

        switch (input.operation)
        {
            case "add":
                result.result = x1 + x2;
                break;
            case "sub":
                result.result = x1 - x2;
                break;
            default:
                result.result = 0;
                result.resultDescription = "Operation is not available";
                break;
        }

        return result;
    }
}
