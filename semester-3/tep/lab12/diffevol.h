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
        init(NULL, DEF_DIFF_EVOL_POP_NUMBER, DEF_DIFF_EVOL_CROSS_PROB, DEF_DIFF_EVOL_DIFF_WEIGHT, DEF_DIFF_TOURNAMENT_SIZE);
    }
    DiffEvol(Problem *p)
    {
        init(p, DEF_DIFF_EVOL_POP_NUMBER, DEF_DIFF_EVOL_CROSS_PROB, DEF_DIFF_EVOL_DIFF_WEIGHT, DEF_DIFF_TOURNAMENT_SIZE);
        initPopulation();
    }
    DiffEvol(Problem *p, int populationNumber, double crossProbability, double diffWeight, int tournamentSize)
    {
        init(p, populationNumber, crossProbability, diffWeight, tournamentSize);
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
    int tournamentSize;
    int currentIndex;

    void init(Problem *p, int populationNumber, double crossProbability, double diffWeight, int tournamentSize)
    {
      this->problem = p;
      this->populationNumber = populationNumber;
      this->crossProbability = crossProbability;
      this->diffWeight = diffWeight;
      this->tournamentSize = tournamentSize;
      this->currentIndex = 0;
    }
    Table<double> getMutatedGenotype(const Table<double> &base, const Table<double> &addInd0, const Table<double> &addInd1);
    int getIndexFromTournament(int size);
};

#endif // DIFFEVOL_H
