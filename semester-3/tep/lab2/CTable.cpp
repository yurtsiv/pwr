#include <iostream>
#include <string>
#include <cstring>
#include "CTable.h"

using namespace std;

CTable::CTable() {
  s_name = defaultName;
  length = defaultSize;
  array_p = new int[defaultSize];
  cout << "bezp: " << s_name << endl;
}

CTable::CTable(string sName, int iTableLen) {
  s_name = sName;
  length = iTableLen;
  array_p = new int[iTableLen];
  cout << "parametr sName: " << sName << endl;
  cout << "parametr iTableLen: " << iTableLen << endl;
}

CTable::CTable(const CTable& pcOther):
  s_name(pcOther.s_name + "_copy"), length(pcOther.length)
{
  cout << "Cloning" << endl;
  array_p = new int[pcOther.length];
  memcpy(array_p, pcOther.array_p, pcOther.length);
}

CTable::~CTable() {
  cout << "usuwam: " << s_name << endl;
}

CTable* CTable::pcClone() {
  return new CTable(*this);
}

void CTable::vSetName(string sName) {
  s_name = sName;
}

bool CTable::bSetNewSize(int iTableLen) {
  if (iTableLen < 0) {
    return false;
  }

  length = iTableLen;
  int* prev_array_p = array_p;
  array_p = new int[iTableLen];
  memcpy(array_p, prev_array_p, iTableLen);

  delete[] prev_array_p;
  return true;
}

int CTable::getLen() {
  return length;
}

string CTable::getName() {
  return s_name;
}
