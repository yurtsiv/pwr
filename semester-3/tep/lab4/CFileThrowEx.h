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
    CFileThrowEx(char* sFileName);
    ~CFileThrowEx();
  
    void vOpenFile(char* sFileName);
    void vCloseFile();
    void vPrintLine(char* sText);
    void vPrintManyLines(vector<char*> sText);
};
