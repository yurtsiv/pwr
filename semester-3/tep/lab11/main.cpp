#include <iostream>
#include <sstream>
#include "constants.h"
#include "mscnproblem.h"
#include "mysmartpointer.h"
#include "random.h"
#include "randomsearch.h"
#include "modrandomsearch.h"
#include "diffevol.h"

void diffEvolTest()
{
    MscnProblem p;
    p.setDCount(2);
    p.setFCount(2);
    p.setMCount(2);
    p.setSCount(3);
    p.generateInstance(0);
    p.setDefaultMinMaxValues();
    std::cout << p << '\n';
    DiffEvol de(&p);
    DiffIndividual di = de.getBestFound();
    std::cerr << "Final fitness: " << di.getFitness() << '\n';
    std::cerr << "Final solution: " << di.getGenotype() << '\n';
}
int main()
{
    std::cout.precision(12);
    std::cerr.precision(12);
    diffEvolTest();

    return 0;
}
