#include <iostream>

template<class T>
T streamGet(std::istream& is){
    T result;
    is >> result;
    is.ignore(1, ';');
    return result;
}

inline void streamIgnoreChar(std::istream& is, int count){
    char tmp;

    while(count--)
        is >> tmp;

    is.ignore(1, ';');
}
