#ifndef STREAMHELPER_H
#define STREAMHELPER_H

#include <istream>
#include <array>

template<class T>
T stream_get(std::istream& is){
    T result;
    is >> result;
    is.ignore(1, ';');
    return result;
}

inline void stream_ignore_char(std::istream& is, int count){
    char tmp;
    while(count--)
    {
        is >> tmp;
    }
    is.ignore(1, ';');
}

#endif // STREAMHELPER_H
