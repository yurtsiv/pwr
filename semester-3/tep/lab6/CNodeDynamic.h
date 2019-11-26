#include <iostream>
#include <vector>

using namespace std;

template<typename T>
class CNodeDynamic {
    public:
        CNodeDynamic(): i_val(0), pc_parent_node(NULL) {}
        ~CNodeDynamic();

        void vSetValue(T iNewVal) { i_val = iNewVal; }

        int iGetChildrenNumber() { return v_children.size(); }
        void vAddNewChild(T iChildVal);
        void vAddNewChild(CNodeDynamic<T> *child);
        CNodeDynamic<T>* pcGetChild(int iChildOffset);
        void changeParent(CNodeDynamic<T>* newParent);
        CNodeDynamic<T>* getAbsoluteRoot();

        void vPrint() { cout << " " << i_val; };
        void vPrintAllBelow();
        void vPrintUp();

    private:
        vector<CNodeDynamic<T>*> v_children;
        CNodeDynamic<T> *pc_parent_node;
        T i_val;
};


template<typename T>
CNodeDynamic<T>::~CNodeDynamic() {
    for (int i = 0; i < v_children.size(); i++)
        delete v_children.at(i);
}

template<typename T>
void CNodeDynamic<T>::vAddNewChild(T iChildVal) {
    CNodeDynamic* child = new CNodeDynamic;
    child->vSetValue(iChildVal);
    child->pc_parent_node = this;
    v_children.push_back(child);
}

template<typename T>
void CNodeDynamic<T>::vAddNewChild(CNodeDynamic<T> *child) {
    v_children.push_back(child);
}

template<typename T>
CNodeDynamic<T>* CNodeDynamic<T>::pcGetChild(int iChildOffset) {
    if (iChildOffset < 0 || iChildOffset >= iGetChildrenNumber()) {
        return NULL;
    }

    return v_children.at(iChildOffset);
}

template<typename T>
void CNodeDynamic<T>::vPrintAllBelow() {
    vPrint();

    for (int i = 0; i < iGetChildrenNumber(); i++)
        v_children.at(i)->vPrintAllBelow();
}

template<typename T>
void CNodeDynamic<T>::vPrintUp() {
    vPrint();
    if (pc_parent_node != NULL)
       pc_parent_node->vPrintUp();
}

template<typename T>
CNodeDynamic<T> *CNodeDynamic<T>::getAbsoluteRoot() {
    if (pc_parent_node == NULL) return this;
    pc_parent_node->getAbsoluteRoot();
}

template<typename T>
void CNodeDynamic<T>::changeParent(CNodeDynamic<T> *newParent) {
    vector<CNodeDynamic<T>*> siblings = pc_parent_node->v_children;
    vector<CNodeDynamic<T>*> new_siblings;
    for (int i = 0; i < siblings.size(); i++) {
        if (siblings.at(i) != this) {
            new_siblings.push_back(siblings.at(i));
        }
    }

    pc_parent_node->v_children = new_siblings;

    pc_parent_node = newParent;
}
