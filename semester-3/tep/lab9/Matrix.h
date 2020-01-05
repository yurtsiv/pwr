#include <iostream>
#include "Table.h"

using namespace std;

template <typename T>
class Matrix {
public:
    Matrix(int width, int height) {
        resize(width, height);
    }

    void resize(int width, int height) {
        this->width = width;
        this->height = height;
        table.setNewSize(width * height);
    }

    bool set(int x, int y, T val) {
        if (x < 0 || x >= width || y < 0 || y >= height) return false;
        table[x * width + y] = val;

        return true;
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

    int getWidth() { return width; }
    int getHeight() { return height; }

private:
    Table<T> table;
    int width;
    int height;
};