#include <iostream>

using namespace std;

class CRefCounter
{
    public:
        CRefCounter() { i_count = 0; }
        int iAdd() { return(++i_count); }
        int iDec() { return(--i_count); };
        int get()  { return i_count; }
    private:
        int i_count;
};

template<typename T>
class CMySmartPointer
{
    public:
        CMySmartPointer(T *pcPointer)
        {
            cout << "Initailized smart pointer: " << pcPointer << endl;
            pc_pointer = pcPointer;
            pc_counter = new CRefCounter();
            pc_counter->iAdd();
        }

        CMySmartPointer(const CMySmartPointer &pcOther)
        {
            pc_pointer = pcOther.pc_pointer;
            pc_counter = pcOther.pc_counter;
            pc_counter->iAdd();
        
            cout << "Copied smart pointer: " << pc_pointer << ". Number of copies: " << pc_counter->get() << endl;
        }

        ~CMySmartPointer()
        {
            if (pc_counter->iDec() == 0)
            {
                delete pc_pointer;
                delete pc_counter;
                cout << "Deleted " << pc_pointer << endl;
            }
        }

        T& operator*() { return(*pc_pointer); }
        T* operator->() { return(pc_pointer); }
        CMySmartPointer<T>& operator=(const CMySmartPointer<T> &other) {
            if (other.pc_pointer != pc_pointer) {
                if (pc_counter->iDec() == 0) {
                    delete pc_pointer;
                    delete pc_counter;
                    cout << "Deleted " << pc_pointer << endl;
                }

                pc_counter = other.pc_counter;
                pc_pointer = other.pc_pointer;
                cout << "New pointer assigned: " << pc_pointer << ". Number of copies: " << pc_counter->get() << endl;
            } else {
                delete pc_counter;
                pc_counter = other.pc_counter;
                pc_counter->iAdd();
            }

            return *this;
        }

    private:
        CRefCounter *pc_counter;
        T *pc_pointer;
};