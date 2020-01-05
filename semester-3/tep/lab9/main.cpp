#include <iostream>
#include "SmartPointer.h"
#include "MSCNProblem.h"

using namespace std;

int main() {
    SmartPointer<Matrix<int> > m(new Matrix<int>(2, 3));

    m->set(0, 0, 1);
    m->set(1, 0, 2);
    m->set(0, 1, 3);
    m->set(1, 1, 4);

    m->print();

    return 0;
}
