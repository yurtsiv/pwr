#include "CNodeStatic.h"

void CNodeStatic::vAddNewChild(int iChildVal) {
    CNodeStatic child;
    child.vSetValue(iChildVal);
    child.pc_parent_node = this;
    v_children.push_back(child);
}

void CNodeStatic::vAddNewChild(CNodeStatic* child) {
    v_children.push_back(*child);
}

CNodeStatic* CNodeStatic::pcGetChild(int iChildOffset) {
    if (iChildOffset < 0 || iChildOffset >= iGetChildrenNumber()) {
        return NULL;
    }

    return &(v_children.at(iChildOffset));
}

void CNodeStatic::vPrintAllBelow() {
    vPrint();

    for (int i = 0; i < iGetChildrenNumber(); i++)
        v_children.at(i).vPrintAllBelow();
}

void CNodeStatic::vPrintUp() {
    vPrint();
    if (pc_parent_node != NULL)
        pc_parent_node->vPrintUp();
}

CNodeStatic *CNodeStatic::getAbsoluteRoot() {
    if (pc_parent_node == NULL) return this;
    pc_parent_node->getAbsoluteRoot();
}

void CNodeStatic::changeParent(CNodeStatic* newParent) {
    vector<CNodeStatic> *siblings = &pc_parent_node->v_children;
    vector<CNodeStatic> new_siblings;
    for (int i = 0; i < siblings->size(); i++) {
        if (&siblings->at(i) != this) {
            new_siblings.push_back(siblings->at(i));
        }
    }

    pc_parent_node->v_children = new_siblings;

    pc_parent_node = newParent;
}
