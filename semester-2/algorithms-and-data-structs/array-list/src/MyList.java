package lab1;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class MyList<E> implements Iterable<E> {
    private int size = 0;
    private E[] array;
    private static final int DEFAULT_CAPACITY = 20;

    public MyList(int initSize) {
        array = (E[])new Object[initSize];
    }

    public MyList() {
        this(DEFAULT_CAPACITY);
    }

    public int size() {
        return size;
    }

    public boolean isEmpty() {
       return size == 0;
    }

    public boolean contains(Object elem) {
        return indexOf(elem) != -1;
    }

    public int indexOf(Object elem) {
        Iterator<E> iter = iterator();

        int counter = 0;
        while(iter.hasNext()) {
            E nextElem = iter.next();
            if (elem.equals(nextElem)) {
                return counter;
            }
            counter++;
        }

        return -1;
    }

    private void checkIndexValidity(int index) {
        if (index < 0 || index >= size) {
            throw new IllegalArgumentException("Index out of bound - " + index);
        }
    }

    public E get(int index) {
        checkIndexValidity(index);
        return array[index];
    }

    public E set(int index, E elem) {
        checkIndexValidity(index);
        E res = array[index];
        array[index] = elem;
        return res;
    }

    private void shiftRight(int shiftFrom) {
        E nextElem = null;
        for (int i = shiftFrom; i < size; i++) {
            if (i == shiftFrom) {
                nextElem = array[i+1];
                array[i+1] = array[i];
            } else {
                E tmp = array[i+1];
                array[i+1] = nextElem;
                nextElem = tmp;
            }
        }

        size++;
    }

    private void shiftLeft(int shiftFrom) {
        for (int i = shiftFrom; i < size; i++) {
            array[i-1] = array[i];
        }
        size--;
    }

    public E remove(int index) {
        checkIndexValidity(index);

        E res = array[index];
        shiftLeft(index + 1);
        return res;
    }

    public boolean remove(Object elem) {
        int index = indexOf(elem);
        if (index == -1) {
            return false;
        }

        shiftLeft(index + 1);
        return true;
    }

    private void ensureCapacity() {
        if (size == array.length) {
            int newLength = (int)(size + size * 0.5);
            E[] newArr = (E[])new Object[newLength];
            System.arraycopy(array, 0, newArr, 0, array.length);
            array = newArr;
        }
    }

    public boolean add(E elem) {
        ensureCapacity();
        array[size] = elem;
        size++;
        return true;
    }

    public void add(int index, E elem) {
        checkIndexValidity(index);
        ensureCapacity();
        shiftRight(index);
        array[index] = elem;
    }

    public void clear() {
        array = (E[])new Object[DEFAULT_CAPACITY];
        size = 0;
    }

    @Override
    public Iterator<E> iterator() {
        return new Iterator<E>() {
            private int currentIndex = -1;
            private boolean isRemoveCalledAfterNext = true;

            @Override
            public boolean hasNext() {
                return currentIndex < size - 1;
            }

            @Override
            public E next() {
                if (currentIndex >= size) {
                    throw new NoSuchElementException("No next elem");
                }

                isRemoveCalledAfterNext = false;
                return array[++currentIndex];
            }

            @Override
            public void remove() {
                if (isRemoveCalledAfterNext) {
                    throw new IllegalStateException("remove() has already been called after previous next()");
                }

                isRemoveCalledAfterNext = true;
                MyList.this.remove(currentIndex);
                currentIndex--;
            }
        };
    }
}



