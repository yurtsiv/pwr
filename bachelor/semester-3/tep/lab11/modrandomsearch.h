#ifndef MODRANDOMSEARCH_H
#define MODRANDOMSEARCH_H
#include "mscnproblem.h"
#include "random.h"

class ModRandomSearch
{
public:
    ModRandomSearch();
    ModRandomSearch(MscnProblem *problem);
    void setProblem(MscnProblem *problem);
    Table<double> getNext(Table<double> &bestSolution) const;
    Table<double> getNextValid(Table<double> &bestSolution) const;
    Table<double> getBestFound() const;
    Table<double> getBestFound(int maxIteration) const;
private:
    MscnProblem* problem = NULL;
};

#endif // MODRANDOMSEARCH_H
