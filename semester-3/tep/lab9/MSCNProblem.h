#include "Matrix.h"
#include "Table.h"

struct Bounds {
    double min;
    double max;
};

class MSCNProblem {
public:
    bool setD(int d) { D = d; }
    bool setF(int f) { F = f; }
    bool setM(int m) { M = m; }
    bool setS(int s) { S = s; }

    bool setInCd(int x, int y, double val);
    bool setInCf(int x, int y, double val);
    bool setInCm(int x, int y, double val);

    bool setInUd(int i, double val);
    bool setInUf(int i, double val);
    bool setInUm(int i, double val);

    bool setInSd(int i, double val);
    bool setInSf(int i, double val);
    bool setInSm(int i, double val);
    bool setInSs(int i, double val);

    bool setInPs(int i, double val);

    bool setInXdMinMax(int x, int y, Bounds bounds);
    bool setInXfMinMax(int x, int y, Bounds bounds);
    bool setInXmMinMax(int x, int y, Bounds bounds);

private:
    // Count
    int D, F, M, S;

    // Production/transport costs
    Matrix<double> cd;
    Matrix<double> cf;
    Matrix<double> cm;

    // Costs of single operation
    Table<double> ud;
    Table<double> uf;
    Table<double> um;

    // Production powers
    Table<double> sd;
    Table<double> sf;
    Table<double> sm;
    Table<double> ss;

    // Income from markets
    Table<double> ps;

    Matrix<Bounds> xdMinMax;
    Matrix<Bounds> xfMinMax;
    Matrix<Bounds> xmMinmax;
};
