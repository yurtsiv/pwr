#include <iostream>
using namespace std;

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

int main() {
    int tableSizeX = 4;
    int tableSizeY = 5;
    int **piTable;
    piTable = new int*[tableSizeX];

    for (int i = 0; i < tableSizeX; i++) {
        piTable[i] = new int[tableSizeY];
    }

    b_dealloc_table_2_dim(piTable, tableSizeX, tableSizeY);

    return 0;
}
