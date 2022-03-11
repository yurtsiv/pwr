#include <iostream>
#include <string>

using namespace std;

int main(int argc, char* argv[]) {
    double sum = 0;

    string rowStr;
    while(getline(cin, rowStr)) {
        for (int i = 1; i < argc; i++) {
            if (rowStr.find(argv[i]) != string::npos) {
                cout << rowStr << endl;
                break;
            }
        }
    }

    return 0;
}