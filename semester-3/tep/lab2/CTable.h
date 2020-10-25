#include <string>

#define defaultName "CTable"
#define defaultSize 10

class CTable {
	public:
		CTable();
		CTable(std::string sName, int iTableLen);
		CTable(const CTable &pcOther);
    ~CTable();
    CTable* pcClone();
    void vSetName(std::string sName);
    bool bSetNewSize(int iTableLen);
    int getLen();
    std::string getName();

	private:
    std::string s_name;
    int* array_p;
    int length;
};