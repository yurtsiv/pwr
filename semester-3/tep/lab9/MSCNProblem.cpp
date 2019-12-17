#include "MSCNProblem.h"

MSCNProblem::MSCNProblem() {
	D = 1;
	F = 1;
	M = 1;
	S = 1;

	sd = new double[D];
	sf = new double[F];
	sm = new double[M];
	ss = new double[S];

	cd = new double*[D];
	for (int i = 0; i < D; i++) {
		cd[i] = new double[F];
	}

	cf = new double*[F];
	for (int i = 0; i < F; i++) {
		cf[i] = new double[M];
	}

	cm = new double*[M];
	for (int i = 0; i < M; i++) {
		cm[i] = new double[S];
	}

	ud = new double[D];
	uf = new double[F];
	um = new double[M];

	p = new double[S];

	xdminmax = new double*[2 * D];
	for (int i = 0; i < 2 * D; i++) {
		xdminmax[i] = new double[F];
	}

	xfminmax = new double*[2 * F];
	for (int i = 0; i < 2 * F; i++) {
		xfminmax[i] = new double[M];
	}

	xmminmax = new double*[2 * M];
	for (int i = 0; i < 2 * M; i++) {
		xmminmax[i] = new double[S];
	}

	xd = new double*[D];
	for (int i = 0; i < D; i++) {
		xd[i] = new double[F];
	}

	xf = new double*[F];
	for (int i = 0; i < F; i++) {
		xf[i] = new double[M];
	}

	xm = new double*[M];
	for (int i = 0; i < M; i++) {
		xm[i] = new double[S];
	}
}

MSCNProblem::~MSCNProblem() {
	delete[] sd;
	delete[] sf;
	delete[] sm;
	delete[] ss;

	for (int i = 0; i < D; i++) {
		delete[] cd[i];
	}
	delete[] cd;

	for (int i = 0; i < F; i++) {
		delete[] cf[i];
	}
	delete[] cf;

	for (int i = 0; i < M; i++) {
		delete[] cm[i];
	}
	delete[] cm;

	delete[] ud;
	delete[] uf;
	delete[] um;

	delete[] p;

	for (int i = 0; i < 2 * D; i++) {
		delete[] xdminmax[i];
	}
	delete[] xdminmax;

	for (int i = 0; i < 2 * F; i++) {
		delete[] xfminmax[i];
	}
	delete[] xfminmax;

	for (int i = 0; i < 2 * M; i++) {
		delete[] xmminmax[i];
	}
	delete[] xmminmax;

	for (int i = 0; i < D; i++) {
		delete[] xd[i];
	}
	delete[] xd;

	for (int i = 0; i < F; i++) {
		delete[] xf[i];
	}
	delete[] xf;

	for (int i = 0; i < M; i++) {
		delete[] xm[i];
	}
	delete[] xm;
}

bool MSCNProblem::bSetD(const int iVal) {
	if (iVal < 0 || iVal == D) {
		return false;
	}

	double* pd_new_sd = new double[iVal];
	double* pd_new_ud = new double[iVal];
	double** ppd_new_cd = new double*[iVal];
	double** ppd_new_xd = new double*[iVal];
	double** ppd_new_xdminmax = new double*[2 * iVal];

	int i_loop_len = (iVal < D) ? iVal : D;
	for (int i = 0; i < i_loop_len; i++) {
		pd_new_sd[i] = sd[i];
		pd_new_ud[i] = ud[i];
		ppd_new_cd[i] = cd[i];
		ppd_new_xd[i] = xd[i];
		ppd_new_xdminmax[i] = xdminmax[i];
	}


	for (int i = i_loop_len; i < 2 * i_loop_len; i++) {
		ppd_new_xdminmax[i] = xdminmax[i];
	}

	if (D < iVal) {
		for (int i = D; i < iVal; i++) {
			ppd_new_cd[i] = new double[F];
			ppd_new_xd[i] = new double[F];
		}
		for (int i = 2 * D; i < 2 * iVal; i++) {
			ppd_new_xdminmax[i] = new double[F];
		}
	}

	for (int i = iVal; i < D; i++) {
		delete[] cd[i];
		delete[] xd[i];
	}

	delete[] sd;
	delete[] ud;
	delete[] cd;
	delete[] xd;
	sd = pd_new_sd;
	ud = pd_new_ud;
	cd = ppd_new_cd;
	xd = ppd_new_xd;

	for (int i = 2 * iVal; i < 2 * D; i++) {
		delete[] xdminmax[i];
	}
	delete[] xdminmax;
	xdminmax = ppd_new_xdminmax;

	D = iVal;
	return true;
}

bool MSCNProblem::bSetF(const int iVal) {
	if (iVal < 0 || iVal == F) {
		return false;
	}

	double* pd_new_sf = new double[iVal];
	double* pd_new_uf = new double[iVal];
	double** ppd_new_cf = new double*[iVal];
	double** ppd_new_cd = new double*[D];
	double** ppd_new_xf = new double*[iVal];
	double** ppd_new_xd = new double*[D];
	double** ppd_new_xdminmax = new double*[2 * D];
	double** ppd_new_xfminmax = new double*[2 * iVal];

	for (int i = 0; i < D; i++) {
		ppd_new_cd[i] = new double[iVal];
		ppd_new_xd[i] = new double[iVal];
	}
	for (int i = 0; i < 2 * D; i++) {
		ppd_new_xdminmax[i] = new double[iVal];
	}

	int i_loop_len = (iVal < F) ? iVal : F;

	for (int i = 0; i < D; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_cd[i][j] = cd[i][j];
			ppd_new_xd[i][j] = xd[i][j];
			ppd_new_xdminmax[i][j] = xdminmax[i][j];
		}
	}

	for (int i = D; i < 2 * D; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_xdminmax[i][j] = xdminmax[i][j];
		}
	}


	for (int i = 0; i < i_loop_len; i++) {
		pd_new_sf[i] = sf[i];
		pd_new_uf[i] = uf[i];
		ppd_new_cf[i] = cf[i];
		ppd_new_xf[i] = xf[i];
		ppd_new_xfminmax[i] = xfminmax[i];
	}

	for (int i = i_loop_len; i < 2 * i_loop_len; i++) {
		ppd_new_xfminmax[i] = xfminmax[i];
	}

	if (F < iVal) {

		for (int i = F; i < iVal; i++) {
			ppd_new_cf[i] = new double[M];
			ppd_new_xf[i] = new double[M];
		}
		for (int i = 2 * F; i < 2 * iVal; i++) {
			ppd_new_xfminmax[i] = new double[M];
		}
	}

	for (int i = 0; i < D; i++) {
		for (int j = iVal; j < F; j++) {
			delete cd[i];
			delete xd[i];
		}
	}

	for (int i = iVal; i < F; i++) { //upewnij sie, czy nie trzeba usuwac od 0 
		delete[] cf[i];
		delete[] xf[i];
	}

	delete[] sf;
	delete[] uf;
	delete[] cf;
	delete[] xf;
	delete[] cd;
	delete[] xd;
	sf = pd_new_sf;
	uf = pd_new_uf;
	cd = ppd_new_cd;
	xd = ppd_new_xd;
	cf = ppd_new_cf;
	xf = ppd_new_xf;

	for (int i = 0; i < 2 * D; i++) {
		for (int j = iVal; j < F; j++) {
			delete[] xdminmax[i];
		}
	}

	for (int i = 2 * iVal; i < 2 * F; i++) {
		delete[] xfminmax[i];
	}
	delete[] xfminmax;
	delete[] xdminmax;
	xfminmax = ppd_new_xfminmax;
	xdminmax = ppd_new_xdminmax;

	F = iVal;

	return true;
}

bool MSCNProblem::bSetM(const int iVal) {
	if (iVal < 0 || iVal == M) {
		return false;
	}

	double* pd_new_sm = new double[iVal];
	double* pd_new_um = new double[iVal];
	double** ppd_new_cm = new double*[iVal];
	double** ppd_new_cf = new double*[F];
	double** ppd_new_xm = new double*[iVal];
	double** ppd_new_xf = new double*[F];
	double** ppd_new_xfminmax = new double*[2 * F];
	double** ppd_new_xmminmax = new double*[2 * iVal];

	for (int i = 0; i < F; i++) {
		ppd_new_cf[i] = new double[iVal];
		ppd_new_xf[i] = new double[iVal];
	}
	for (int i = 0; i < 2 * F; i++) {
		ppd_new_xfminmax[i] = new double[iVal];
	}

	int i_loop_len = (iVal < M) ? iVal : M;

	for (int i = 0; i < F; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_cf[i][j] = cf[i][j];
			ppd_new_xf[i][j] = xf[i][j];
			ppd_new_xfminmax[i][j] = xfminmax[i][j];
		}
	}

	for (int i = F; i < 2 * F; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_xfminmax[i][j] = xfminmax[i][j];
		}
	}


	for (int i = 0; i < i_loop_len; i++) {
		pd_new_sm[i] = sm[i];
		pd_new_um[i] = um[i];
		ppd_new_cm[i] = cm[i];
		ppd_new_xm[i] = xm[i];
		ppd_new_xmminmax[i] = xmminmax[i];
	}

	for (int i = i_loop_len; i < 2 * i_loop_len; i++) {
		ppd_new_xmminmax[i] = xmminmax[i];
	}

	if (M < iVal) {

		for (int i = M; i < iVal; i++) {
			ppd_new_cm[i] = new double[S];
			ppd_new_xm[i] = new double[S];
		}
		for (int i = 2 * M; i < 2 * iVal; i++) {
			ppd_new_xmminmax[i] = new double[S];
		}
	}

	for (int i = 0; i < F; i++) {
		for (int j = iVal; j < M; j++) {
			delete cf[i];
			delete xf[i];
		}
	}

	for (int i = iVal; i < M; i++) {
		delete[] cm[i];
		delete[] xm[i];
	}

	delete[] sm;
	delete[] um;
	delete[] cm;
	delete[] xm;
	delete[] cf;
	delete[] xf;
	sm = pd_new_sm;
	um = pd_new_um;
	cf = ppd_new_cf;
	xf = ppd_new_xf;
	cm = ppd_new_cm;
	xm = ppd_new_xm;

	for (int i = 0; i < 2 * F; i++) {
		for (int j = iVal; j < M; j++) {
			delete[] xfminmax[i];
		}
	}

	for (int i = 2 * iVal; i < 2 * M; i++) {
		delete[] xmminmax[i];
	}

	delete[] xmminmax;
	delete[] xfminmax;
	xmminmax = ppd_new_xmminmax;
	xfminmax = ppd_new_xfminmax;

	M = iVal;

	return true;
}

bool MSCNProblem::bSetS(const int iVal) {
	if (iVal < 0 || iVal == S) {
		return false;
  }

	double* pd_new_ss = new double[iVal];
	double** ppd_new_cm = new double*[M];
	double** ppd_new_xm = new double*[M];
	double** ppd_new_xmminmax = new double*[2 * M];
	double *pd_new_p = new double[iVal];

	for (int i = 0; i < M; i++) {
		ppd_new_cm[i] = new double[iVal];
		ppd_new_xm[i] = new double[iVal];
	}
	for (int i = 0; i < 2 * M; i++) {
		ppd_new_xmminmax[i] = new double[iVal];
	}

	int i_loop_len = (iVal < S) ? iVal : S;

	for (int i = 0; i < M; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_cm[i][j] = cm[i][j];
			ppd_new_xm[i][j] = xm[i][j];
			ppd_new_xmminmax[i][j] = xmminmax[i][j];
		}
	}

	for (int i = M; i < 2 * M; i++) {
		for (int j = 0; j < i_loop_len; j++) {
			ppd_new_xmminmax[i][j] = xmminmax[i][j];
		}
	}


	for (int i = 0; i < i_loop_len; i++) {
		pd_new_ss[i] = ss[i];
		pd_new_p[i] = p[i];
	}

	for (int i = 0; i < M; i++) {
		for (int j = iVal; j < S; j++) {
			delete cm[i];
			delete xm[i];
		}
	}

	delete[] ss;
	delete[] p;
	delete[] cm;
	delete[] xm;
	ss = pd_new_ss;
	p = pd_new_p;
	cm = ppd_new_cm;
	xm = ppd_new_xm;

	for (int i = 0; i < 2 * M; i++) {
		for (int j = iVal; j < S; j++) {
			delete[] xmminmax[i];
		}
	}

	delete[] xmminmax;
	xmminmax = ppd_new_xmminmax;

	S = iVal;

	return true;
}

bool MSCNProblem::bSetValInCd(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= D || iColumn < 0 || iColumn >= F) {
		return false;
	}
	cd[iRow][iColumn] = dVal;
	return true;
}

bool MSCNProblem::bSetValInCf(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= F || iColumn < 0 || iColumn >= M) {
		return false;
	}
	cf[iRow][iColumn] = dVal;
	return true;
}

bool MSCNProblem::bSetValInCm(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= M || iColumn < 0 || iColumn >= S) {
		return false;
	}
	cm[iRow][iColumn] = dVal;
	return true;
}


bool MSCNProblem::bSetValInSd(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= D) {
		return false;
	}
	sd[iIndex] = dVal;
}

bool MSCNProblem::bSetValInSf(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= F) {
		return false;
	}
	sf[iIndex] = dVal;
}

bool MSCNProblem::bSetValInSm(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= M) {
		return false;
	}
	sm[iIndex] = dVal;
}

bool MSCNProblem::bSetValInSs(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= S) {
		return false;
	}
	ss[iIndex] = dVal;
}

bool MSCNProblem::bSetValInUd(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= D) {
		return false;
	}
	ud[iIndex] = dVal;
}

bool MSCNProblem::bSetValInUf(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= F) {
		return false;
	}
	uf[iIndex] = dVal;
}

bool MSCNProblem::bSetValInUm(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= M) {
		return false;
	}
	um[iIndex] = dVal;
}

bool MSCNProblem::bSetValInP(int iIndex, double dVal) {
	if (iIndex < 0 || iIndex >= S) {
		return false;
	}
	p[iIndex] = dVal;
}

bool MSCNProblem::bSetValInXdminmax(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= 2 * D || iColumn < 0 || iColumn >= F) {
		return false;
	}
	xdminmax[iRow][iColumn] = dVal;
	return true;
}

bool MSCNProblem::bSetValInXfminmax(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= 2 * F || iColumn < 0 || iColumn >= M) {
		return false;
	}
	xfminmax[iRow][iColumn] = dVal;
	return true;
}

bool MSCNProblem::bSetValInXmminmax(int iRow, int iColumn, double dVal) {
	if (iRow < 0 || iRow >= 2 * M || iColumn < 0 || iColumn >= S) {
		return false;
	}
	xmminmax[iRow][iColumn] = dVal;
	return true;
}

double MSCNProblem::dGetMin(double * pdSolution, int iId) {
	if (iId >= D * F) {
		iId -= D * F;
	}
	else {
		return xdminmax[2 * (iId / F)][iId%F];
	}

	if (iId >= F * M) {
		iId -= F * M;
	}
	else {

		return xfminmax[2 * (iId / M)][iId%M];
	}

	if (iId >= M * S) {
		iId -= M * S;
	}
	else {
		return xmminmax[2 * (iId / S)][iId%S];
	}

	return -1; //tu powinna byc referencja bledu zmieniona na false;
}

double MSCNProblem::dGetMax(double * pdSolution, int iId) {

	if (iId >= D * F) {
		iId -= D * F;
	}
	else {
		return xdminmax[1 + 2 * (iId / F)][iId%F];
	}

	if (iId >= F * M) {
		iId -= F * M;
	}
	else {
		return xfminmax[1 + 2 * (iId / M)][iId%M];
	}

	if (iId >= M * S) {
		iId -= M * S;
	}
	else {
		return xmminmax[1 + 2 * (iId / S)][iId%S];
	}

	return -1;
}


double MSCNProblem::dCalculateTransportCost() {
	double d_sum = 0;

	for (int i = 0; i < D; i++) {
		for (int j = 0; j < F; j++) {
			d_sum += cd[i][j] * xd[i][j];
		}
	}

	for (int i = 0; i < F; i++) {
		for (int j = 0; j < M; j++) {
			d_sum += cf[i][j] * xf[i][j];
		}
	}

	for (int i = 0; i < M; i++) {
		for (int j = 0; j < S; j++) {
			d_sum += cm[i][j] * xm[i][j];
		}
	}
	return d_sum;
}

double MSCNProblem::dCalculateContractCost() {
	double d_sum = 0;

	for (int i = 0; i < D; i++) {
		double d_count_of_element = 0;
		for (int j = 0; j < F; j++) {
			d_count_of_element += xd[i][j];
		}
		d_sum += ud[i] * d_count_of_element;
	}

	for (int i = 0; i < F; i++) {
		double d_count_of_element = 0;
		for (int j = 0; j < M; j++) {
			d_count_of_element += xf[i][j];
		}
		d_sum += uf[i] * d_count_of_element;
	}

	for (int i = 0; i < M; i++) {
		double d_count_of_element = 0;
		for (int j = 0; j < S; j++) {
			d_count_of_element += xm[i][j];
		}
		d_sum += um[i] * d_count_of_element;
	}

	return d_sum;
}


double MSCNProblem::dCalculateIncome() {
	double d_sum = 0;
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < S; j++) {
			d_sum += p[i] * xd[i][j];
		}
	}
	return d_sum;
}

double MSCNProblem::dCalculateProfit() {
	return dCalculateIncome() - dCalculateTransportCost() - dCalculateContractCost();
}

double MSCNProblem::dGetQuality(double * pdSolution, bool &bIsSuccess) {
	bIsSuccess = true;

	if (pdSolution == NULL) {
		bIsSuccess = false;
	}

	int count = 0;
	D = pdSolution[count++];
	F = pdSolution[count++];
	M = pdSolution[count++];
	S = pdSolution[count++];
	for (int i = 0; i < D; i++) {
		for (int j = 0; j < F; j++) {
			if (pdSolution[count] >= 0) {
				xd[i][j] = pdSolution[count];
				count++;
			}
			else {
				bIsSuccess = false;
				i = D; j = F;
			}
		}
	}

	for (int i = 0; i < F; i++) {
		for (int j = 0; j < M; j++) {
			if (pdSolution[count] >= 0) {
				xf[i][j] = pdSolution[count];
				count++;
			}
			else {
				bIsSuccess = false;
				i = F; j = M;
			}
		}
	}

	for (int i = 0; i < M; i++) {
		for (int j = 0; j < S; j++) {
			if (pdSolution[count] >= 0) {
				xm[i][j] = pdSolution[count];
				count++;
			}
			else {
				bIsSuccess = false;
				i = M; j = S;
			}
		}
	}

	return dCalculateProfit();
}


bool MSCNProblem::bConstraintsSatisfied(double* pdSolution) {
	if (!pdSolution) {
		return false;
	}

	int count = 0;
	D = pdSolution[count++];
	F = pdSolution[count++];
	M = pdSolution[count++];
	S = pdSolution[count++];
	double d_sum_xd = 0;
	double d_sum_xf = 0;
	double d_sum_xm = 0;

	for (int i = 0; i < D; i++) {
		for (int j = 0; j < F; j++) {
			if (pdSolution[count] >= 0) {
				d_sum_xd += pdSolution[count];
				count++;
			}
			else {
				return false;
			}
		}
	}

	for (int i = 0; i < F; i++) {
		for (int j = 0; j < M; j++) {
			if (pdSolution[count] >= 0) {
				d_sum_xf += pdSolution[count];
				count++;
			}
			else {
				return false;
			}
		}
	}

	for (int i = 0; i < M; i++) {
		for (int j = 0; j < S; j++) {
			if (pdSolution[count] >= 0) {
				d_sum_xm += pdSolution[count];
				count++;
			}
			else {
				return false;
			}
		}
	}

	if (d_sum_xd < d_sum_xf || d_sum_xf < d_sum_xm) {
		return false;
	}

	count = 4;
	for (int i = 0; i < 2 * D; i = +2) {
		for (int j = 0; j < F; j++) {
			if (pdSolution[count] < xdminmax[i][j] || pdSolution[count] > xdminmax[i + 1][j]) {
				return false;
			}
			count++;
		}
	}

	for (int i = 0; i < 2 * F; i = +2) {
		for (int j = 0; j < M; j++) {
			if (pdSolution[count] < xfminmax[i][j] || pdSolution[count] > xfminmax[i + 1][j]) {
				return false;
			}
			count++;
		}
	}
	for (int i = 0; i < 2 * M; i = +2) {
		for (int j = 0; j < S; j++) {
			if (pdSolution[count] < xmminmax[i][j] || pdSolution[count] > xmminmax[i + 1][j]) {
				cout << pdSolution[count] << endl;
				cout << xmminmax[i][j] << endl;
				cout << xmminmax[i + 1][j] << endl;
				return false;
			}
			count++;
		}
	}

	return true;
}

bool MSCNProblem::bRead(string sFileName) {
	FILE* pf_file = fopen(sFileName.c_str(), "r");
	if (pf_file == NULL) {
		return false;
	}

	char c_val[25]; //stala
	int i_num;
	double d_num;
	fscanf(pf_file, "%s", c_val);
	fscanf(pf_file, "%i", &i_num);
	bSetD(i_num);
	fscanf(pf_file, "%s", c_val);
	fscanf(pf_file, "%i", &i_num);
	bSetF(i_num);
	fscanf(pf_file, "%s", c_val);
	fscanf(pf_file, "%i", &i_num);
	bSetM(i_num);
	fscanf(pf_file, "%s", c_val);
	fscanf(pf_file, "%i", &i_num);
	bSetS(i_num);

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < D; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInSd(i, d_num);
		cout << "sd[" << i << +"]: " << sd[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < F; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInSf(i, d_num);
		cout << "sf[" << i << +"]: " << sf[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < M; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInSm(i, d_num);
		cout << "sm[" << i << +"]: " << sm[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < S; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInSs(i, d_num);
		cout << "ss[" << i << +"]: " << ss[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < D; i++) {
		for (int j = 0; j < F; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInCd(i, j, d_num);
			cout << "cd[" << i << "][" << j << "]: " << cd[i][j] << "\n";
		}
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < F; i++) {
		for (int j = 0; j < M; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInCf(i, j, d_num);
			cout << "cf[" << i << "][" << j << "]: " << cf[i][j] << "\n";
		}
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < S; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInCm(i, j, d_num);
			cout << "cm[" << i << "][" << j << "]: " << cm[i][j] << "\n";
		}
	}

	fscanf(pf_file, "%s", c_val);;
	for (int i = 0; i < D; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInUd(i, d_num);
		cout << "ud[" << i << "]: " << ud[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);;
	for (int i = 0; i < D; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInUf(i, d_num);
		cout << "uf[" << i << "]: " << uf[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);;
	for (int i = 0; i < D; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInUm(i, d_num);
		cout << "um[" << i << "]: " << um[i] << "\n";
	}

	fscanf(pf_file, "%s", c_val);
	for (int i = 0; i < S; i++) {
		fscanf(pf_file, "%lf", &d_num);
		bSetValInP(i, d_num);
		cout << "p[" << i << "]: " << p[i] << "\n";
	}

	fscanf(pf_file, "%ls", c_val);
	for (int i = 0; i < 2 * D; i += 2) {
		for (int j = 0; j < F; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXdminmax(i, j, d_num);
			cout << "xdminmax[" << i << ", " << j << "]: " << xdminmax[i][j] << "\n";
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXdminmax(i + 1, j, d_num);
			cout << "xdminmax[" << i + 1 << ", " << j << "]: " << xdminmax[i + 1][j] << "\n";
		}
	}

	fscanf(pf_file, "%ls", c_val);
	for (int i = 0; i < 2 * F; i += 2) {
		for (int j = 0; j < M; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXfminmax(i, j, d_num);
			cout << "xfminmax[" << i << ", " << j << "]: " << xfminmax[i][j] << "\n";
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXfminmax(i + 1, j, d_num);
			cout << "xfminmax[" << i + 1 << ", " << j << "]: " << xfminmax[i + 1][j] << "\n";
		}
	}

	fscanf(pf_file, "%ls", c_val);
	for (int i = 0; i < 2 * M; i += 2) {
		for (int j = 0; j < S; j++) {
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXmminmax(i, j, d_num);
			cout << "xmminmax[" << i << ", " << j << "]: " << xmminmax[i][j] << "\n";
			fscanf(pf_file, "%lf", &d_num);
			bSetValInXmminmax(i + 1, j, d_num);
			cout << "xmminmax[" << i + 1 << ", " << j << "]: " << xmminmax[i + 1][j] << "\n";
		}
	}

	fclose(pf_file);
	return true;
}