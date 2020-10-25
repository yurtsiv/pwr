#include <iostream>
#include <string>

using namespace std;

int main() {
    double sum = 0;

    string rowStr;
    while(getline(cin, rowStr)) {
        try {
            sum += stod(rowStr);
        } catch (invalid_argument a) {
            // noop
        }
    }

    cout << sum << endl;
}
