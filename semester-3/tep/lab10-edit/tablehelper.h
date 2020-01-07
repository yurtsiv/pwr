#ifndef TABLEHELPER_H
#define TABLEHELPER_H

#include "random.h"
#include "table.h"

template <typename T>
bool setInTable(Table<T> &tab, T value, int i)
{
    if(value < 0) return false;

    tab[i] = value;
    return true;
}

inline void randomize(Table<double> &tab, Random &r, double min, double max)
{
    for(int i = 0; i < tab.size(); ++i)
      tab.set(r.next(min, max), i);
}

#endif // TABLEHELPER_H
