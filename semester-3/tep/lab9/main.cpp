#include <iostream>
#include "SmartPointer.h"
#include "MSCNProblem.h"

using namespace std;

int main() {
    MSCNProblem problem;

    problem.setInCd(0, 0, 10);
    problem.setInCf(0, 0, 20);
    problem.setInCm(0, 0, 25);

    problem.setInUd(0, 10);
    problem.setInUf(0, 15);
    problem.setInUm(0, 10);

    problem.setInSd(0, 100);
    problem.setInSf(0, 100);
    problem.setInSm(0, 100);

    problem.setInSs(0, 200);

    problem.setInPs(0, 10);

    cout << problem.constraintsSatisfied(new double[3] { 90, 90, 90 }, 3);
    return 0;
}
