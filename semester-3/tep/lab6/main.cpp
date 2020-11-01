#include <iostream>
#include "CTreeDynamic.h"

using namespace std;

void v_dynamic_tree_test_str()
{
    /*
     *       0
     *     1    2
     *   11 12 21 22
     *
     */
    CTreeDynamic<string> tree1;
    tree1.pcGetRoot()->vSetValue("Node 0");
    tree1.pcGetRoot()->vAddNewChild("Node 1");
    tree1.pcGetRoot()->vAddNewChild("Node 2");
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild("Node 11");
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild("Node 12");
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild("Node 21");
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild("Node 22");

    cout << "-- Dynamic tree 1 (string nodes) --\n" << endl;
    cout << " all below root: " << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << "\n\n print up from Node 12:  " << endl;
    tree1.pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();

    /*
     *       0
     *    3     4
     *  13 14 23 24
     *
     */
    CTreeDynamic<string> tree2;
    tree2.pcGetRoot()->vSetValue("Node 0");
    tree2.pcGetRoot()->vAddNewChild("Node 3");
    tree2.pcGetRoot()->vAddNewChild("Node 4");
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild("Node 13");
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild("Node 14");
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild("Node 23");
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild("Node 24");

    cout << "\n\n-- Dynamic tree 2 (string nodes) --\n" << endl;
    cout << " all below root:  " << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << "\n\n print up from Node 14:  " << endl;
    tree1.pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();
    cout << endl;

    CNodeDynamic<string>* parent = tree1.pcGetRoot()->pcGetChild(1);
    CNodeDynamic<string>* child = tree2.pcGetRoot()->pcGetChild(0);

    cout << "\n\n-- Moving subtree --" << endl;

    tree1.bMoveSubtree(parent, child);
    cout << "\n\nTree 1 after moving\n" << endl;
    tree1.vPrintTree();
    cout << endl;
    cout << "\n\nTree 2 after moving\n" << endl;
    tree2.vPrintTree();
}


void v_dynamic_tree_test_double()
{
    /*
     *       0
     *     1    2
     *   11 12 21 22
     *
     */
    CTreeDynamic<double> tree1;
    tree1.pcGetRoot()->vSetValue(0);
    tree1.pcGetRoot()->vAddNewChild(1);
    tree1.pcGetRoot()->vAddNewChild(2);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(11);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(12);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(21);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(22);

    cout << "\n\n-- Dynamic tree 1 (double nodes) --\n" << endl;
    cout << " all below root:  " << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << "\n\n print up from Node 12:  " << endl; 
    tree1.pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();
    cout << endl;

    /*
     *       0
     *    3     4
     *  13 14 23 24
     *
     */
    CTreeDynamic<double> tree2;
    tree2.pcGetRoot()->vSetValue(0);
    tree2.pcGetRoot()->vAddNewChild(3);
    tree2.pcGetRoot()->vAddNewChild(4);
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild(13);
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild(14);
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild(23);
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild(24);

    cout << "\n\n-- Dynamic tree 2 (double nodes) --\n" << endl;
    cout << "all below root:  " << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << "\n\nprint up from Node 14: n" << endl; 
    tree1.pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();
    cout << endl;

    CNodeDynamic<double>* parent = tree1.pcGetRoot()->pcGetChild(1);
    CNodeDynamic<double>* child = tree2.pcGetRoot()->pcGetChild(0);

    cout << "\n\n-- Moving subtree --" << endl;

    tree1.bMoveSubtree(parent, child);
    cout << "\n\nTree 1 after moving\n" << endl;
    tree1.vPrintTree();
    cout << "\n\nTree 2 after moving\n" << endl;
    tree2.vPrintTree();
}

void v_pretty_print_test()
{
    /*
     *       0
     *     1    2
     *   11 12 21 22
     *
     */

    cout << "\n\n -- Pretty printing: -- \n\n" << endl;
    CTreeDynamic<double> tree1;
    tree1.pcGetRoot()->vSetValue(0);
    tree1.pcGetRoot()->vAddNewChild(1);
    tree1.pcGetRoot()->vAddNewChild(2);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(11);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(12);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(21);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(22);

    tree1.vPrintPretty();
}


int main() {
    v_dynamic_tree_test_str();
    v_dynamic_tree_test_double();
    v_pretty_print_test();
    return 0;
}
