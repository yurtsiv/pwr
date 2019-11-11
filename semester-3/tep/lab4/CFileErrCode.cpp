#include<stdio.h>
#include <vector>
#include "CFileErrCode.h"

using namespace std;

CFileErrCode::CFileErrCode() {}

CFileErrCode::CFileErrCode(char* sFileName) {
  bOpenFile(sFileName);
}

CFileErrCode::~CFileErrCode() {
  fclose(pf_file);
}

bool CFileErrCode::bOpenFile(char* sFileName) {
  if (pf_file != NULL) return false;

  pf_file = fopen(sFileName, "a+");

  return pf_file != NULL;
}

bool CFileErrCode::bCloseFile() {
  if (pf_file == NULL) return false;

  fclose(pf_file);
  return true;
}

bool CFileErrCode::bPrintLine(char* sText) {
  if (pf_file == NULL) return false;

  fprintf(pf_file, sText);
  return true;
}

bool CFileErrCode::bPrintManyLines(vector<char*> sText) {
  if (pf_file == NULL) return false;

  for (int i = 0; i < sText.size(); i++) {
    fprintf(pf_file, sText[i]);
  }

  return true;
}