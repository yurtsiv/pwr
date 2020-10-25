#include <iostream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

int main(int argc, char* argv[]) {
    string rowStr;
    while(getline(cin, rowStr)) {
        vector<string> row;
        stringstream rowSS(rowStr);
        for (string column; getline(rowSS, column, '\t');) {
            row.push_back(column);
        }

        for (int i = 1; i < argc; i++) {
            int columnNum = stoi(argv[i]);
            cout << row[columnNum - 1];

            // Print tab if not last column 
            if (i < argc - 1)
                cout << '\t';
        }

        cout << endl;
    }

    return 0;
}