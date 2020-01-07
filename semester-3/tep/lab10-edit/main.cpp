#include <iostream>
#include "mscnproblem.h"
#include "random.h"
#include "randomsearch.h"

using namespace std;

void testSolution(Table<double>& solution_t, MscnProblem* problem) {
    cout << "Solution: ";
    int size = solution_t.size();
    for (int i = 0; i < size; i++)
        cout << solution_t[i] << " | ";

    cout << endl;

    double* solution = new double_t[size];
    for (int i = 0; i < size; i++)
        solution[i] = solution_t[i];

    int error;
    cout << "Constraints satisfied: " << problem->constraintsSatisfied(solution, size, error) << endl;
    cout << "Quality: " << problem->getQuality(solution, size, error) << endl;
}


void test1(RandomSearch* search, MscnProblem* problem) {
    cout << "--- Test 1 (random) ---" << endl;

    Table<double> solution = search->getNext();
    testSolution(solution, problem);
}

void test2(RandomSearch* search, MscnProblem* problem) {
    cout << "--- Test 2 (valid) ---" << endl;

    Table<double> solution = search->getNextValid();
    testSolution(solution, problem);
}

void test3(RandomSearch* search, MscnProblem* problem) {
    cout << "--- Test 3 (best valid) ---" << endl;

    Table<double> solution = search->getBestFound();
    testSolution(solution, problem);
}

int main()
{
    ifstream file("../problem_files/problem1.txt");
    MscnProblem* problem = new MscnProblem(file);
    RandomSearch* search = new RandomSearch(problem);

    test1(search, problem);
    test2(search, problem);
    test3(search, problem);

    return 0;
}
