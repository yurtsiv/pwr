#include <vector>

using namespace std;

class CFileErrCode
{
  private:
    FILE *pf_file = NULL;

  public:
    CFileErrCode();
    CFileErrCode(char* sFileName);
    ~CFileErrCode();
  
    bool bOpenFile(char* sFileName);
    bool bCloseFile();
    bool bPrintLine(char* sText);
    bool bPrintManyLines(vector<char*> sText);
};
