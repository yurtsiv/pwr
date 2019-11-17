#include "CNodeStatic.h"


CNodeStatic::~CNodeStatic() {
  for (int i = 0; i < iGetChildrenNumber(); i++)
    delete v_children.at(i);
}

void CNodeStatic::vAddNewChild(int iChildVal) {
  CNodeStatic* child = new CNodeStatic;
  child->vSetValue(iChildVal);
  child->pc_parent_node = this;
  v_children.push_back(child);
}

CNodeStatic* CNodeStatic::pcGetChild(int iChildOffset) {
  if (iChildOffset < 0 || iChildOffset >= iGetChildrenNumber()) {
    return NULL;
  }

  return v_children.at(iChildOffset);
}

void CNodeStatic::vPrintAllBelow() {
  vPrint();

  for (int i = 0; i < iGetChildrenNumber(); i++)
    v_children.at(i)->vPrintAllBelow();
}

void CNodeStatic::vPrintUp() {
  vPrint();
  if (pc_parent_node != NULL)
    pc_parent_node->vPrintUp();
}
