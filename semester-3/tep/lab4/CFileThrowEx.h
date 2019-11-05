#include <string>
#include <vector>

using namespace std;

class CFileThrowEx
{
  private:
    FILE *pf_file = NULL;
    void checkFileOpened();
  
  public:
    CFileThrowEx();
    CFileThrowEx(string sFileName);
    ~CFileThrowEx();
  
    void vOpenFile(string sFileName);
    void vCloseFile();
    void vPrintLine(string sText);
    void vPrintManyLines(vector<string> sText);
};
