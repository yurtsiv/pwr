#ifndef RANDOM_H
#define RANDOM_H
#include <random>

class Random
{
public:
    Random();
    Random(int seed);
    int next(int a, int b); // inclusive
    unsigned long next(unsigned long a, unsigned long b);
    double next(double a, double b);
private:
    std::random_device dev;
    std::mt19937 rng;
};

#endif // RANDOM_H
