#include <iostream>
#include <string>
#include <cstring>
#include "CTable.h"

void example(CTable tableVal) {}

int main() {


  CTable c_tab_0, c_tab_1;
  c_tab_0.bSetNewSize(6);
  c_tab_1.bSetNewSize(4);

  c_tab_0.vSetValueAt(0, 1);
  c_tab_0.vSetValueAt(1, 2);
  c_tab_0.vSetValueAt(2, 3);
  c_tab_0.vSetValueAt(3, 4);
  c_tab_0.vSetValueAt(4, 5);
  c_tab_0.vSetValueAt(5, 6);

  c_tab_1.vSetValueAt(0, 7);
  c_tab_1.vSetValueAt(1, 8);
  c_tab_1.vSetValueAt(2, 9);
  c_tab_1.vSetValueAt(3, 10);

  CTable c_tab_3 = c_tab_0 + c_tab_1;
  c_tab_3.vPrint();
  return 0;
}