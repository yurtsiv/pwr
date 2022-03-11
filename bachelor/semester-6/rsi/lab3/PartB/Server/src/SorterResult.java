import java.io.Serializable;

public class SorterResult implements Serializable {
    private static final long serialVersionUID = 102L;
    int[] arr;

    public SorterResult(int[] arr)
    {
        this.arr = arr;
    }
}