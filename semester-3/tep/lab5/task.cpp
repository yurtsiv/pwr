#include <iostream>
#include "CNodeStatic.h"

using namespace std;

void v_tree_test()
{
  CNodeStatic c_root;
  c_root.vAddNewChild(1);
  c_root.vAddNewChild(2);
  c_root.pcGetChild(0)->vAddNewChild(11);
  c_root.pcGetChild(0)->vAddNewChild(12);
  c_root.pcGetChild(1)->vAddNewChild(21);
  c_root.pcGetChild(1)->vAddNewChild(22);

  cout << "All below:" << endl;
  c_root.vPrintAllBelow();
  cout << "\nPrint up:" << endl;
  c_root.pcGetChild(0)->pcGetChild(1)->vPrintUp();
  cout << endl;
}

int main()
{
  v_tree_test();
  return 0;
}
