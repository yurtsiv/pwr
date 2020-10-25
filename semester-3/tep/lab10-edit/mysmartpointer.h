#ifndef MYSMARTPOINTER_H
#define MYSMARTPOINTER_H
#include "refcounter.h"
#include <iostream>

template<typename T>
class MySmartPointer
{
public:
    MySmartPointer(T *pointer, bool is_array = false)
    {
        this->is_array = is_array;
        this->pointer = pointer;
        counter = new RefCounter();
        counter->add();
    }
    MySmartPointer(const MySmartPointer<T> &other)
    {
        is_array = other.is_array;
        pointer = other.pointer;
        counter = other.counter;
        counter->add();
    }
    ~MySmartPointer()
    {
        if(counter->dec() == 0) destroy();
    }

    T& operator*() { return(*pointer); }
    T* operator->() { return(pointer); }
    T& operator[](int i) const
    {
        if (!is_array) throw;
        return pointer[i];
    }
    T* get() const { return pointer; }
    T at(int offset)
    {
        if (!is_array) throw;
        return *(pointer+offset);
    }
    MySmartPointer<T>& operator=(const MySmartPointer<T> &other)
    {
        if(counter->dec() == 0) destroy();
        is_array = other.is_array;
        pointer = other.pointer;
        counter = other.counter;
        counter->add();

        return *this;
    }
private:
    T *pointer;
    RefCounter* counter;
    bool is_array;
    void destroy()
    {
        delete counter;
        if(is_array)
            delete[] pointer;
        else
            delete pointer;
    }
};

#endif // MYSMARTPOINTER_H
