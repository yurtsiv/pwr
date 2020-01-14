#ifndef DIFFEVOL_H
#define DIFFEVOL_H
#include "mscnproblem.h"
#include "randomsearch.h"
#include "diffindividual.h"
#include "diffhelper.h"

class DiffEvol
{
public:
    DiffEvol();
    DiffEvol(MscnProblem *problem);
    void setProblem(MscnProblem *problem);
    DiffIndividual getBestFound() const;
    DiffIndividual getBestFound(const int maxIteration, const int populationNumber) const;
    Table<double> getMutatedGenotype(const Table<double> &base, const Table<double> &addInd0, const Table<double> &addInd1, const Table<Table<double> > &minmax, Random &r) const;
private:
    Table<DiffIndividual> initPopulation(const int populationNumber) const;
    MscnProblem* problem = NULL;
};

#endif // DIFFEVOL_H
