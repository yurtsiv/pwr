#ifndef MATRIX_H
#define MATRIX_H
#include "mysmartpointer.h"
#include "constants.h"
#include "streamhelper.h"
#include <string>
#include <sstream>

template <typename T>
class Matrix
{
public:
    Matrix()
    {
        resize(DEF_MAT_WIDTH, DEF_MAT_HEIGHT);
    }
    Matrix(int width, int height)
    {
        resize(width, height);
    }
    Matrix(const Matrix<T> &other)
    {
        resize(other.width, other.height);
        for(int i = 0; i < height; ++i)
          for(int j = 0; j < width; ++j)
              set(other.get(i, j), i, j);
    }
    Matrix(std::istream &is, int width, int height)
    {
        resize(width, height);
        for(int i = 0; i < height; ++i)
        {
            for(int j = 0; j < width; ++j)
            {
                set(stream_get<T>(is), i, j);
            }
        }
    }

    Matrix<T>& operator=(const Matrix<T> &other)
    {
        resize(other.width, other.height);
        for(int i = 0; i < height; ++i)
          for(int j = 0; j < width; ++j)
              set(other.get(i, j), i, j);
        return *this;
    }
    void resize(int width, int height)
    {
        this->width = width;
        this->height = height;
        matrix = MySmartPointer<T>(new T[width*height](), true);
    }
    void set(T val, int i, int j)
    {
        matrix[i * width + j] = val;
    }
    T get(int i, int j) const
    {
        return matrix[i * width + j];
    }

    int getWidth() { return width; }
    int getHeight() { return height; }
    int size() { return width * height; }

    friend std::ostream& operator<< (std::ostream &os, const Matrix &matrix)
    {
        for(int i = 0; i < matrix.height; ++i)
        {
            if(i != 0) os << '\n';
            for(int j = 0; j < matrix.width; ++j)
            {
                os << matrix.get(i, j) << ' ';
            }
        }
        return os;
    }
private:
    MySmartPointer<T> matrix = NULL;
    int width;
    int height;
};

#endif // MATRIX_H
