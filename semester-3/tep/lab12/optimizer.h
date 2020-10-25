#ifndef OPTIMIZER_H
#define OPTIMIZER_H
#include "problem.h"
#include "diffindividual.h"

class Optimizer
{
public:
    void setProblem(Problem *problem) { this->problem = problem; }
    virtual DiffIndividual getBestFound() const = 0;
    virtual void iterate() = 0;
    virtual ~Optimizer() {}
protected:
    Problem* problem = NULL;
};

#endif // OPTIMIZER_H
