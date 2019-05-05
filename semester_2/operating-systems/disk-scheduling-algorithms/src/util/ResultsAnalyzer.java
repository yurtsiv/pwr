package util;

import java.util.ArrayList;

public class ResultsAnalyzer {
    private static int calcTotalHeadMovement(ArrayList<Integer> headPath) {
        int result = 0;
        for (int i = 0; i < headPath.size() - 1; i++) {
            result += Math.abs(headPath.get(i) - headPath.get(i+1));
        }

        return result;
    }

    public static void analyzeAndPrint(ArrayList<Integer> headPath) {
       System.out.println("Head path:");
       for (int position : headPath) {
           System.out.print(position + " | ");
       }

       System.out.println("\nTotal head movement: " + calcTotalHeadMovement(headPath));
    }
}
