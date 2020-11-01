public interface ITree<T> {
    void insert(T element) throws TreeInsertionException;
    boolean contains(T element);
}
