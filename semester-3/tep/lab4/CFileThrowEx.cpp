#include<stdio.h>
#include <string>
#include <vector>
#include "CFileThrowEx.h"

using namespace std;

CFileThrowEx::CFileThrowEx() {}

CFileThrowEx::CFileThrowEx(char* sFileName) {
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

void CFileThrowEx::vOpenFile(char* sFileName) {
  if (pf_file != NULL) throw 1;

  pf_file = fopen(sFileName, "a+");
  checkFileOpened();
}

void CFileThrowEx::vCloseFile() {
  fclose(pf_file);
}

void CFileThrowEx::vPrintLine(char* sText) {
  checkFileOpened();

  fprintf(pf_file, sText);
}

void CFileThrowEx::vPrintManyLines(vector<char*> sText) {
  checkFileOpened();

  for (int i = 0; i < sText.size(); i++) {
    fprintf(pf_file, sText[i]);
  }
}