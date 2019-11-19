#include "CTreeStatic.h"
#include "CNodeStatic.h"

CTreeStatic::CTreeStatic() {
  CNodeStatic root;
  c_root = root;
}

CTreeStatic::~CTreeStatic() {}

void CTreeStatic::vPrintTree() {
  c_root.vPrintAllBelow();
}
