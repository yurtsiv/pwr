#include <iostream>
#include <string>
#include <iomanip>

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

    cout << fixed << setprecision(0) << sum << endl;

    return 0;
}
