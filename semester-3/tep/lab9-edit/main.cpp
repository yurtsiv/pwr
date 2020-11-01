#include <iostream>
#include "mscnproblem.h"

using namespace std;

void test1() {
    std::ifstream file("../problem_files/problem1.txt");
    MscnProblem problem(file);
    file.close();

    double* solution = new double[3] {1, 1, 1};

    cout << "\n--- Test 1 ---" << endl;

    cout << "Min max: ";
    Table<Table<double>> minMax = problem.getMinMaxValues();
    for (int i = 0; i < minMax.size(); i++) {
        for (int j = 0; j < minMax[i].size(); j+=2) {
            cout << "(" << minMax[i][j] << ", " << minMax[i][j+1] << ") | ";
        }
    }

    int error;
    cout << "\nConstraints satisfied: " << problem.constraintsSatisfied(solution, 3, error) << endl;
    cout << "Quality: " << problem.getQuality(solution, 3, error) << endl;
}

void test2() {
    std::ifstream file("../problem_files/problem1.txt");
    MscnProblem problem(file);
    file.close();

    double* solution = new double[2] {1, 1};

    cout << "\n--- Test 2 ---" << endl;

    int error;
    cout << "Constraints satisfied: " << problem.constraintsSatisfied(solution, 2, error) << endl;
    cout << "Error code: " << error << endl;
}

void test3() {
    std::ifstream file("../problem_files/problem2.txt");
    MscnProblem problem(file);
    file.close();

    double* solution = new double[8] { 36, 82, 32, 71, 4.2, 54.7, 8.0,  15.5 };

    cout << "\n--- Test 3 ---" << endl;

    cout << "Min max: ";
    Table<Table<double>> minMax = problem.getMinMaxValues();
    for (int i = 0; i < minMax.size(); i++) {
        for (int j = 0; j < minMax[i].size(); j+=2) {
            cout << "(" << minMax[i][j] << ", " << minMax[i][j+1] << ") | ";
        }
    }

    int error;
    cout << "\nConstraints satisfied: " << problem.constraintsSatisfied(solution, 8, error) << endl;
    cout << "Quality: " << problem.getQuality(solution, 8, error) << endl;
}

int main()
{
    test1();
    test2();
    test3();
}
