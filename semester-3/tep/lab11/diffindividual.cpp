#include "diffindividual.h"

DiffIndividual::DiffIndividual()
{

}

DiffIndividual::DiffIndividual(double fitness, Table<double> &genotype, bool areConstraintsSatisfied)
{
    this->fitness = fitness;
    this->genotype = genotype;
    this->areConstraintsSatisfied = areConstraintsSatisfied;
}

double DiffIndividual::getFitness() const { return fitness; }
void DiffIndividual::setFitness(double value) { fitness = value; }
Table<double> DiffIndividual::getGenotype() const { return genotype; }
void DiffIndividual::setGenotype(const Table<double> &value) { genotype = value; }
void DiffIndividual::setGenotypeAt(const double value, const int offset) const
{
    this->genotype[offset] = value;
}

bool DiffIndividual::getAreContraintsSatisfied() const { return areConstraintsSatisfied; }
void DiffIndividual::setAreContraintsSatisfied(bool value) { areConstraintsSatisfied = value; }
