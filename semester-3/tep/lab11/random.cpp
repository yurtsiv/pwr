#include "random.h"

Random::Random()
{
    rng = std::mt19937(dev());
}

Random::Random(int seed)
{
    rng = std::mt19937(dev());
    rng.seed(seed);
}

int Random::next(int a, int b)
{
    return next((unsigned long)a, (unsigned long)b);
}

unsigned long Random::next(unsigned long a, unsigned long b)
{
    std::uniform_int_distribution<std::mt19937::result_type> dist(a,b);
    return dist(rng);
}

double Random::next(double a, double b)
{
    std::uniform_real_distribution<double> dist(a,b);
    return dist(rng);
}
