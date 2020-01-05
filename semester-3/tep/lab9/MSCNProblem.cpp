#include "SmartPointer.h"
#include "MSCNProblem.h"

MSCNProblem::MSCNProblem() :
    cd(1, 1),
    cf(1, 1),
    cm(1, 1),
    ud(1),
    uf(1),
    um(1),
    sd(1),
    sf(1),
    sm(1),
    ss(1),
    ps(1),
    xdMinMax(1, 1),
    xfMinMax(1, 1),
    xmMinMax(1, 1)
{
    setD(1);
    setF(1);
    setM(1);
    setS(1);
}

bool MSCNProblem::constraintsSatisfied(double* solution, int len) {
    if (!isSolutionCorrect(solution, len)) return false;

    Solution parsed_solution = parseSolution(solution, len);

    for (int i = 0; i < D; i++) {
        if (parsed_solution.xd->sumRow(i) > sd.get(i)) return false;
    }

    for (int i = 0; i < F; i++) {
        if (parsed_solution.xf->sumRow(i) > sf.get(i)) return false;
    }

    for (int i = 0; i < M; i++) {
        if (parsed_solution.xm->sumRow(i) > sm.get(i)) return false;
    }

    for (int i = 0; i < S; i++) {
        if (parsed_solution.xm->sumColumn(i) > ss.get(i)) return false;
    }

    for (int i = 0; i < F; i++) {
        if (parsed_solution.xd->sumColumn(i) < parsed_solution.xf->sumRow(i)) return false;
    }

    for (int i = 0; i < M; i++) {
        if (parsed_solution.xf->sumColumn(i) < parsed_solution.xm->sumRow(i)) return false;
    }

    return true;
}

bool MSCNProblem::setD(int d) {
    if (d < 0) return false;

    D = d;

    cd.resize(F, D);
    sd.setNewSize(D);
    ud.setNewSize(D);
    xdMinMax.resize(F, D);

    return true;
}

bool MSCNProblem::setF(int f) {
    if (f < 0) return false;

    F = f;

    cd.resize(F, D);
    cf.resize(M, F);

    sf.setNewSize(F);
    uf.setNewSize(F);

    xdMinMax.resize(F, D);
    xfMinMax.resize(M, F);

    return true;
}

bool MSCNProblem::setM(int m) {
    if (m < 0) return false;

    M = m;

    cf.resize(M, F);
    cm.resize(S, M);

    sm.setNewSize(M);
    um.setNewSize(M);

    xfMinMax.resize(M, F);
    xmMinMax.resize(S, M);

    return true;
}

bool MSCNProblem::setS(int s) {
    if (s < 0) return false;

    S = s;

    cm.resize(S, M);

    ss.setNewSize(S);
    ps.setNewSize(S);

    xmMinMax.resize(S, M);

    return true;
}

bool MSCNProblem::setInCd(int x, int y, double val) {
    return setInCostsMatrix(cd, x, y, val);
}

bool MSCNProblem::setInCf(int x, int y, double val) {
    return setInCostsMatrix(cf, x, y, val);
}

bool MSCNProblem::setInCm(int x, int y, double val) {
    return setInCostsMatrix(cm, x, y, val);
}

bool MSCNProblem::setInUd(int i, double val) {
    return setInTable(ud, i, val);
}

bool MSCNProblem::setInUf(int i, double val) {
    return setInTable(uf, i, val);
}

bool MSCNProblem::setInUm(int i, double val) {
    return setInTable(um, i, val);
}

bool MSCNProblem::setInSd(int i, double val) {
    return setInTable(sd, i, val);
}

bool MSCNProblem::setInSf(int i, double val) {
    return setInTable(sf, i, val);
}

bool MSCNProblem::setInSm(int i, double val) {
    return setInTable(sm, i, val);
}

bool MSCNProblem::setInSs(int i, double val) {
    return setInTable(ss, i, val);
}

bool MSCNProblem::setInPs(int i, double val) {
    return setInTable(ps, i, val);
}

bool MSCNProblem::setInXdMinMax(int x, int y, Bounds bounds) {
    return setInMinMaxMatrix(xdMinMax, x, y, bounds);
}

bool MSCNProblem::setInXfMinMax(int x, int y, Bounds bounds) {
    return setInMinMaxMatrix(xfMinMax, x, y, bounds);
}

bool MSCNProblem::setInXmMinMax(int x, int y, Bounds bounds) {
    return setInMinMaxMatrix(xmMinMax, x, y, bounds);
}

bool MSCNProblem::setInCostsMatrix(Matrix<double>& m, int x, int y, double val) {
    if (val < 0) return false;

    return m.set(x, y, val);
}

bool MSCNProblem::setInTable(Table<double>& t, int i, double val) {
    if (val < 0 || i < 0 || i >= t.getLen()) return false;

    t.set(i, val);

    return true;
}

bool MSCNProblem::setInMinMaxMatrix(Matrix<Bounds>& m, int x, int y, Bounds bounds) {
    if (bounds.min < 0 || bounds.max < 0 || bounds.max < bounds.min) return false;

    return m.set(x, y, bounds);
}

bool MSCNProblem::isSolutionCorrect(double *solution, int len) {
    if (solution == NULL) return false;

    if (len != getRequiredSolutionLen()) return false;

    for (int i = 0; i < len; i++) {
        if (solution[i] < 0) return false;
    }

    return true;
}

Solution MSCNProblem::parseSolution(double* solution, int len) {
    Table<double> solution_table;
    solution_table.setArray(solution, len);

    Matrix<double>* xd = new Matrix<double>(F, D);
    Matrix<double>* xf = new Matrix<double>(M, F);
    Matrix<double>* xm = new Matrix<double>(S, M);

    SmartPointer<Table<double> > xdTable(solution_table.slice(0, F*D));
    int xfOffset = xdTable->getLen();
    SmartPointer<Table<double> > xfTable(solution_table.slice(xfOffset, xfOffset + F * M));
    int xmOffset = xfOffset + xfTable->getLen();
    SmartPointer<Table<double> > xmTable(solution_table.slice(xmOffset, xmOffset + M * S) );


    xd->setInternalTable(xdTable);
    xf->setInternalTable(xfTable);
    xm->setInternalTable(xmTable);

    return {xd, xf, xm};
}

int MSCNProblem::getRequiredSolutionLen() {
    return D * F + F * M + M * S;
}

