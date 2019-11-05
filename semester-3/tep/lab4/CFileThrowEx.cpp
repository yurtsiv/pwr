#include<stdio.h>
#include <string>
#include <vector>
#include "CFileThrowEx.h"

using namespace std;

CFileThrowEx::CFileThrowEx() {}

CFileThrowEx::CFileThrowEx(string sFileName) {
  vOpenFile(sFileName);
}

CFileThrowEx::~CFileThrowEx() {
  fclose(pf_file);
}

void CFileThrowEx::checkFileOpened() {
  if (pf_file == NULL) {
    throw 1;
  }
}

void CFileThrowEx::vOpenFile(string sFileName) {
  if (pf_file != NULL) throw 1;

  pf_file = fopen((char*)&sFileName, "w+");
  checkFileOpened();
}

void CFileThrowEx::vCloseFile() {
  fclose(pf_file);
}

void CFileThrowEx::vPrintLine(string sText) {
  checkFileOpened();

  fprintf(pf_file, (char*)&sText);
}

void CFileThrowEx::vPrintManyLines(vector<string> sText) {
  checkFileOpened();

  for (int i = 0; i < sText.size(); i++) {
    fprintf(pf_file, (char*)&sText[i]);
  }
}