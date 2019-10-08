#include <iostream>
using namespace std;

void v_alloc_table_add_5(int iSize);
bool b_alloc_table_2_dim(int ***piTable, int iSizeX, int iSizeY);
bool b_dealloc_table_2_dim(int **piTable, int iSizeX, int iSizeY);

int main() {
    v_alloc_table_add_5(4);

    int **piTable;
    b_alloc_table_2_dim(&piTable, 5, 3);
    b_dealloc_table_2_dim(piTable, 5, 3);

    return 0;
}

void v_alloc_table_add_5(int iSize) {
    if (iSize < 0) {
        return;
    }

    int *pi_table;
    pi_table = new int[iSize];

    for (int i = 0; i < iSize; i++) {
        pi_table[i] = i + 5;
    }


    cout << "Alloc table add 5:" << endl;
    for (int i = 0; i < iSize; i++) {
        cout << pi_table[i] << endl;
    }

    delete pi_table;
}

bool b_alloc_table_2_dim(int ***piTable, int iSizeX, int iSizeY) {
    if (iSizeX < 0 || iSizeY < 0) {
        return false;
    }

    int **tablePointer = new int*[iSizeX];
    for (int i = 0; i < iSizeX; i++) {
        tablePointer[i] = new int[iSizeY];
    }

    *piTable = tablePointer;
    return true;
}

bool b_dealloc_table_2_dim(int **piTable, int iSizeX, int iSizeY) {
    if (iSizeX < 0 || iSizeY < 0) {
        return false;
    }

    for (int i = 0; i < iSizeX; i++) {
        delete piTable[i];
    }

    delete piTable;

    return true;
}