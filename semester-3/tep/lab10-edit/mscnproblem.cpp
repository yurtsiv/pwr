#include "mscnproblem.h"
#include "random.h"

MscnProblem::MscnProblem()
{
    dCount = DEF_MSCN_D;
    fCount = DEF_MSCN_F;
    mCount = DEF_MSCN_M;
    sCount = DEF_MSCN_S;

    cd.resize(fCount, dCount);
    cf.resize(mCount, fCount);
    cm.resize(sCount, mCount);
    sd.resize(dCount);
    ud.resize(dCount);
    sf.resize(fCount);
    uf.resize(fCount);
    sm.resize(mCount);
    um.resize(mCount);
    ss.resize(sCount);
    ps.resize(sCount);

    specialResize(xdminmax, fCount, dCount);
    specialResize(xfminmax, mCount, fCount);
    specialResize(xmminmax, sCount, mCount);
}

MscnProblem::MscnProblem(std::istream &is)
{
    stream_ignore_char(is, 1);
    dCount = stream_get<int>(is);
    stream_ignore_char(is, 1);
    fCount = stream_get<int>(is);
    stream_ignore_char(is, 1);
    mCount = stream_get<int>(is);
    stream_ignore_char(is, 1);
    sCount = stream_get<int>(is);

    stream_ignore_char(is, 2);
    sd = Table<double>(is, dCount);
    stream_ignore_char(is, 2);
    sf = Table<double>(is, fCount);
    stream_ignore_char(is, 2);
    sm = Table<double>(is, mCount);
    stream_ignore_char(is, 2);
    ss = Table<double>(is, sCount);

    stream_ignore_char(is, 2);
    cd = Matrix<double>(is, fCount, dCount);
    stream_ignore_char(is, 2);
    cf = Matrix<double>(is, mCount, fCount);
    stream_ignore_char(is, 2);
    cm = Matrix<double>(is, sCount, mCount);

    stream_ignore_char(is, 2);
    ud = Table<double>(is, dCount);
    stream_ignore_char(is, 2);
    uf = Table<double>(is, fCount);
    stream_ignore_char(is, 2);
    um = Table<double>(is, mCount);
    stream_ignore_char(is, 1);
    ps = Table<double>(is, sCount);

    stream_ignore_char(is, 8);
    specialRead(xdminmax, is, fCount, dCount);
    stream_ignore_char(is, 8);
    specialRead(xfminmax, is, mCount, fCount);
    stream_ignore_char(is, 8);
    specialRead(xmminmax, is, sCount, mCount);
}

bool MscnProblem::setDCount(int newCount)
{
    if (newCount < 0) return false;

    dCount = newCount;
    cd.resize(fCount, dCount);
    sd.resize(dCount);
    ud.resize(dCount);
    specialResize(xdminmax, fCount, dCount);
    return true;
}
bool MscnProblem::setFCount(int newCount)
{
    if (newCount < 0) return false;

    fCount = newCount;
    cd.resize(fCount, dCount);
    cf.resize(mCount, fCount);
    sf.resize(fCount);
    uf.resize(fCount);
    specialResize(xdminmax, fCount, dCount);
    specialResize(xfminmax, mCount, fCount);
    return true;
}
bool MscnProblem::setMCount(int newCount)
{
    if (newCount < 0) return false;

    mCount = newCount;
    cf.resize(mCount, fCount);
    cm.resize(sCount, mCount);
    sm.resize(mCount);
    um.resize(mCount);
    specialResize(xfminmax, mCount, fCount);
    specialResize(xmminmax, sCount, mCount);
    return true;
}
bool MscnProblem::setSCount(int newCount)
{
    if (newCount < 0) return false;

    sCount = newCount;
    cm.resize(sCount, mCount);
    ss.resize(sCount);
    ps.resize(sCount);
    specialResize(xmminmax, sCount, mCount);
    return true;
}

int MscnProblem::technicalCheck(double const * const solution, int arrSize) const
{
    if(solution == NULL) return E_NULLPTR;

    if(arrSize != getSolutionLength()) return E_INV_ARR_SIZE;

    for(int i = 0; i < arrSize; ++i)
    {
        if (solution[i] < 0) return E_BAD_ARR_VAL;
    }
    return E_OK;
}

double MscnProblem::getKu(Matrix<double> &xd, Matrix<double> &xf, Matrix<double> &xm) const
{
    double result = 0;

    for(int i = 0; i < dCount; ++i)
    {
        if(anyHigherThanZeroInARow(xd, i)) result += ud[i];
    }

    for(int i = 0; i < fCount; ++i)
    {
        if(anyHigherThanZeroInARow(xf, i)) result += uf[i];
    }

    for(int i = 0; i < mCount; ++i)
    {
        if(anyHigherThanZeroInARow(xm, i)) result += um[i];
    }

    return result;
}

double MscnProblem::getKt(Matrix<double> &xd, Matrix<double> &xf, Matrix<double> &xm) const
{
    double result = 0;

    for(int i = 0; i < dCount; ++i)
        for(int j = 0; j < fCount; ++j)
            result += cd.get(i, j) * xd.get(i, j);

    for(int i = 0; i < fCount; ++i)
        for(int j = 0; j < mCount; ++j)
            result += cf.get(i, j) * xf.get(i, j);

    for(int i = 0; i < mCount; ++i)
        for(int j = 0; j < sCount; ++j)
            result += cm.get(i, j) * xm.get(i, j);

    return result;
}

double MscnProblem::getP(Matrix<double> &xm) const
{
    double result = 0;
    for(int i = 0; i < mCount; ++i)
        for(int j = 0; j < sCount; ++j)
            result += ps[j] * xm.get(i, j);
    return result;
}

double MscnProblem::getProfit(Matrix<double> &xd, Matrix<double> &xf, Matrix<double> &xm) const
{
    return getP(xm) - getKt(xd, xf, xm) - getKu(xd, xf, xm);
}

MscnSolution MscnProblem::parseSolution(double const * const solution) const
{
    Matrix<double> xd(fCount, dCount);
    Matrix<double> xf(mCount, fCount);
    Matrix<double> xm(sCount, mCount);

    for(int i = 0; i < dCount; ++i)
        for(int j = 0; j < fCount; ++j)
            xd.set(solution[i*fCount+j], i, j);

    int xdSize = xd.size();

    for(int i = 0; i < fCount; ++i)
        for(int j = 0; j < mCount; ++j)
            xf.set(solution[xdSize + i*mCount+j], i, j);

    int xfSize = xf.size();

    for(int i = 0; i < mCount; ++i)
        for(int j = 0; j < sCount; ++j)
            xm.set(solution[xdSize + xfSize + i*sCount+j], i, j);

    return { xd, xf, xm };
}

std::ostream& operator<<(std::ostream &os, const MscnProblem &p)
{
    os << 'D' << ' ' << p.dCount << '\n';
    os << 'F' << ' ' << p.fCount << '\n';
    os << 'M' << ' ' << p.mCount << '\n';
    os << 'S' << ' ' << p.sCount << '\n';
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
    os << p.xdminmax;
    os << "\n";
    os << "xfminmax";
    os << "\n";
    os << p.xfminmax;
    os << "\n";
    os << "xmminmax";
    os << "\n";
    os << p.xmminmax;
    os << "\n";

    return os;
}

bool MscnProblem::setInCd(double value, int i, int j)
{
    return setInMatrix(cd, value, i, j);
}
bool MscnProblem::setInCf(double value, int i, int j)
{
    return setInMatrix(cf, value, i, j);
}
bool MscnProblem::setInCm(double value, int i, int j)
{
    return setInMatrix(cm, value, i, j);
}

bool MscnProblem::setInSd(double value, int i)
{
    return setInTable(sd, value, i);
}
bool MscnProblem::setInSf(double value, int i)
{
    return setInTable(sf, value, i);
}
bool MscnProblem::setInSm(double value, int i)
{
    return setInTable(sm, value, i);
}
bool MscnProblem::setInSs(double value, int i)
{
    return setInTable(ss, value, i);
}
bool MscnProblem::setInUd(double value, int i)
{
    return setInTable(ud, value, i);
}
bool MscnProblem::setInUf(double value, int i)
{
    return setInTable(uf, value, i);
}
bool MscnProblem::setInUm(double value, int i)
{
    return setInTable(um, value, i);
}
bool MscnProblem::setInPs(double value, int i)
{
    return setInTable(ps, value, i);
}

bool MscnProblem::setInXdminmax(double value, int i, int j, int k)
{
    return setInMatrix(xdminmax, value, i, j, k);
}

bool MscnProblem::setInXfminmax(double value, int i, int j, int k)
{
    return setInMatrix(xfminmax, value, i, j, k);
}

bool MscnProblem::setInXmminmax(double value, int i, int j, int k)
{
    return setInMatrix(xmminmax, value, i, j, k);
}

double MscnProblem::getKt(double * solution) const
{
    MscnSolution x = parseSolution(solution);
    return getKt(x.xd, x.xf, x.xm);
}

double MscnProblem::getKu(double * solution) const
{
    MscnSolution x = parseSolution(solution);
    return getKu(x.xd, x.xf, x.xm);
}

double MscnProblem::getP(double * solution) const
{
    MscnSolution x = parseSolution(solution);
    return getP(x.xm);
}

Table<Table<double>> MscnProblem::getMinMaxValues() const
{
    int tablen = getSolutionLength();
    Table<Table<double>> tab(tablen);
    for(int i = 0; i < tablen; ++i)
        tab[i] = Table<double>(2);

    for(int i = 0; i < dCount; ++i)
        for(int j = 0; j < fCount; ++j)
            for(int k = 0; k < 2; ++k)
                tab[i*fCount + j][k] = xdminmax.get(i, j)[k];

    for(int i = 0; i < fCount; ++i)
        for(int j = 0; j < mCount; ++j)
            for(int k = 0; k < 2; ++k)
                tab[dCount*fCount + i*dCount + j][k] = xfminmax.get(i, j)[k];

    for(int i = 0; i < mCount; ++i)
        for(int j = 0; j < sCount; ++j)
            for(int k = 0; k < 2; ++k)
                tab[dCount*fCount + fCount * mCount + i*sCount + j][k] = xmminmax.get(i, j)[k];

    return tab;
}

int MscnProblem::getSolutionLength() const
{
    return dCount * fCount + fCount * mCount + mCount * sCount;
}

void MscnProblem::generateInstance(int intanceSeed)
{
    Random r(intanceSeed);
    randomize(cd, r, DEF_MSCN_RAND_C_MIN, DEF_MSCN_RAND_C_MAX);
    randomize(cf, r, DEF_MSCN_RAND_C_MIN, DEF_MSCN_RAND_C_MAX);
    randomize(cm, r, DEF_MSCN_RAND_C_MIN, DEF_MSCN_RAND_C_MAX);
    randomize(sd, r, DEF_MSCN_RAND_S_MIN, DEF_MSCN_RAND_S_MAX);
    randomize(sf, r, DEF_MSCN_RAND_S_MIN, DEF_MSCN_RAND_S_MAX);
    randomize(sm, r, DEF_MSCN_RAND_S_MIN, DEF_MSCN_RAND_S_MAX);
    randomize(ss, r, DEF_MSCN_RAND_S_MIN, DEF_MSCN_RAND_S_MAX);
    randomize(ud, r, DEF_MSCN_RAND_U_MIN, DEF_MSCN_RAND_U_MAX);
    randomize(uf, r, DEF_MSCN_RAND_U_MIN, DEF_MSCN_RAND_U_MAX);
    randomize(um, r, DEF_MSCN_RAND_U_MIN, DEF_MSCN_RAND_U_MAX);
    randomize(ps, r, DEF_MSCN_RAND_P_MIN, DEF_MSCN_RAND_P_MAX);
}

void MscnProblem::setDefaultMinMaxValues()
{
    for(int i = 0; i < dCount; ++i)
        for(int j = 0; j < fCount; ++j)
        {
            Table<double> tab(2);
            tab[0] = 0;
            tab[1] = sd[i];
            xdminmax.set(tab, i, j);
        }

    for(int i = 0; i < fCount; ++i)
        for(int j = 0; j < mCount; ++j)
        {
            Table<double> tab(2);
            tab[0] = 0;
            tab[1] = sf[i];
            xfminmax.set(tab, i, j);
        }

    for(int i = 0; i < mCount; ++i)
        for(int j = 0; j < sCount; ++j)
        {
            Table<double> tab(2);
            tab[0] = 0;
            tab[1] = sm[i];
            xmminmax.set(tab, i, j);
        }
}

double MscnProblem::getQuality(double const * const solution, int arrSize, int &errorCode) const
{
    if((errorCode = technicalCheck(solution, arrSize)) != 0) return 0;

    MscnSolution s = parseSolution(solution);

    return getProfit(s.xd, s.xf, s.xm);
}

bool MscnProblem::constraintsSatisfied(double const * const solution, int arrSize, int &errorCode) const
{
    if((errorCode = technicalCheck(solution, arrSize)) != 0) return false;

    MscnSolution s = parseSolution(solution);

    for(int i = 0; i < dCount; ++i)
    {
        if(sumInARow(s.xd, i) > sd[i]) return false;
    }

    for(int i = 0; i < fCount; ++i)
    {
        if(sumInARow(s.xf, i) > sf[i]) return false;
    }

    for(int i = 0; i < mCount; ++i)
    {
        if(sumInARow(s.xm, i) > sm[i]) return false;
    }

    for(int i = 0; i < sCount; ++i)
    {
        if(sumInAColumn(s.xm, i) > ss[i]) return false;
    }

    for(int i = 0; i < fCount; ++i)
    {
        if(sumInAColumn(s.xd, i) < sumInARow(s.xf, i)) return false;
    }

    for(int i = 0; i < mCount; ++i)
    {
        if(sumInAColumn(s.xf, i) < sumInARow(s.xm, i)) return false;
    }

    return true;
}

void MscnProblem::save(std::string const &path) const
{
    std::ofstream file(path);
    file << *this;
    file.close();
}

void MscnProblem::specialRead(Matrix<Table<double>> &mat, std::istream &is, int width, int height)
{
    specialResize(mat, width, height);

    for(int i = 0; i < height; ++i)
        for(int j = 0; j < width; ++j)
        {
            Table<double> tab(2);
            tab[0] = stream_get<double>(is);
            tab[1] = stream_get<double>(is);
            mat.set(tab, i, j);
        }
}

void MscnProblem::specialResize(Matrix<Table<double>> &mat, int width, int height)
{
    mat.resize(width, height);
    for(int i = 0; i < height; ++i)
        for(int j = 0; j < width; ++j)
            mat.set(Table<double>(2), i, j);
}
