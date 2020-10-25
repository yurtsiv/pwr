#include <iostream>
#include <vector>
#include "CNodeStatic.h"

using namespace std;

class CTreeStatic {
    private:
        CNodeStatic c_root;

    public:
        CTreeStatic();
        CNodeStatic *pcGetRoot() {return(&c_root);}
        void vPrintTree();
        bool bMoveSubtree(CNodeStatic* pcParentNode, CNodeStatic* pcNewChildNode);
};

