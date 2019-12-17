#include "MSCNProblem.h"

void simpleTest() {
  cout << "--- SIMPLE TEST ---\n" << endl;
  MSCNProblem c_problem_object;
	c_problem_object.bRead("test_1.txt");

	double* d_sample_solution = new double[7]{1,1,1,1,1,1,1};

  cout << "\nSolution: ";
  for (int i = 0; i < 7; i++)
    cout << d_sample_solution[i] << " ";
  
  cout << "" << endl;

	bool isSuccess;
	cout << endl << "Is solution correct: " << c_problem_object.bConstraintsSatisfied(d_sample_solution) << endl;
	cout << "\nProfit: " << c_problem_object.dGetQuality(d_sample_solution, isSuccess) << endl;
	cout << endl << "Min at index 1: " << c_problem_object.dGetMin(d_sample_solution, 1) << endl;
	cout << endl << "Max at index 1: " << c_problem_object.dGetMax(d_sample_solution, 1) << endl;
}

// void testIncorrectSolution() {
//   cout << "\n\n--- INCORRECT SOLUTION TEST ---\n" << endl;
//   MSCNProblem c_problem_object;
// 	c_problem_object.bRead("test_1.txt");

//   double* d_sample_solution;
// 	d_sample_solution = new double[7]{1,2,3,4,-1,-2,3};
//   cout << "\nSolution: ";
//   for (int i = 0; i < 7; i++)
//     cout << d_sample_solution[i] << " ";

// 	cout << endl << "\nIs solution correct (negative nums): " << c_problem_object.bConstraintsSatisfied(d_sample_solution) << endl;
// }

int main() {
  simpleTest();
  // testIncorrectSolution();

	return 0;
}