#include "CTreeStatic.h"

CTreeStatic::CTreeStatic() {
    CNodeStatic root;
    c_root = root;
}

void CTreeStatic::vPrintTree() {
    c_root.vPrintAllBelow();
}

bool CTreeStatic::bMoveSubtree(CNodeStatic* pcParentNode, CNodeStatic* pcNewChildNode) {
    if (pcParentNode->getAbsoluteRoot() != &c_root) return false;

    pcNewChildNode->changeParent(pcParentNode);

    pcParentNode->vAddNewChild(pcNewChildNode);

    return true;
}
