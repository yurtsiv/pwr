#include <iostream>
#include <string>
#include <regex>

int endProgramm(int code, bool silent) {
    if (!silent) {
        std::cout << code << std::endl;
    }

    return code;
}

int main(int argc, char* argv[]) {
    if (argc == 1) {
        return endProgramm(11, false);
    }

    std::string firstArg(argv[1]);
    bool silent = firstArg == "/s" || firstArg == "/S";
    int argsNum = silent ? argc - 1 : argc;

    if (argsNum == 1) {
        return endProgramm(11, silent);
    }

    if (argsNum > 2) {
        return endProgramm(13, silent);
    }

    char* arg = silent ? argv[2] : argv[1];

    bool isDigit = std::regex_match(arg, std::regex("[0-9]"));
    if (!isDigit) {
        return endProgramm(12, silent);
    }

    return endProgramm(std::stoi(arg), silent);
}