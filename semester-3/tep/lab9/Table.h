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

    T& operator [](int index) {
        return array_pointer[index];
    }

    bool setNewSize(int newSize) {
        if (newSize < 0) {
            return false;
        }

        length = newSize;
        T* prev_array_p = array_pointer;
        array_pointer = new T[newSize];

        memcpy(array_pointer, prev_array_p, (newSize + sizeof(prev_array_p[0])));

        delete[] prev_array_p;
        return true;
    }


    int getLen() {
        return length;
    }

private:
    T* array_pointer;
    int length;
};