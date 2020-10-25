#include <string>
#include <cstring>
#include <iostream>
#include "StreamUtils.h"

#define defaultSize 10

template<typename T>
class Table {
public:
    Table(int tableLen) {
        length = tableLen;
        array_pointer = new T[tableLen];
    }

    Table(const Table& other) {
        length = other.length;
        array_pointer = new T[other.length];
        memcpy(array_pointer, other.array_pointer, other.length);
    }

    Table(std::istream& is, int size) {
        array_pointer = new T[size];
        length = size;

        for(int i = 0; i < size; i++)
            set(i, streamGet<T>(is));
    }

    ~Table() {
        delete[] array_pointer;
    }

    T operator *() {
        return *array_pointer;
    }

    T get(int i) const {
        return array_pointer[i];
    }

    void set(int i, T val) { array_pointer[i] = val; }

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

    void setArray(T* new_arr, int len) {
        length = len;
        array_pointer = new_arr;
    }

    Table<T>* slice(int from, int to) {
        if (from < 0 || to < 0 || from > to) new Table<T>(0);

        Table<T>* res = new Table<T>(to - from);
        int res_count = 0;
        for (int i = from; i < to; i++) {
           res->set(res_count, array_pointer[i]);
           res_count++;
        }

        return res;
    }

    friend std::ostream& operator<< (std::ostream& os, const Table<T>& table) {
        for (int i = 0; i < table.length; i++)
            os << table.get(i) << ' ';

        return os;
    }

private:
    T* array_pointer;
    int length;
};