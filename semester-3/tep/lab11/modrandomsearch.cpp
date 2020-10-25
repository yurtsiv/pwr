#include "modrandomsearch.h"

ModRandomSearch::ModRandomSearch()
{
}

ModRandomSearch::ModRandomSearch(MscnProblem *problem)
{
    setProblem(problem);
}

void ModRandomSearch::setProblem(MscnProblem *problem)
{
    this->problem = problem;
}

Table<double> ModRandomSearch::getNext(Table<double> &bestSolution) const
{
    MscnProblem p = *problem;
    const int solutionSize = p.getSolutionLength();
    int toRandomize = solutionSize / 2;
    Table<double> solution(bestSolution);
    Random r;
    Table<Table<double>> minMaxValues = p.getMinMaxValues();
    for(int i = 0; i < solutionSize; ++i)
    {
        if(solutionSize-i == toRandomize || r.next(0, 1) == 1)
        {
          solution[i] = r.next(minMaxValues[i][0], minMaxValues[i][1]);
          toRandomize--;
        }
    }
    return solution;
}

Table<double> ModRandomSearch::getNextValid(Table<double> &bestSolution) const
{
    MscnProblem p = *problem;
    int solutionSize = p.getSolutionLength();
    Table<double> candidate;
    int err;
    bool s;
    do {
      s = p.constraintsSatisfied(*(candidate = getNext(bestSolution)), solutionSize, err);
//      std::cout << "BS " << bestSolution << '\n';
//      std::cout << "CA "<< candidate << '\n';
    } while (!s);
    return candidate;
}

Table<double> ModRandomSearch::getBestFound() const
{
    return getBestFound(DEF_RANDOM_SEARCH_MAX_ITER);
}

Table<double> ModRandomSearch::getBestFound(int maxIteration) const
{
    MscnProblem p = *problem;
    int solutionSize = p.getSolutionLength();
    Table<double> bestSolution(solutionSize);
    double bestQuality = 0;
    int err;

    while(maxIteration--)
    {
        Table<double> candidate = getNextValid(bestSolution);
        double quality = p.getQuality(*candidate, solutionSize, err);
        if(err==E_OK && quality > bestQuality)
        {
            bestQuality = quality;
            bestSolution = candidate;
//            std::cout << "Fitness: " << bestQuality << '\n';
//            std::cout << "Solution: " << bestSolution << '\n';
        }
//            else std::cerr << "Bad fitness: " << quality << '\n';
    }
    return bestSolution;
}
