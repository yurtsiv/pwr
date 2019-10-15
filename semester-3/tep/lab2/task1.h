#include <string>

using namespace std;

class CTable {
	public:
		CTable();
		CTable(string sName, int iTableLen);
		CTable(const CTable &pcOther);
    ~CTable();
    CTable* pcClone();
    void vSetName(string sName);
    bool bSetNewSize(int iTableLen);
    int getLen();
    string getName();


	private:
    string s_name;
    int* array_p;
    int length;
};