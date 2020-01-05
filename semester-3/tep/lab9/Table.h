#include <string>
#include <cstring>
#include <iostream>

#define defaultSize 10

class Table {
public:
    Table() {
        length = defaultSize;
        array_pointer = new int[defaultSize];
    }

    Table(int tableLen) {
        length = tableLen;
        array_pointer = new int[tableLen];
    }

    Table(const Table& other):
            length(other.length)
    {
        array_pointer = new int[other.length];
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
        int* prev_array_p = array_pointer;
        array_pointer = new int[newSize];

        memcpy(array_pointer, prev_array_p, newSize);

        delete[] prev_array_p;
        return true;
    }


    void setValueAt(int offset, int newVal) {
        if (offset >= length) {
            return;
        }

        array_pointer[offset] = newVal;
    }

    void print() {
        for (int i = 0; i < length; i++) {
            std::cout << array_pointer[i] << " ";
        }

        std::cout << std::endl;
    }


    int getLen() {
        return length;
    }

private:
    int* array_pointer;
    int length;
};