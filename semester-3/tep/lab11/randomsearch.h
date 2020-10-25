#ifndef RANDOMSEARCH_H
#define RANDOMSEARCH_H
#include "mscnproblem.h"
#include "diffindividual.h"
#include "random.h"

class RandomSearch
{
public:
    RandomSearch();
    RandomSearch(MscnProblem *problem);
    void setProblem(MscnProblem *problem);
    Table<double> getNext() const;
    Table<double> getNextValid() const;
    Table<double> getBestFound() const;
    Table<double> getBestFound(int maxIteration) const;
    DiffIndividual getNextInd() const;
private:
    MscnProblem* problem = NULL;
};

#endif // RANDOMSEARCH_H
