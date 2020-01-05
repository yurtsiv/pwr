#include <string>
#include <cstring>
#include <iostream>

#define defaultSize 10

template<typename T>
class Table {
public:
    Table() {
        length = defaultSize;
        array_pointer = new T[defaultSize];
    }

    Table(int tableLen) {
        length = tableLen;
        array_pointer = new T[tableLen];
    }

    Table(const Table& other) {
        length = other.length;
        array_pointer = new T[other.length];
        memcpy(array_pointer, other.array_pointer, other.length);
    }

    ~Table() {
        delete[] array_pointer;
    }

    bool setNewSize(int newSize) {
        if (newSize < 0) {
            return false;
        }

        length = newSize;
        T* prev_array_p = array_pointer;
        array_pointer = new T[newSize];

        memcpy(array_pointer, prev_array_p, newSize);

        delete[] prev_array_p;
        return true;
    }


    void setValueAt(int offset, T newVal) {
        if (offset >= length) {
            return;
        }

        array_pointer[offset] = newVal;
    }

    int getLen() {
        return length;
    }

private:
    T* array_pointer;
    int length;
};