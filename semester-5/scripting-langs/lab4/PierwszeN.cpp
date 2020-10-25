#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <regex>

using namespace std;

int main(int argc, char* argv[]) {
    int n = stoi(argv[1]);

    string line;
    while(getline(cin, line) && n > 0) {
        cout << line << endl;
        n--;
    }

    return 0;
}