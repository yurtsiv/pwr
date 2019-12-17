#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

class MSCNProblem{
private:
	int D;
	int F;
	int M;
	int S;
	double* sd;
	double* sf;
	double* sm;
	double* ss;

	double** cd;
	double** cf;
	double** cm;

	double* ud;
	double* uf;
	double* um;
	double* p;

	double** xdminmax;
	double** xfminmax;
	double** xmminmax;

	double** xd;
	double** xf;
	double** xm;

public:
	MSCNProblem();
	~MSCNProblem();

	bool bSetD(const int iVal);
	bool bSetF(const int iVal);
	bool bSetM(const int iVal);
	bool bSetS(const int iVal);
	
	bool bSetValInCd(int iRow, int iColumn, double dVal);
	bool bSetValInCf(int iRow, int iColumn, double dVal);
	bool bSetValInCm(int iRow, int iColumn, double dVal);

	bool bSetValInSd(int iIndex, double dVal);
	bool bSetValInSf(int iIndex, double dVal);
	bool bSetValInSm(int iIndex, double dVal);
	bool bSetValInSs(int iIndex, double dVal);

	bool bSetValInUd(int iIndex, double dVal);
	bool bSetValInUf(int iIndex, double dVal);
	bool bSetValInUm(int iIndex, double dVal);
	
	bool bSetValInP(int iIndex, double dVal);

	bool bSetValInXdminmax(int iRow, int iColumn, double dVal);
	bool bSetValInXfminmax(int iRow, int iColumn, double dVal);
	bool bSetValInXmminmax(int iRow, int iColumn, double dVal);

	double dGetMin(double* pdSolution, int iId);
	double dGetMax(double* pdSolution, int iId);
	double dCalculateTransportCost(); 
	double dCalculateContractCost();
	double dCalculateIncome();
	double dCalculateProfit();

	double dGetQuality(double *pdSolution, bool &isSuccess);
	bool bConstraintsSatisfied(double *pdSolution);
	bool bRead(string sFileName);
};
