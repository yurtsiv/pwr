import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;

public class UserInteraction {
    public static int selectOption (String label, List<String> options) {
        System.out.println(label + "\n");

        for (int i = 0; i < options.size(); i++) {
            System.out.println((i + 1) + ". " + options.get(i));
        }

        int selectedIndex = UserInteraction.getInt("", 1, options.size());

        return selectedIndex -1;
    }

    public static int getInt (String question, int lowerBound, int upperBound) {
        Integer result = null;
        Scanner scan = new Scanner(System.in);

        while (result == null || result < lowerBound || result > upperBound) {
            System.out.println(question);
            try {
                result = scan.nextInt();
            } catch (InputMismatchException e) {
                System.out.println("Invalid input");
                scan.nextLine();
            }
        }

        return result;
    }

    public static String getStr (String question) {
        Scanner scan = new Scanner(System.in);
        System.out.println(question);
        return scan.nextLine();
    }
}
