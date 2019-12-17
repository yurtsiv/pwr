import java.util.Collection;

public class Print {
    public static <T extends Person> void print(Collection<T> list) {
        Person[] arr = (Personlist.toArray();
        for (int i = 0; i < list.size(); i++) {
            Person p = arr[i];
            p.print();
        }
    }
}
