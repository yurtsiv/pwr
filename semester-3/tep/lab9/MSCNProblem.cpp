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
    xmMinMax(1, 1),
    D(1),
    F(1),
    M(1),
    S(1) {}

MSCNProblem::MSCNProblem(std::istream &is) {
    streamIgnoreChar(is, 1);
    D = streamGet<int>(is);
    streamIgnoreChar(is, 1);
    F = streamGet<int>(is);
    streamIgnoreChar(is, 1);
    M = streamGet<int>(is);
    streamIgnoreChar(is, 1);
    S = streamGet<int>(is);

    streamIgnoreChar(is, 2);
    sd = Table<double>(is, D);
    streamIgnoreChar(is, 2);
    sf = Table<double>(is, F);
    streamIgnoreChar(is, 2);
    sm = Table<double>(is, M);
    streamIgnoreChar(is, 2);
    ss = Table<double>(is, S);

    streamIgnoreChar(is, 2);
    cd = Matrix<double>(is, F, D);
    streamIgnoreChar(is, 2);
    cf = Matrix<double>(is, M, F);
    streamIgnoreChar(is, 2);
    cm = Matrix<double>(is, S, M);

    streamIgnoreChar(is, 2);
    ud = Table<double>(is, D);
    streamIgnoreChar(is, 2);
    uf = Table<double>(is, F);
    streamIgnoreChar(is, 2);
    um = Table<double>(is, M);
    streamIgnoreChar(is, 1);
    ps = Table<double>(is, S);

//    streamIgnoreChar(is, 8);
//    specialRead(xdMinMax, is, fCount, dCount);
//    streamIgnoreChar(is, 8);
//    specialRead(xfMinMax, is, mCount, fCount);
//    streamIgnoreChar(is, 8);
//    specialRead(xmMinMax, is, sCount, mCount);
}


double MSCNProblem::getQuality(double *solution, int len) {
    if (!isSolutionCorrect(solution, len)) return 0;

    Solution s = parseSolution(solution, len);

    return calcIncome(s.xm) - calcTransportCost(s.xd, s.xf, s.xm) - calcServiceUsageCost(s.xd, s.xf, s.xm);
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

Table<Bounds>* MSCNProblem::getSolutionBounds() {
    Table<Bounds>* res = new Table<Bounds>(getRequiredSolutionLen());

    int res_index = 0;

    for (int y = 0; y < xdMinMax.getHeight(); y++) {
        for (int x = 0; x < xdMinMax.getWidth(); x++) {
            res->set(res_index, xdMinMax.get(x, y));
            res_index++;
        }
    }

    for (int y = 0; y < xfMinMax.getHeight(); y++) {
        for (int x = 0; x < xfMinMax.getWidth(); x++) {
            res->set(res_index, xfMinMax.get(x, y));
            res_index++;
        }
    }

    for (int y = 0; y < xmMinMax.getHeight(); y++) {
        for (int x = 0; x < xmMinMax.getWidth(); x++) {
            res->set(res_index, xmMinMax.get(x, y));
            res_index++;
        }
    }

    return res;
}


std::ostream& operator<< (std::ostream& os, const MSCNProblem& p)
{
    os << 'D' << ' ' << p.D << '\n';
    os << 'F' << ' ' << p.F << '\n';
    os << 'M' << ' ' << p.M << '\n';
    os << 'S' << ' ' << p.S << '\n';
    os << "sd";
    os << "\n";
    os << p.sd;
    os << "\n";
    os << "sf";
    os << "\n";
    os << p.sf;
    os << "\n";
    os << "sm";
    os << "\n";
    os << p.sm;
    os << "\n";
    os << "ss";
    os << "\n";
    os << p.ss;
    os << "\n";
    os << "cd";
    os << "\n";
    os << p.cd;
    os << "\n";
    os << "cf";
    os << "\n";
    os << p.cf;
    os << "\n";
    os << "cm";
    os << "\n";
    os << p.cm;
    os << "\n";
    os << "ud";
    os << "\n";
    os << p.ud;
    os << "\n";
    os << "uf";
    os << "\n";
    os << p.uf;
    os << "\n";
    os << "um";
    os << "\n";
    os << p.um;
    os << "\n";
    os << "p";
    os << "\n";
    os << p.ps;
    os << "\n";
    os << "xdminmax";
    os << "\n";
    os << p.xdMinMax;
    os << "\n";
    os << "xfminmax";
    os << "\n";
    os << p.xfMinMax;
    os << "\n";
    os << "xmminmax";
    os << "\n";
    os << p.xmMinMax;
    os << endl;

    return os;
}

void MSCNProblem::saveToFile(std::string const& path) {
    std::ofstream file(path);
    file << *this;
    file.close();
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

double MSCNProblem::calcIncome(Matrix<double> *xm) {
    double res = 0;
    for (int m = 0; m < M; m++)
        for (int s = 0; s < S; s++)
            res += ps.get(s) * xm->get(m, s);

    return res;
}

double MSCNProblem::calcTransportCost(Matrix<double> *xd, Matrix<double> *xf, Matrix<double> *xm) {
    double res = 0;

    for (int d = 0; d < D; d++)
        for (int f = 0; f < F; f++)
            res += cd.get(d, f) * xd->get(d, f);

    for (int f = 0; f < F; f++)
        for (int m = 0; m < M; m++)
            res += cf.get(f, m) * xf->get(f, m);

    for (int m = 0; m < M; m++)
        for (int s = 0; s < S; s++)
            res += cm.get(m, s) * xm->get(m, s);

    return res;
}

double MSCNProblem::calcServiceUsageCost(Matrix<double> *xd, Matrix<double> *xf, Matrix<double> *xm) {
    double res = 0;

    for (int d = 0; d < D; d++)
        if (xd->rowContainsPositiveNum(d)) res += ud.get(d);

    for (int f = 0; f < F; f++)
        if (xf->rowContainsPositiveNum(f)) res += uf.get(f);

    for (int m = 0; m < M; m++)
        if (xm->rowContainsPositiveNum(m)) res += um.get(m);

    return res;
}