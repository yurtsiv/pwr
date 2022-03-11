#include <iostream>
#include <string>
#include <cstring>
#include "CTable.h"

CTable::CTable() {
  s_name = defaultName;
  length = defaultSize;
  array_p = new int[defaultSize];
  std::cout << "bezp: " << s_name << std::endl;
}

CTable::CTable(std::string sName, int iTableLen) {
  s_name = sName;
  length = iTableLen;
  array_p = new int[iTableLen];
  std::cout << "parametr sName: " << sName << std::endl;
  std::cout << "parametr iTableLen: " << iTableLen << std::endl;
}

CTable::CTable(const CTable& pcOther):
  s_name(pcOther.s_name + "_copy"), length(pcOther.length)
{
  std::cout << "Cloning constructor: " << pcOther.s_name << std::endl;
  array_p = new int[pcOther.length];
  memcpy(array_p, pcOther.array_p, pcOther.length);
}

CTable::~CTable() {
  std::cout << "usuwam: " << s_name << std::endl;
  delete[] array_p;
}

CTable* CTable::pcClone() {
  return new CTable(*this);
}

void CTable::vSetName(std::string sName) {
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

std::string CTable::getName() {
  return s_name;
}
