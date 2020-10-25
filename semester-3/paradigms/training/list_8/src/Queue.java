import java.util.ArrayList;

public class Queue<E> implements MyQueue<E> {
    private ArrayList<E> arr;
    private int front = -1, rear = -1;

    Queue(int size) {
        arr = new ArrayList<>(size);
        for (int i = 0; i < size; i++)
            arr.add(null);
    }

    @Override
    public boolean isEmpty() {
        return front == -1;
    }

    @Override
    public boolean isFull() {
        return (front == 0 && rear == arr.size() - 1) || front == rear + 1;
    }

    @Override
    public void enqueue(E x) throws FullException {
        if (isFull()) {
            throw new FullException();
        }

        if (isEmpty()) {
            front = 0;
        }

        rear = (rear + 1) % arr.size();
        arr.set(rear, x);
    }

    @Override
    public void dequeue() {
        if (isEmpty()) return;

        if (front == rear) {
            front = -1;
            rear = -1;
        } else {
            front = (front + 1) % arr.size();
        }
    }

    @Override
    public E first() throws EmptyException {
        if (isEmpty()) {
            throw new EmptyException();
        }

        return arr.get(front);
    }
}
