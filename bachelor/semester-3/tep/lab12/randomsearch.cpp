#include "randomsearch.h"

Table<double> RandomSearch::getNext() const
{
    int solutionSize = problem->getSolutionLength();
    Table<double> solution(solutionSize);
    Random r;
    Table<Table<double>> minMaxValues = problem->getMinMaxValues();
    for(int i = 0; i < solutionSize; ++i)
        solution[i] = r.next(minMaxValues[i][0], minMaxValues[i][1]);
    return solution;
}

Table<double> RandomSearch::getNextValid() const
{
    int solutionSize = problem->getSolutionLength();
    Table<double> candidate;
    int err;
    bool s;
    do {
      s = ((MscnProblem*)problem)->constraintsSatisfied(*(candidate = getNext()), solutionSize, err);
    } while (!s);
    return candidate;
}

DiffIndividual RandomSearch::getBestFound() const
{
    return getBestFound(DEF_RANDOM_SEARCH_MAX_ITER);
}

DiffIndividual RandomSearch::getBestFound(int maxIteration) const
{
    int solutionSize = problem->getSolutionLength();
    Table<double> zero(solutionSize);
    DiffIndividual best(0, zero, true);
    int err;

    while(maxIteration--)
    {
        Table<double> candidate = getNextValid();
        double quality = problem->getQuality(*candidate, solutionSize, err);
        if(err==E_OK && quality > best.getFitness())
        {
            best = DiffIndividual(quality, candidate, true);
        }
    }
    return best;
}

DiffIndividual RandomSearch::getNextInd() const
{
    int err;
    Table<double> sol;
    do {
      sol = getNext();
      err = ((MscnProblem*)problem)->technicalCheck(*sol, sol.size());
    } while(err != E_OK);
    double val = problem->getQuality(*sol, sol.size(), err);
    bool cs = ((MscnProblem*)problem)->constraintsSatisfied(*sol, sol.size(), err);
    return DiffIndividual(val, sol, cs);
}
