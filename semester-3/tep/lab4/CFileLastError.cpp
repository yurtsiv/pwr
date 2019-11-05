#include <iostream> 
#include <stdio.h>
#include <string>
#include <vector>
#include "CFileLastError.h"

using namespace std;

bool CFileLastError::b_last_error = false;

CFileLastError::CFileLastError() {}

CFileLastError::CFileLastError(string sFileName) {
  vOpenFile(sFileName);
}

CFileLastError::~CFileLastError() {
  if (pf_file != NULL) fclose(pf_file);
}

bool CFileLastError::checkFileOpened() {
  bool file_opened = pf_file != NULL;
  CFileLastError::b_last_error = !file_opened;
  return file_opened;
}

void CFileLastError::vOpenFile(string sFileName) {
  if (pf_file != NULL) {
    b_last_error = true;
    return;
  }

  pf_file = fopen((char *)&sFileName, "w+");

  checkFileOpened();
}

void CFileLastError::vCloseFile() {
  if (!checkFileOpened()) return;
  fclose(pf_file);
  pf_file = NULL;
}

void CFileLastError::vPrintLine(string sText) {
  if (!checkFileOpened()) return;

  fprintf(pf_file, (char *)&sText);
}

void CFileLastError::vPrintManyLines(vector<string> sText) {
  if (!checkFileOpened()) return;

  for (int i = 0; i < sText.size(); i++) {
    fprintf(pf_file, (char *)&sText[i]);
  }
}