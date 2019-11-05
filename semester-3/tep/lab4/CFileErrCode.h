#include <string>
#include <vector>

using namespace std;

class CFileErrCode
{
  private:
    FILE *pf_file = NULL;

  public:
    CFileErrCode();
    CFileErrCode(string sFileName);
    ~CFileErrCode();
  
    bool bOpenFile(string sFileName);
    bool bCloseFile();
    bool bPrintLine(string sText);
    bool bPrintManyLines(vector<string> sText);
};
