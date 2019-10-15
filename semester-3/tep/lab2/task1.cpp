#include <iostream>
#include <string>
#include <cstring>
#include "task1.h"

#define defaultName "CTable"
#define defaultSize 10

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
  cout << "parametr: " << sName << endl;
}

CTable::CTable(const CTable& pcOther):
  s_name(pcOther.s_name), length(pcOther.length)
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

void v_mod_tab(CTable *pcTab, int iNewSize) {
  pcTab->bSetNewSize(iNewSize);
}

void v_mod_tab(CTable cTab, int iNewSize) {
  cTab.bSetNewSize(iNewSize);
}


int main() {
  cout << "-- Creating static tables" << endl; 
  CTable s_table_default;
  CTable s_table_params("My static table", 20);

  cout << "-- Creating dynamic tables" << endl;
  CTable* d_table_default = new CTable();
  CTable* d_table_params = new CTable("My dynamic table", 20);

  cout << "-- Calling v_mod_tab(s_table_default, 20)" << endl;
  v_mod_tab(s_table_default, 20);
  cout << "Array len after calling v_mod_tab (not changed): " << s_table_default.getLen() << endl;

  cout << "-- Calling v_mod_tab(d_table_default, 20)" << endl;
  v_mod_tab(d_table_default, 20);
  cout << "Array len after calling v_mod_tab (changed): " << d_table_default->getLen() << endl;

  cout << "-- Cloning d_table_default" << endl;
  CTable* d_table_default_copy = d_table_default->pcClone();
  cout << "-- Changing cloned version" << endl;
  d_table_default_copy->vSetName("My cloned dynamic talbe");
  d_table_default_copy->bSetNewSize(50);
  cout << "Name of original version (not changed): " << d_table_default->getName() << endl;
  cout << "Array length of original version (not changed): " << d_table_default_copy->getLen() << endl;

  cout << "-- Deleting d_table_default, d_table_default_copy and d_table_params" << endl;
  delete d_table_default;
  delete d_table_default_copy;
  delete d_table_params;

  cout << "-- End of the program (s_table_default and s_table_params should be deleted automatically)" << endl;
  return 0;
}