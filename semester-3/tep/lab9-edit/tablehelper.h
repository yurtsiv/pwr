#ifndef TABLEHELPER_H
#define TABLEHELPER_H

#include "table.h"

template <typename T>
bool setInTable(Table<T> &tab, T value, int i)
{
    if(value < 0) return false;

    tab[i] = value;
    return true;
}

#endif // TABLEHELPER_H
