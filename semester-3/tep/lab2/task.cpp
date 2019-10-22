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

void printSectionTitle(std::string title) {
  std::cout << "\n--------------------------------" << std::endl; 
  std::cout << title << std::endl; 
  std::cout << "--------------------------------" << std::endl; 
}

int main() {
  printSectionTitle("Creating static CTable");
  CTable s_table_default;
  CTable s_table_params("Static table", 20);


  printSectionTitle("Creating dynamic CTable");
  CTable* d_table_default = new CTable();
  CTable* d_table_params = new CTable("Dynamic table", 20);


  printSectionTitle("Creating dynamic array of CTable");
  CTable* d_table_default_array = new CTable[3];


  printSectionTitle("Executing v_mod_tab(s_table_default, 20)");
  v_mod_tab(s_table_default, 20);
  std::cout << "Table length after calling v_mod_tab (not changed): " << s_table_default.getLen() << std::endl;


  printSectionTitle("Calling v_mod_tab(d_table_default, 20)");
  v_mod_tab(d_table_default, 20);
  std::cout << "Array len after calling v_mod_tab (changed): " << d_table_default->getLen() << std::endl;


  printSectionTitle("Cloning d_table_default");
  CTable* d_table_default_copy = d_table_default->pcClone();

  printSectionTitle("Changing cloned version");
  d_table_default_copy->vSetName("Cloned dynamic table");
  d_table_default_copy->bSetNewSize(50);
  std::cout << "Name of original version (not changed): " << d_table_default->getName() << std::endl;
  std::cout << "Array length of original version (not changed): " << d_table_default_copy->getLen() << std::endl;

  printSectionTitle("Deleting d_table_default, d_table_default_copy, d_table_params and d_table_default_array");
  delete d_table_default;
  delete d_table_default_copy;
  delete d_table_params;
  delete[] d_table_default_array;

  printSectionTitle("End of the program (s_table_default and s_table_params should be deleted automatically)");

  return 0;
}