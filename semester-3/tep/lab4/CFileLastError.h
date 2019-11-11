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
    CFileLastError(char* sFileName);
    ~CFileLastError();
  
    void vOpenFile(char* sFileName);
    void vCloseFile();
    void vPrintLine(char* sText);
    void vPrintManyLines(vector<char*> sText);
};
