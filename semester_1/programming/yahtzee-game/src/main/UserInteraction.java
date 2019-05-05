package main;

import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;

public class UserInteraction {
    public static int[] getIntArray (String question) {
        System.out.println(question);
        Scanner userInput = new Scanner(System.in);
        List<Integer> list = new ArrayList<>();

        while (userInput.hasNextInt()) {
            list.add(userInput.nextInt());
        }

        return list.stream().mapToInt(i -> i).toArray();
    }

    public static String selectOption (String label, List<String> options) {
        System.out.println(label + "\n");

        for (int i = 0; i < options.size(); i++) {
            System.out.println((i + 1) + ". " + options.get(i));
        }

        int selectedIndex = UserInteraction.getInt("", 1, options.size());

        return options.get(selectedIndex -1);
    }

    public static boolean yesNoQuestion (String question) {
        System.out.println(question + " (yes/no)");
        return new Scanner(System.in).hasNext("yes");
    }

    public static int getInt (String question, int lowerBound, int upperBound) {
        int result = -1;
        Scanner scan = new Scanner(System.in);

        while (result < lowerBound || result > upperBound) {
            System.out.println(question);
            try {
                result = scan.nextInt();
            } catch (InputMismatchException e) {
                System.out.println("Please, enter a number");
                scan.nextLine();
            }
        }

        return result;
    }

    public static String question (String question) {
        System.out.println(question);
        return new Scanner(System.in).next();
    }

    public static void printSeparator () {
        System.out.println("---------------------------------------------------------\n");
    }
}
