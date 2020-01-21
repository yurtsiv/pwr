#include <iostream>
#include <sstream>
#include "constants.h"
#include "mscnproblem.h"
#include "mysmartpointer.h"
#include "random.h"
#include "randomsearch.h"
#include "diffevol.h"
#include "timer.h"

void diffEvolTest()
{
    MscnProblem p;
    p.setDCount(2);
    p.setFCount(2);
    p.setMCount(2);
    p.setSCount(3);
    p.generateInstance(0);
    p.setDefaultMinMaxValues();
    DiffEvol de(&p);
    Timer t;
    t.start();

    while(t.getSecondsElapsed() < DEF_DIFF_EVOL_ITER_TIME)
    {
      t.stop();
      de.iterate();
    }

    std::cerr << "Elapsed time: " << t.getSecondsElapsed() << " seconds.\n";
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
