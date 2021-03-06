#ifndef DIFFINDIVIDUAL_H
#define DIFFINDIVIDUAL_H
#include "mscnproblem.h"


class DiffIndividual
{
public:
    DiffIndividual();
    DiffIndividual(double fitness, Table<double> &genotype, bool areConstraintsSatisfied);
    double getFitness() const;
    void setFitness(double value);

    Table<double> getGenotype() const;
    void setGenotype(const Table<double> &value);
    void setGenotypeAt(const double value, const int offset) const;

    bool getAreContraintsSatisfied() const;
    void setAreContraintsSatisfied(bool value);

    friend std::ostream& operator<< (std::ostream &os, const DiffIndividual &ind)
    {
        os << "[ " << ind.genotype << " ]\n" << std::endl;
        return os;
    }

private:
    Table<double> genotype;
    double fitness;
    bool areConstraintsSatisfied;
};

#endif // DIFFINDIVIDUAL_H
