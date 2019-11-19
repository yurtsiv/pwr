#include "CTreeDynamic.h"
#include "CNodeDynamic.h"

CTreeDynamic::CTreeDynamic() {
  pc_root = new CNodeDynamic;
}

CTreeDynamic::~CTreeDynamic() {
  delete pc_root;
}

void CTreeDynamic::vPrintTree() {
  pc_root->vPrintAllBelow();
}
