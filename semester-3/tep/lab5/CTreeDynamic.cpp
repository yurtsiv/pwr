#include "CTreeDynamic.h"

CTreeDynamic::CTreeDynamic() {
    pc_root = new CNodeDynamic;
}

CTreeDynamic::~CTreeDynamic() {
    delete pc_root;
}

void CTreeDynamic::vPrintTree() {
    pc_root->vPrintAllBelow();
}

bool CTreeDynamic::bMoveSubtree(CNodeDynamic *pcParentNode, CNodeDynamic *pcNewChild) {
    if (pcParentNode->getAbsoluteRoot() != pc_root) return false;

    pcNewChild->changeParent(pcParentNode);

    pcParentNode->vAddNewChild(pcNewChild);

    return true;
}