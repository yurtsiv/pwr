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
        table.set(y * width + x, val);

        return true;
    }

    T get(int x, int y) {
        return table.get(y * width + x);
    }

    void setInternalTable(SmartPointer<Table<T> >& new_table) {
        if (new_table->getLen() != table.getLen()) return;

        for (int i = 0; i < table.getLen(); i++)
            table.set(i, new_table->get(i));
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

    T sumRow(int row) {
        int res = get(0, row);
        for (int i = 1; i < width; i++)
            res += get(i, row);
        return res;
    }

    T sumColumn(int column) {
        int res = get(column, 0);
        for (int i = 1; i < height; i++)
            res += get(column, i);
        return res;
    }

private:
    Table<T> table;
    int width;
    int height;
};