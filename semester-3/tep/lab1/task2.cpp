#include <iostream>
using namespace std;

bool b_alloc_table_2_dim(int ***piTable, int iSizeX, int iSizeY) {
    if (iSizeX < 0 || iSizeY < 0) {
        return false;
    }

    int **tablePointer = new int*[iSizeX];
    for (int i = 0; i < iSizeX; i++) {
        tablePointer[i] = new int[iSizeY];
    }

    tablePointer[0][0] = 100;

    *piTable = tablePointer;
    return true;
}

int main() {
    int **piTable;
    b_alloc_table_2_dim(&piTable, 5, 3);
    cout << "Table[0][0] (should be 100):" << piTable[0][0];
}