#include <iostream>
#include <string>
#include <cstring>
#include "CTable.h"

void v_mod_tab(CTable *pcTab, int iNewSize) {
  pcTab->bSetNewSize(iNewSize);
}

void v_mod_tab(CTable cTab, int iNewSize) {
  cTab.bSetNewSize(iNewSize);
}


int main() {
  cout << "-- Creating static CTable" << endl; 
  CTable s_table_default;
  CTable s_table_params("Static table", 20);

  cout << "-- Creating dynamic CTable" << endl;
  CTable* d_table_default = new CTable();
  CTable* d_table_params = new CTable("Dynamic table", 20);

  cout << "-- Creating array of CTable" << endl;
  CTable* d_table_default_array = new CTable[3];

  cout << "-- Calling v_mod_tab(s_table_default, 20)" << endl;
  v_mod_tab(s_table_default, 20);
  cout << "Array len after calling v_mod_tab (not changed): " << s_table_default.getLen() << endl;

  cout << "-- Calling v_mod_tab(d_table_default, 20)" << endl;
  v_mod_tab(d_table_default, 20);
  cout << "Array len after calling v_mod_tab (changed): " << d_table_default->getLen() << endl;

  cout << "-- Cloning d_table_default" << endl;
  CTable* d_table_default_copy = d_table_default->pcClone();
  cout << "-- Changing cloned version" << endl;
  d_table_default_copy->vSetName("Cloned dynamic table");
  d_table_default_copy->bSetNewSize(50);
  cout << "Name of original version (not changed): " << d_table_default->getName() << endl;
  cout << "Array length of original version (not changed): " << d_table_default_copy->getLen() << endl;

  cout << "-- Deleting d_table_default, d_table_default_copy, d_table_params and d_table_default_array" << endl;
  delete d_table_default;
  delete d_table_default_copy;
  delete d_table_params;
  delete[] d_table_default_array;

  cout << "-- End of the program (s_table_default and s_table_params should be deleted automatically)" << endl;
  return 0;
}