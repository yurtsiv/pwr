#include <iostream>
#include <string>
#include <regex>

int main(int argc, char* argv[], char* envp[]) {
    std::string res;

    for (int i = 0; envp[i] != 0; i++) {
        std::string envVar(envp[i]);
        int nameEndIndex = envVar.find("=");
        std::string name = envVar.substr(0, nameEndIndex);
        std::string value = envVar.substr(nameEndIndex + 1);

        if (std::regex_match(name, std::regex("[a-z][0-9]"))) {
            res += value;
        }
    }

    std::cout << res << std::endl;
}