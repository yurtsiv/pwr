#include <string>
#include <vector>

using namespace std;

class CFileLastError
{
  private:
    static bool b_last_error;
    FILE *pf_file = NULL;
    bool checkFileOpened();

  
  public:
    static bool bGetLastError() { return (b_last_error); }

    CFileLastError();
    CFileLastError(string sFileName);
    ~CFileLastError();
  
    void vOpenFile(string sFileName);
    void vCloseFile();
    void vPrintLine(string sText);
    void vPrintManyLines(vector<string> sText);
};
