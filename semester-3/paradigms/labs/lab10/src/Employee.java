public class Employee extends Person {
    private String company, position;

    public Employee(String name, int age, String company, String position) {
        super(name, age);
        this.company = company;
        this.position = position;
    }

    public void print() {
        super.print();
        System.out.print(". Works at " + company + " as a " + position);
    }
}
