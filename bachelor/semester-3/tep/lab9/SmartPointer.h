#include <iostream>

using namespace std;

class RefCounter
{
public:
    RefCounter() { count = 0; }
    int add() { return(++count); }
    int dec() { return(--count); };
    int get()  { return count; }
private:
    int count;
};

template<typename T>
class SmartPointer
{
public:
    SmartPointer(T *p, bool isArray = false)
    {
        pointer = p;
        is_array = isArray;
        counter = new RefCounter();
        counter->add();
    }

    SmartPointer(const SmartPointer &pcOther)
    {
        pointer = pcOther.pointer;
        counter = pcOther.counter;
        counter->add();
    }

    ~SmartPointer()
    {
        onDeconstruct();
    }

    T& operator*() { return(*pointer); }
    T* operator->() { return(pointer); }
    T&operator [](int i) {
        if (!is_array) throw;
        return pointer[i];
    }
    SmartPointer<T>& operator=(const SmartPointer<T> &other) {
        if (other.pointer != pointer) {
            if (counter->dec() == 0) {
                delete pointer;
                delete counter;
            }

            counter = other.counter;
            pointer = other.pointer;
        } else {
            delete counter;
            counter = other.counter;
            counter->add();
        }

        return *this;
    }

private:
    T *pointer;
    bool is_array;
    RefCounter *counter;

    void onDeconstruct() {
        if (is_array) {
            delete[] pointer;
        } else {
            delete pointer;
        };

        delete counter;
    }
};
