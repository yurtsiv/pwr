#include <iostream>
#include <string>
#include <regex>

using namespace std;

int main(int argc, char* argv[]) {
    bool splitBySentence = argc == 2 && string(argv[1]) == "/Z";
    string entireText;
    string line;

    while(getline(cin, line)) {
        entireText += line + '\n';
    }

    regex re(splitBySentence ? "[\.|\?|\!][\\n\\t\\s]*" : "[^a-zA-Z]");
    sregex_token_iterator it(entireText.begin(), entireText.end(), re, -1 );
    sregex_token_iterator reg_end;

    for(; it != reg_end; ++it) {
        string str = it->str();
        str.erase(std::remove(str.begin(), str.end(), '\n'), str.end());

        if (!str.empty()) {
            cout << str << endl;
        }
    }

    return 0;
}