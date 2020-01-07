#include <iostream>
#include "SmartPointer.h"
#include "MSCNProblem.h"

using namespace std;

void test1() {
    std::ifstream file("problem1.txt");
    MSCNProblem problem(file);
    file.close();

    double* solution = new double[3] { 1, 1, 1 };

    cout << "--- Test 1 ---" << endl;
    cout << "Constraints satisfied: " << problem.constraintsSatisfied(solution, 3) << endl;
    cout << "Quality: " << problem.getQuality(solution, 3) << endl;

    delete[] solution;
}

void test2() {
    std::ifstream file("problem2.txt");
    MSCNProblem problem(file);
    file.close();

    double* solution = new double[8] { 36, 82, 32, 71, 4.2, 8.0, 54.7,  15.5 };

    cout << "--- Test 2 ---" << endl;
    cout << "Constraints satisfied: " << problem.constraintsSatisfied(solution, 3) << endl;

    cout << "Quality: " << problem.getQuality(solution, 3) << endl;

    delete[] solution;
}

int main() {
    test1();
    test2();

    return 0;
}
