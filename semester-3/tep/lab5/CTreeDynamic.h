#include "CNodeDynamic.h"

class CTreeDynamic
{
  public:
    CTreeDynamic();
    ~CTreeDynamic();
    CNodeDynamic *pcGetRoot() {return(pc_root);}
    void vPrintTree();

  private:
    CNodeDynamic* pc_root;
};
