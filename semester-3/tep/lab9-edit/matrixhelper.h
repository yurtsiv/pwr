#ifndef MATRIXHELPER_H
#define MATRIXHELPER_H

#include "matrix.h"
#include "table.h"
#include <iostream>

template <typename T>
bool anyHigherThanZeroInARow(Matrix<T> &mat, int row)
{
    bool found = false;
    int width = mat.getWidth();

    for(int j = 0; j < width && !found; ++j)
    {
        if(mat.get(row, j) > 0) found = true;
    }

    return found;
}

template <typename T>
T sumInARow(Matrix<T> &mat, int row)
{
    T res = 0;
    int width = mat.getWidth();

    for(int j = 0; j < width; ++j)
    {
        res += mat.get(row, j);
    }

    return res;
}

template <typename T>
T sumInAColumn(Matrix<T> &mat, int column)
{
    T res = 0;
    int height = mat.getHeight();

    for(int i = 0; i < height; ++i)
    {
        res += mat.get(i, column);
    }

    return res;
}

template <typename T>
bool setInMatrix(Matrix<T> &mat, T value, int i, int j)
{
    if(value < 0) return false;

    mat.set(value, i, j);
    return true;
}

inline bool setInMatrix(Matrix<Table<double>> &mat, double value, int i, int j, int k)
{
    if(value < 0) return false;

    Table<double> res = mat.get(i, j);
    res[k] = value;
    mat.set(res, i, j);
    return true;
}

#endif // MATRIXHELPER_H
