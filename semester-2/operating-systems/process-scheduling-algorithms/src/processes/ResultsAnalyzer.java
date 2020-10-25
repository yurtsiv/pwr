package processes;

import java.util.ArrayList;

public class ResultsAnalyzer {
    public static int averageArithmetic(ArrayList<Integer> nums) {
        int totalTime = 0;
        for (Integer num : nums) {
            totalTime += num;
        }

        return totalTime / nums.size();
    }
    public static int averageWaitingTime(ArrayList<Process> processes) {
        int totalTime = 0;
        for (Process proc : processes) {
            totalTime += proc.getWaitingTime();
        }

        return totalTime / processes.size();
    }
}
