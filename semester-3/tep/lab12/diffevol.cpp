#include "diffevol.h"
Table<double> DiffEvol::getMutatedGenotype(const Table<double> &base, const Table<double> &addInd0, const Table<double> &addInd1)
{
  Table<double> solNew(base);
  Table<Table<double>> minmax = problem->getMinMaxValues();
  int solLen = solNew.size();
  for(int geneOffset = 0; geneOffset < solLen; ++geneOffset)
  {
    if(r.next(0.0, 1.0) < crossProbability)
    {
      solNew[geneOffset] = clamp(solNew[geneOffset] + diffWeight * (addInd0[geneOffset] - addInd1[geneOffset]), minmax[geneOffset][0], minmax[geneOffset][1]);
    }
  }
  return solNew;
}

void DiffEvol::iterate()
{
  int solutionLength = problem->getSolutionLength();
  int baseIndex, addIndex0, addIndex1;
  do {
    baseIndex = r.next(0, populationNumber-1);
    addIndex0 = r.next(0, populationNumber-1);
    addIndex1 = r.next(0, populationNumber-1);
  } while(!areDifferent(currentIndex, baseIndex, addIndex0, addIndex1));

  Table<double> candidateSolution = getMutatedGenotype(pop[baseIndex].getGenotype(), pop[addIndex0].getGenotype(), pop[addIndex1].getGenotype());
  int err;
  double newQuality = problem->getQuality(*candidateSolution, solutionLength, err);
  if(!pop[currentIndex].getAreContraintsSatisfied() || newQuality > pop[currentIndex].getFitness())
  {
    pop[currentIndex] = DiffIndividual(newQuality, candidateSolution, true);

    std::cerr << "Fitness: " << newQuality << '\n';
    if(newQuality > best.getFitness())
    {
      best = pop[currentIndex];
    }
  }
  currentIndex = (currentIndex+1) % populationNumber;
}

void DiffEvol::initPopulation()
{
  pop = Table<DiffIndividual>(populationNumber);
  RandomSearch rs(problem);
  pop[0] = rs.getNextInd();
  best = pop[0];
  for(int i = 1; i < populationNumber; ++i)
  {
    pop[i] = rs.getNextInd();
    if(pop[i].getAreContraintsSatisfied() && pop[i].getFitness() > best.getFitness())
    {
      best = pop[i];
    }
  }
}

int DiffEvol::getIndexFromTournament(int size)
{
  int bestIndex = r.next(0, populationNumber-1);
  for(int i = 0; i < size-1; ++i)
  {
    int rand = r.next(0, populationNumber-1);
    if((pop[rand].getAreContraintsSatisfied() && !pop[bestIndex].getAreContraintsSatisfied()) || pop[rand].getFitness() > pop[bestIndex].getFitness())
    {
      bestIndex = rand;
    }
  }
  return bestIndex;
}
