public class Programmer extends Employee {
    private String level;

    public Programmer(String name, int age, String company, String level) {
       super(name, age, company, "programmer");
       this.level = level;
    }

    public void print() {
        super.toString();
        System.out.println(" (" + level + ")");
    }
}
