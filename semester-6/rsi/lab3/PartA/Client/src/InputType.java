import java.io.Serializable;

public class InputType implements Serializable
{
    String operation;
    public double x1;
    public double x2;

    public double GetX1()
    {
        return x1;
    }

    public double GetX2()
    {
        return x2;
    }
}
