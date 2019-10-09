#include <iostream>
using namespace std;

int main() {
    cout << "Alloc table add 5:" << endl;
    v_alloc_table_add_5(4);
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


    for (int i = 0; i < iSize; i++) {
        cout << pi_table[i] << endl;
    }

    delete pi_table;
}
