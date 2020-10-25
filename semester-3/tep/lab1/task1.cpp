#include <iostream>
using namespace std;

void v_alloc_table(int iSize, int jSize) {
    if (iSize < 0) {
        return;
    }

    char** pi_table;
    pi_table = new char*[iSize];

    for (int i = 0; i < iSize; i++) {
        pi_table[i] = new char[jSize];

        cout << "" << endl;
        for (int j = 0; j < jSize; j++) {
            pi_table[i][j] = 'a';
            cout << pi_table[i][j] << " ";
        }
    }
    

    for (int i = 0; i < iSize; i++) {
        delete pi_table[i];
    }

    delete pi_table;
    cout << pi_table << endl;
}

int main() {
    cout << "Alloc table:" << endl;
    v_alloc_table(4, 3);
    return 0;
}

// 2 dim type char