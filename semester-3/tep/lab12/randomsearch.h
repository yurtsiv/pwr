#ifndef RANDOMSEARCH_H
#define RANDOMSEARCH_H
#include "mscnproblem.h"
#include "diffindividual.h"
#include "random.h"
#include "optimizer.h"

class RandomSearch : Optimizer
{
public:
    RandomSearch() {}
    RandomSearch(Problem *p) { setProblem(p); }
    DiffIndividual getBestFound() const override;
    DiffIndividual getBestFound(const int maxIteration) const;
    void iterate() override {}
    Table<double> getNext() const;
    Table<double> getNextValid() const;
    DiffIndividual getNextInd() const;
};

#endif // RANDOMSEARCH_H
