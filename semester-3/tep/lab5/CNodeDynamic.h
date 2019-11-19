#include <iostream>
#include <vector>

using namespace std;

class CNodeDynamic {
    public:
        CNodeDynamic(): i_val(0), pc_parent_node(NULL) {}
        ~CNodeDynamic();

        void vSetValue(int iNewVal) { i_val = iNewVal; }

        int iGetChildrenNumber() { return v_children.size(); }
        void vAddNewChild(int iChildVal);
        void vAddNewChild(CNodeDynamic *child);
        CNodeDynamic* pcGetChild(int iChildOffset);
        void changeParent(CNodeDynamic* newParent);
        CNodeDynamic* getAbsoluteRoot();

        void vPrint() { cout << " " << i_val; };
        void vPrintAllBelow();
        void vPrintUp();

    private:
        vector<CNodeDynamic*> v_children;
        CNodeDynamic *pc_parent_node;
        int i_val;
};

