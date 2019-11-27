#include "CNodeDynamic.h"

template<typename T>
class CTreeDynamic {
    public:
        CTreeDynamic();
        ~CTreeDynamic();
        CNodeDynamic<T> *pcGetRoot() {return(pc_root);}
        void vPrintTree();
        bool bMoveSubtree(CNodeDynamic<T> *pcParentNode, CNodeDynamic<T> *pcNewChild);

    private:
        CNodeDynamic<T>* pc_root;
};

template<typename T>
CTreeDynamic<T>::CTreeDynamic() {
    pc_root = new CNodeDynamic<T>;
}

template<typename T>
CTreeDynamic<T>::~CTreeDynamic() {
    delete pc_root;
}

template<typename T>
void CTreeDynamic<T>::vPrintTree() {
    pc_root->vPrintAllBelow();
}

template<typename T>
bool CTreeDynamic<T>::bMoveSubtree(CNodeDynamic<T> *pcParentNode, CNodeDynamic<T> *pcNewChild) {
    if (pcParentNode->getAbsoluteRoot() != pc_root) return false;

    pcNewChild->changeParent(pcParentNode);

    pcParentNode->vAddNewChild(pcNewChild);

    return true;
}
