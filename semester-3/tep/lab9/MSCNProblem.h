
class MSCNProblem
{
  private:
    int D, F, M, S;
    double** cd;
    double** cf;
    double** cm;
    double* sd;
    double* sf;
    double* sm;
    double* ss;
    double* ud;
    double* uf;
    double* um;
  
  public:
    MSCNProblem();

    void vSetD(int d); 
    void vSetF(int f);
    void vSetM(int m);
    void vSetS(int s);

    void vSetToCd(int x, int y, double val);
    void vSetToCf(int x, int y, double val);
    void vSetToCm(int x, int y, double val);

    double dGetQuality(double** pdSolution); 

    bool bConstraintsSatisfied(double** pdSolution);

    double** minimum();
    double** maximum();
};

