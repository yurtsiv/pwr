package lab2;

import java.util.NoSuchElementException;

public class Stack<E> {
    private class Element<T> {
        T value;
        Element<T> next = null;

        public Element(T value, Element<T> next) {
            this.value = value;
            this.next = next;
        }

        public Element(T value) {
            this.value = value;
        }

        T getValue() {
            return value;
        }

        Element<T> getNext() {
            return next;
        }
    }

    private Element<E> top;
    private int size = 0;

    public void push(E value) {
       Element<E> elem = size == 0 ? new Element<>(value) : new Element<>(value, top);
       top = elem;
       size++;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int size() {
        return size;
    }

    public int indexOf(E value) {
        if (size == 0) {
            return -1;
        }

        Element<E> nextElem = top;
        int counter = 0;

        while(nextElem != null) {
            if (value.equals(nextElem.getValue())) {
                return counter;
            }

            nextElem = nextElem.getNext();
            counter++;
        }

        return -1;
    }

    public boolean contains(E value) {
        return indexOf(value) != -1;
    }

    public void clear() {
        top = null;
        size = 0;
    }

    public E peek() {
        if (isEmpty()) {
            throw new NoSuchElementException("Calling peek() on an empty stack");
        }

        return top.getValue();
    }

    public E pop() {
        if (isEmpty()) {
            throw new NoSuchElementException("Calling pop() on an empty stack");
        }

        Element<E> next = top.getNext();
        E res = top.getValue();
        top = next;
        size--;
        return res;
    }
}
