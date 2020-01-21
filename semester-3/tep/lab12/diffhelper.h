#ifndef DIFFHELPER_H
#define DIFFHELPER_H

template <typename T>
inline bool areDifferent(T i, T j, T k, T l)
{
    return i != j && i != k && i != l &&
            j != k && j != l &&
            k != l;
}

template <typename T>
inline bool areDifferent(T i, T j, T k)
{
    return i != j && i != k && j != k;
}

template <typename T>
inline T clamp(T val, T min, T max)
{
    if(val < min) return min;
    if(val > max) return max;
    return val;
}

#endif // DIFFHELPER_H
