#include <iostream>
#include "Table.h"

using namespace std;

template <typename T>
class Matrix {
public:
    Matrix(int width, int height) {
        this->width = width;
        this->height = height;
        table = new Table<T>(width * height);
    }

    Matrix(std::istream& is, int width, int height) {
        table = new Table<T>(width * height);
        this->width = width;
        this->height = height;

        for(int i = 0; i < height; i++) {
            for(int j = 0; j < width; j++) {
                T val = streamGet<T>(is);
                set(j, i, val);
            }
        }
    }

    ~Matrix() {
        delete table;
    }

    void resize(int width, int height) {
        this->width = width;
        this->height = height;
        table->setNewSize(width * height);
    }

    bool set(int x, int y, T val) {
        if (x < 0 || x >= width || y < 0 || y >= height) return false;
        table->set(y * width + x, val);

        return true;
    }

    T get(int x, int y) const {
        return table->get(y * width + x);
    }

    void setInternalTable(Table<T>* new_table) {
        if (new_table->getLen() != table->getLen()) return;

        for (int i = 0; i < table->getLen(); i++)
            table->set(i, new_table->get(i));
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

    bool rowContainsPositiveNum(int row) {
        for (int i = 0; i < width; i++) {
            if (get(i, row) > 0) {
                return true;
            }
        }

        return false;
    }

    friend std::ostream& operator<< (std::ostream& os, const Matrix& m) {
        for (int i = 0; i < m.height; i++) {
            if (i != 0) os << '\n';

            for (int j = 0; j < m.width; j++)
                os << m.get(i, j) << ' ';
        }

        return os;
    }

private:
    Table<T>* table;
    int width;
    int height;
};