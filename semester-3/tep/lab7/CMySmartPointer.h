class CRefCounter
{
    public:
        CRefCounter() { i_count; }
        int iAdd() { return(++i_count); }
        int iDec() { return(--i_count); };
    private:
        int i_count;
};

template<typename T>
class CMySmartPointer
{
    public:
        CMySmartPointer(T *pcPointer)
        {
            pc_pointer = pcPointer;
            pc_counter = new CRefCounter();
            pc_counter->iAdd();
        }
        CMySmartPointer(const CMySmartPointer &pcOther)
        {
            pc_pointer = pcOther.pc_pointer;
            pc_counter = pcOther.pc_counter;
            pc_counter->iAdd();
        }
        ~CMySmartPointer()
        {
            if (pc_counter->iDec() == 0)
            {
                std::cout << "Deleting " << pc_pointer << std::endl;
                delete pc_pointer;
                delete pc_counter;
            }
        }
        T& operator*() { return(*pc_pointer); }
        T* operator->() { return(pc_pointer); }
        T& operator=(const T& other) {
            if (other != pc_pointer) {
                if (pc_counter->iDec() == 0) {
                    delete pc_pointer;
                    delete pc_counter;
                }

                pc_counter = new CRefCounter();
                pc_counter->iAdd();
                pc_pointer = other;
            }

            return this;
        }

    private:
        CRefCounter *pc_counter;
        T *pc_pointer;
};