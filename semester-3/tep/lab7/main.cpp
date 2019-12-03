#include <iostream>
#include <vector>
#include "CMySmartPointer.h"

using namespace std;

int main() {
    {
        string* str1 = new string("String 1");
        string* str2 = new string("String 2");
        string* str3 = new string("String 3");

        cout << "\n----------------------------------------------------------------" << endl;
        cout << "Initializing smart pointers for 3 dynamically allocated strings" << endl;
        cout << "----------------------------------------------------------------" << endl;
        CMySmartPointer<string> strPointer1(str1);
        CMySmartPointer<string> strPointer2(str2);
        CMySmartPointer<string> strPointer3(str3);

        cout << "\n\n-------------------------------" << endl;
        cout << "Copying the first smart pointer" << endl;
        cout << "-------------------------------" << endl;
        CMySmartPointer<string> strPointer1Copy(strPointer1);

        cout << "\n\n--------------------------------------" << endl;
        cout << "Assigning first smart pointer to third" << endl;
        cout << "--------------------------------------" << endl;
        strPointer3 = strPointer1;

        cout << "\n\n-------------------------------------------------------------------------" << endl;
        cout << "Assigning first smart pointer to another, which points to the same string" << endl;
        cout << "-------------------------------------------------------------------------" << endl;
        CMySmartPointer<string> strPointer4(str1);
        strPointer4 = strPointer1;

        cout << "\n\n------------" << endl;
        cout << "End of block" << endl;
        cout << "------------" << endl;
    }

    {
        int num = 1;
        cout << "\n\n\n---------------------------------------------------------" << endl;
        cout << "Initializing a smart pointer for statically allocated int" << endl;
        cout << "---------------------------------------------------------" << endl;

        CMySmartPointer<int> intPointer(&num);

        cout << "\n\n------------" << endl;
        cout << "End of block" << endl;
        cout << "------------" << endl;
    }
}
