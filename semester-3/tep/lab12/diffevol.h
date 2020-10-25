#ifndef DIFFEVOL_H
#define DIFFEVOL_H
#include "mscnproblem.h"
#include "randomsearch.h"
#include "diffindividual.h"
#include "diffhelper.h"
#include "optimizer.h"

class DiffEvol : public Optimizer
{
public:
    DiffEvol()
    {
        init(NULL, DEF_DIFF_EVOL_POP_NUMBER, DEF_DIFF_EVOL_CROSS_PROB, DEF_DIFF_EVOL_DIFF_WEIGHT);
    }
    DiffEvol(Problem *p)
    {
        init(p, DEF_DIFF_EVOL_POP_NUMBER, DEF_DIFF_EVOL_CROSS_PROB, DEF_DIFF_EVOL_DIFF_WEIGHT);
        initPopulation();
    }
    DiffEvol(Problem *p, int populationNumber, double crossProbability, double diffWeight)
    {
        init(p, populationNumber, crossProbability, diffWeight);
        initPopulation();
    }
    void iterate();

    DiffIndividual getBestFound() const override { return best; }

    void initPopulation();
private:
    Random r;
    Table<DiffIndividual> pop;
    DiffIndividual best;
    int populationNumber;
    double crossProbability;
    double diffWeight;
    int currentIndex;

    void init(Problem *p, int populationNumber, double crossProbability, double diffWeight)
    {
      this->problem = p;
      this->populationNumber = populationNumber;
      this->crossProbability = crossProbability;
      this->diffWeight = diffWeight;
      this->currentIndex = 0;
    }
    Table<double> getMutatedGenotype(const Table<double> &base, const Table<double> &addInd0, const Table<double> &addInd1);
};

#endif // DIFFEVOL_H
