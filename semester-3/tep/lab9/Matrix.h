#include "Table.h"
#include <iostream>


using namespace std;

template <typename T>
class Matrix {
public:
    Matrix(int width, int height) {
        resize(width, height);
    }

    ~Matrix() {
        delete[] table;
    }

    void resize(int width, int height) {
        this->width = width;
        this->height = height;
        table = new T[width * height];
    }

    void set(int x, int y, T val) {
        table[x * width + y] = val;
    }

    T get(int x, int y) {
        return table[x * width + y];
    }

    void print() {
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                cout << " " << get(j, i);
            }
            cout << endl;
        }
    }

private:
    T* table;
    int width;
    int height;
};