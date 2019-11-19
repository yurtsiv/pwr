#include <iostream>
#include <vector>

using namespace std;

class CTreeStatic
{
  private:
    CNodeStatic c_root;

  public:
    CTreeStatic();
    ~CTreeStatic();
    CNodeStatic *pcGetRoot() {return(&c_root);}
    void vPrintTree();
    bool bMoveSubtree(CNodeStatic* pcParentNode, CNodeStatic* pcNewChildNode);
};
