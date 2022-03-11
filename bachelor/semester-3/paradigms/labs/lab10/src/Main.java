import java.util.ArrayList;

public class Main {
    private static void causeArrayStoreException(Object[] arr) {
        arr[0] = "Surprise";
    }

    public static void main(String[] args) {
        Programmer programmer = new Programmer("John", 25, "IBM", "middle");

        Employee employee = new Employee("John", 25, "IBM", "PM");

        Person person  = new Person("John", 25);

        Person[] personArr = new Person[] {person};
        Employee[] employeeArr = new Employee[] {employee};
        Programmer[] programmerArr = new Programmer[] {programmer};
        String[] stringArr = new String[] {"hello"};

//        Contravariance
//        employeeArr = personArr;
//        Covariance
        employeeArr = programmerArr;
//        Inavariance
//        employeeArr = stringArr;
//        causeArrayStoreException(personArr);

        ArrayList<Person> personList = new ArrayList<>();
        personList.add(person);
        Print.print(personList);

        ArrayList<Employee> employeeList = new ArrayList<>();
        employeeList.add(employee);
        Print.print(employeeList);

        ArrayList<Employee> programmerList = new ArrayList<>();
        programmerList.add(programmer);
        Print.print(programmerList);

//        Print.print("String");
    }
}
