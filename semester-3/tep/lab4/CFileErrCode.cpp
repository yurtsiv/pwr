#include <iostream>
#include<stdio.h>
#include <string>
#include <vector>
#include "CFileErrCode.h"

using namespace std;

CFileErrCode::CFileErrCode() {}

CFileErrCode::CFileErrCode(string sFileName) {
  bOpenFile(sFileName);
}

CFileErrCode::~CFileErrCode() {
  fclose(pf_file);
}

bool CFileErrCode::bOpenFile(string sFileName) {
  if (pf_file != NULL) return false;

  pf_file = fopen((char*)&sFileName, "w+");

  return pf_file != NULL;
}

bool CFileErrCode::bCloseFile() {
  if (pf_file == NULL) return false;

  fclose(pf_file);
  return true;
}

bool CFileErrCode::bPrintLine(string sText) {
  if (pf_file == NULL) return false;

  fprintf(pf_file, (char*)&sText);
  return true;
}

bool CFileErrCode::bPrintManyLines(vector<string> sText) {
  if (pf_file == NULL) return false;

  for (int i = 0; i < sText.size(); i++) {
    fprintf(pf_file, (char*)&sText[i]);
  }

  return true;
}