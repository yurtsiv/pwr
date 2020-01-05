#include <iostream>
#include "SmartPointer.h"
#include "MSCNProblem.h"

using namespace std;

int main() {
    MSCNProblem problem;

    problem.setInCd(0, 0, 3);
    problem.setInCf(0, 0, 4);
    problem.setInCm(0, 0, 1);

    problem.setInUd(0, 10);
    problem.setInUf(0, 10);
    problem.setInUm(0, 10);

    problem.setInSd(0, 100);
    problem.setInSf(0, 50);
    problem.setInSm(0, 10.5);

    problem.setInSs(0, 100);

    problem.setInPs(0, 100);

    cout << problem.getQuality(new double[3] { 1, 1, 1 }, 3);
    return 0;
}
