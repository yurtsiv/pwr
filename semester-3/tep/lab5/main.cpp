#include <iostream>
#include "CTreeStatic.h"
#include "CTreeDynamic.h"

using namespace std;

void v_static_tree_test()
{
    /*
     *       0
     *     1    2
     *   11 12 21 22
     *
     */
    CTreeStatic tree1;
    tree1.pcGetRoot()->vAddNewChild(1);
    tree1.pcGetRoot()->vAddNewChild(2);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(11);
    tree1.pcGetRoot()->pcGetChild(0)->vAddNewChild(12);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(21);
    tree1.pcGetRoot()->pcGetChild(1)->vAddNewChild(22);

    cout << "-- Static tree 1 --" << endl;
    cout << "all below root:" << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << "\nprint up from 12:" << endl;
    tree1.pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();
    cout << endl;

    /*
     *       0
     *    3     4
     *  13 14 23 24
     *
     */
    CTreeStatic tree2;
    tree2.pcGetRoot()->vAddNewChild(3);
    tree2.pcGetRoot()->vAddNewChild(4);
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild(13);
    tree2.pcGetRoot()->pcGetChild(0)->vAddNewChild(14);
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild(23);
    tree2.pcGetRoot()->pcGetChild(1)->vAddNewChild(24);

    cout << "-- Static tree 2 --" << endl;
    cout << "all below root:" << endl;
    tree2.pcGetRoot()->vPrintAllBelow();
    cout << "\nprint up from 24:" << endl;
    tree2.pcGetRoot()->pcGetChild(1)->pcGetChild(1)->vPrintUp();
    cout << endl;

    CNodeStatic* parent = tree1.pcGetRoot()->pcGetChild(1);
    CNodeStatic* child = tree2.pcGetRoot()->pcGetChild(0);

    cout << "-- Moving subtree --" << endl;
    if (!tree1.bMoveSubtree(tree2.pcGetRoot(), child)) {
        cout << "Failed to move subtree (parent does not belong to the tree)" << endl;
    }

    tree1.bMoveSubtree(parent, child);
    cout << "Subtree moved successfully" << endl;
    tree1.pcGetRoot()->vPrintAllBelow();
    cout << endl;
    tree2.pcGetRoot()->vPrintAllBelow();
}

void v_dynamic_tree_test()
{
    /*
     *       0
     *     1    2
     *   11 12 21 22
     *
     */
    CTreeDynamic* tree1 = new CTreeDynamic;
    tree1->pcGetRoot()->vAddNewChild(1);
    tree1->pcGetRoot()->vAddNewChild(2);
    tree1->pcGetRoot()->pcGetChild(0)->vAddNewChild(11);
    tree1->pcGetRoot()->pcGetChild(0)->vAddNewChild(12);
    tree1->pcGetRoot()->pcGetChild(1)->vAddNewChild(21);
    tree1->pcGetRoot()->pcGetChild(1)->vAddNewChild(22);

    cout << "-- Dynamic tree 1 --" << endl;
    cout << " all below root:" << endl;
    tree1->pcGetRoot()->vPrintAllBelow();
    cout << "\n print up from 12:" << endl;
    tree1->pcGetRoot()->pcGetChild(0)->pcGetChild(1)->vPrintUp();
    cout << endl;

    /*
     *       0
     *    3     4
     *  13 14 23 24
     *
     */
    CTreeDynamic *tree2 = new CTreeDynamic;
    tree2->pcGetRoot()->vAddNewChild(3);
    tree2->pcGetRoot()->vAddNewChild(4);
    tree2->pcGetRoot()->pcGetChild(0)->vAddNewChild(13);
    tree2->pcGetRoot()->pcGetChild(0)->vAddNewChild(14);
    tree2->pcGetRoot()->pcGetChild(1)->vAddNewChild(23);
    tree2->pcGetRoot()->pcGetChild(1)->vAddNewChild(24);

    cout << "-- Dynamic tree 2 --" << endl;
    cout << " all below root:" << endl;
    tree2->pcGetRoot()->vPrintAllBelow();
    cout << "\n print up from 24:" << endl;
    tree2->pcGetRoot()->pcGetChild(1)->pcGetChild(1)->vPrintUp();
    cout << endl;

    CNodeDynamic* parent = tree1->pcGetRoot()->pcGetChild(1);
    CNodeDynamic* child = tree2->pcGetRoot()->pcGetChild(0);

    cout << "-- Moving subtree --" << endl;
    if (!tree1->bMoveSubtree(tree2->pcGetRoot(), child)) {
        cout << "Failed to move subtree (parent does not belong to the tree)" << endl;
    }

    tree1->bMoveSubtree(parent, child);
    cout << "Subtree moved successfully" << endl;
    tree1->pcGetRoot()->vPrintAllBelow();
    cout << endl;
    tree2->pcGetRoot()->vPrintAllBelow();
}

int main() {

    v_static_tree_test();
    cout << "\n\n" << endl;
    v_dynamic_tree_test();
    return 0;
}
