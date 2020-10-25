package lab2;

import java.util.NoSuchElementException;

public class Queue<E> {
    private class Element<T> {
        Element<T> next = null;
        T value;

        public Element(T value) {
            this.value = value;
        }

        public void setNext(Element<T> next) {
            this.next = next;
        }

        public Element<T> getNext() {
            return next;
        }

        public T getValue() {
            return value;
        }
    }

    private Element<E> head = null, tail = null;
    private int size = 0;

    public void enqueue(E value) {
       Element<E> elem = new Element<>(value);

       if (size == 0) {
          head = elem;
       } else if (size == 1) {
           head.setNext(elem);
           tail = elem;
       } else {
           tail.setNext(elem);
           tail = elem;
       }

       size++;
    }

    public E dequeue() {
        if (size == 0) {
            throw new NoSuchElementException("Calling dequeue() on an empty queue");
        }

        E res = head.getValue();

        if (size == 1) {
            head = null;
        } else if (size == 2) {
            head = tail;
            tail = null;
        } else {
            Element<E> nextHead = head.getNext();
            head = nextHead;
        }

        size--;
        return res;
    }

    public E peek() {
        if (size == 0) {
            throw new NoSuchElementException("Calling peek() on an empty queue");
        }

        return head.getValue();
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int size() {
        return size;
    }

    public void clear() {
        head = null;
        tail = null;
        size = 0;
    }

    public boolean contains(E value) {
        return indexOf(value) != -1;
    }

    public int indexOf(E value) {
        if (size == 0) {
            return -1;
        }

        int counter = 0;
        Element<E> nextElem = head;
        while(nextElem != null) {
            if (value.equals(nextElem.getValue())) {
                return counter;
            }

            nextElem = nextElem.getNext();
            counter++;
        }

        return -1;
    }
}
