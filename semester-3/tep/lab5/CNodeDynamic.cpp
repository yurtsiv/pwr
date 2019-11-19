#include "CNodeDynamic.h"

CNodeDynamic::~CNodeDynamic() {
  for (int i = 0; i < v_children.size; i++)
    delete v_children.at(i);
}

void CNodeDynamic::vAddNewChild(int iChildVal) {
  CNodeDynamic* child = new CNodeDynamic;
  child->vSetValue(iChildVal);
  child->pc_parent_node = this;
  v_children.push_back(child);
}

CNodeDynamic* CNodeDynamic::pcGetChild(int iChildOffset) {
  if (iChildOffset < 0 || iChildOffset >= iGetChildrenNumber()) {
    return NULL;
  }

  return v_children.at(iChildOffset);
}

void CNodeDynamic::vPrintAllBelow() {
  vPrint();

  for (int i = 0; i < iGetChildrenNumber(); i++)
    v_children.at(i)->vPrintAllBelow();
}

void CNodeDynamic::vPrintUp() {
  vPrint();
  if (pc_parent_node != NULL)
    pc_parent_node->vPrintUp();
}