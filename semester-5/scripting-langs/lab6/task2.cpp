#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <fstream>
#include <chrono>

using namespace std;

int main(int argc, char* argv[]) {
  ifstream covid_file("Covid.txt");

  if (covid_file.is_open()) {
    string row_str;
    int cases = 0;

    while(getline(covid_file, row_str)) {
      vector<string> row;
      stringstream row_ss(row_str);
      for (string column; getline(row_ss, column, '\t');) {
        row.push_back(column);
      }

      try {
        cases += stoi(row[4]);
      } catch (invalid_argument a) {
        // noop
      }
    }

    cout << cases << endl;
  } else {
    cout << "No Covid.txt file" << endl;
  }

  return 0;
}