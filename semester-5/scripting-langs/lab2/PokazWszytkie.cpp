#include <iostream>

using namespace std;

int main(int argc, char* argv[], char* envp[]) {
    cout << "\nARGUMENTS: \n" << endl;

    for (int i = 0; i < argc; i++) {
        cout << argv[i] << endl;
    }

    cout << "\nENV VARS: \n" << endl;

    for (int i = 0; envp[i] != 0; i++) {
        cout << envp[i] << endl;
    }
}