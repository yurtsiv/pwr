#include "MSCNProblem.h"


MSCNProblem::MSCNProblem()
{
  D = 1;
  F = 1;
  M = 1;
  S = 1;

  cd = new double*[1];
  cd[0] = new double[1] {1};

  cf = new double*[1];
  cf[0] = new double[1] {1};

  cm = new double*[1];
  cm[0] = new double[1] {1};

  sd = new double[1] {1};
  sf = new double[1] {1};
  sm = new double[1] {1};
  ss = new double[1] {1};
};
