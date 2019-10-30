#include <iostream>
#include <string>
#include "CTable.h"


int main() {


  CTable c_tab_0, c_tab_1;
  c_tab_0.bSetNewSize(4);
  c_tab_1.bSetNewSize(4);

  c_tab_0.vSetValueAt(0, 1);
  c_tab_0.vSetValueAt(1, 2);
  c_tab_0.vSetValueAt(2, 3);
  c_tab_0.vSetValueAt(3, 4);
  c_tab_0.vPrint();

  c_tab_1.vSetValueAt(0, 2);
  c_tab_1.vSetValueAt(1, 3);
  c_tab_1.vSetValueAt(2, 4);
  c_tab_1.vSetValueAt(3, 5);
  c_tab_1.vPrint();


  CTable c_tab_3 = c_tab_0 + c_tab_1;
  c_tab_3.vPrint();
  return 0;
}