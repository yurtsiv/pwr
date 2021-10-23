import java.io.Serializable;

public class SorterInput implements Serializable {
    private static final long serialVersionUID = 101L;

    int[] arr;

    public SorterInput(int[] arr)
    {
        this.arr = arr;
    }
}
