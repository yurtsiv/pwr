#include <iostream>
#include "CMySmartPointer.h"

using namespace std;

int main() {
    {
        string* str1 = new string("String 1");
        string* str2 = new string("String 2");
        cout << "Initializing smart pointer for dynamically allocated string" << endl;
        CMySmartPointer<string> strPointer1(str1);
        CMySmartPointer<string> strPointer2(str2);
    }

    {
        string str("Hello there");
        CMySmartPointer<string> strPointer(&str);
    }

}
