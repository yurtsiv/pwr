#include "randomsearch.h"

RandomSearch::RandomSearch()
{
}

RandomSearch::RandomSearch(MscnProblem *problem)
{
    setProblem(problem);
}

void RandomSearch::setProblem(MscnProblem *problem)
{
    this->problem = problem;
}

Table<double> RandomSearch::getNext() const
{
    MscnProblem p = *problem;
    int solutionSize = p.getSolutionLength();
    Table<double> solution(solutionSize);
    Random r;
    Table<Table<double>> minMaxValues = p.getMinMaxValues();
    for(int i = 0; i < solutionSize; ++i)
        solution[i] = r.next(minMaxValues[i][0], minMaxValues[i][1]);
    return solution;
}

Table<double> RandomSearch::getNextValid() const
{
    MscnProblem p = *problem;
    int solutionSize = p.getSolutionLength();
    Table<double> candidate;
    int err;
    bool s;
    do {
      s = p.constraintsSatisfied(*(candidate = getNext()), solutionSize, err);
    } while (!s);
    return candidate;
}

Table<double> RandomSearch::getBestFound() const
{
    return getBestFound(DEF_RANDOM_SEARCH_MAX_ITER);
}

Table<double> RandomSearch::getBestFound(int maxIteration) const
{
    MscnProblem p = *problem;
    int solutionSize = p.getSolutionLength();
    Table<double> bestSolution(solutionSize);
    double bestQuality = 0;
    int err;

    while(maxIteration--)
    {
        Table<double> candidate = getNextValid();
        double quality = p.getQuality(*candidate, solutionSize, err);
        if(err==E_OK && quality > bestQuality)
        {
            bestQuality = quality;
            bestSolution = candidate;
        }
    }
    return bestSolution;
}
