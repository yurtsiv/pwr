#include <iostream>
#include <string>

#include "CFileLastError.h"
#include "CFileThrowEx.h"
#include "CFileErrCode.h"

using namespace std;

int main() {
  char* file_name = "log.txt";

  CFileLastError last_err_file_opener;
  last_err_file_opener.vOpenFile(file_name);

  if (last_err_file_opener.bGetLastError()) {
    cout << "File opening failed" << endl;
  } else {
    last_err_file_opener.vPrintLine("Hello from CFileLastError\n");
  }

  last_err_file_opener.vCloseFile();

  CFileThrowEx ex_file_opener;
  try {
    ex_file_opener.vOpenFile(file_name);
    ex_file_opener.vPrintLine("Hello from CFileThrowEx\n");
  } catch (int e) {
    cout << "File opening failed" << endl;
  }

  last_err_file_opener.vCloseFile();

  CFileErrCode err_code_file_opener;
  if(err_code_file_opener.bOpenFile(file_name)) {
    err_code_file_opener.bPrintLine("Hello from CFileErrCode\n");
  } else {
    cout << "File opening failed" << endl;
  }

  return 0;
}