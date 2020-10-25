#include "diffevol.h"

DiffEvol::DiffEvol()
{

}

DiffEvol::DiffEvol(MscnProblem *problem)
{
    this->problem = problem;
}

void DiffEvol::setProblem(MscnProblem *problem)
{
  this->problem = problem;
}

DiffIndividual DiffEvol::getBestFound() const
{
  return getBestFound(DEF_DIFF_EVOL_MAX_ITER, DEF_DIFF_EVOL_POP_NUMBER);
}

Table<double> DiffEvol::getMutatedGenotype(const Table<double> &base, const Table<double> &addInd0, const Table<double> &addInd1, const Table<Table<double>> &minmax, Random &r) const
{
  Table<double> solNew(base);
  int solLen = solNew.size();
  for(int geneOffset = 0; geneOffset < solLen; ++geneOffset)
  {
    if(r.next(0.0, 1.0) < DEF_DIFF_EVOL_CROSS_PROB)
    {
      solNew[geneOffset] = clamp(solNew[geneOffset] + DEF_DIFF_EVOL_DIFF_WEIGHT * (addInd0[geneOffset] - addInd1[geneOffset]), minmax[geneOffset][0], minmax[geneOffset][1]);
    }
  }
  return solNew;
}

DiffIndividual DiffEvol::getBestFound(const int maxIteration, const int populationNumber) const
{
  Table<DiffIndividual> pop = initPopulation(populationNumber);
  std::cout << "Init population: \n" << pop;
  Random r;
  int solLen = problem->getSolutionLength();
  Table<Table<double>> minmax = problem->getMinMaxValues();
  int baseIndex, addIndex0, addIndex1;
  int iterations = 0;
  while(iterations <= maxIteration)
  {
    for(int i = 0; i < populationNumber && iterations <= maxIteration; ++i)
    {
      do {
        baseIndex = r.next(0, populationNumber-1);
        addIndex0 = r.next(0, populationNumber-1);
        addIndex1 = r.next(0, populationNumber-1);
      } while(!areDifferent(baseIndex, addIndex0, addIndex1));

      Table<double> solNew = getMutatedGenotype(pop[baseIndex].getGenotype(),
                                                pop[addIndex0].getGenotype(),
                                                pop[addIndex1].getGenotype(),
                                                minmax,
                                                r);
      int err;
      bool cs = problem->constraintsSatisfied(*solNew, solLen, err);
      if(err==E_OK && cs)
      {
        double newQuality = problem->getQuality(*solNew, solLen, err);
        if(err==E_OK)
        {
          if(!pop[i].getAreContraintsSatisfied() || newQuality > pop[i].getFitness())
          {
            pop[i] = DiffIndividual(newQuality, solNew, true);
            std::cout << "Fitness: " << newQuality << '\n';
          }
        }
      }
      iterations++;
    }
  }
  Table<double> zero(solLen);
  DiffIndividual bestInd = DiffIndividual(0, zero, true);
  for(int i = 0; i < populationNumber; ++i)
  {
    if(pop[i].getAreContraintsSatisfied() && pop[i].getFitness() > bestInd.getFitness())
      bestInd = pop[i];
  }
  return bestInd;
}

Table<DiffIndividual> DiffEvol::initPopulation(const int populationNumber) const
{
  RandomSearch rs(problem);
  Table<DiffIndividual> res(populationNumber);
  for(int i = 0; i < populationNumber; ++i)
  {
    res[i] = rs.getNextInd();
  }
  return res;
}
