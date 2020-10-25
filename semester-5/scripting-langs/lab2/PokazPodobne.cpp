#include <iostream>
#include <string>
#include <regex>

using namespace std;

void printVar(string name, string value) {
    auto start = 0;
    auto end = value.find(";");

    if (end == string::npos) {
        cout << name << "=" << value << endl;
        return;
    }

    while (end != string::npos)
    {
        cout << name << "=" << value.substr(start, end - start) << endl;
        start = end + 1;
        end = value.find(";", start);
    }
}

int main(int argc, char* argv[], char* envp[]) {
    if (argc == 1) {
        return 0;
    }

    std::string firstArg(argv[1]);
    bool silent = firstArg == "/s" || firstArg == "/S";
    int searchTermsStart = silent ? 2 : 1;

    for (int i = searchTermsStart; i < argc; i++) {
        bool match = false;

        for (int j = 0; envp[j] != 0; j++) {
            string var_str(envp[j]);
            int nameEndIndex = var_str.find("=");
            string name = var_str.substr(0, nameEndIndex);

            if (name.find(argv[i]) != string::npos) {
                string value = var_str.substr(nameEndIndex);
                printVar(name, value); 
                match = true;
            }

        }

        if (!match && !silent) {
            cout << argv[i] << "=" << "NONE" << endl;
        }
    }

    return 0;
}