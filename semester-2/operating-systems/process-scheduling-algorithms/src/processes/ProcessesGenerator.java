package processes;

import java.util.ArrayList;
import java.util.Random;

public class ProcessesGenerator {
    private static int randomInt(int min, int max) {
        if (min >= max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        Random rand = new Random();
        return rand.nextInt((max - min) + 1) + min;
    }

    public static ArrayList<Process> getSeries(int seriesLenght, int maxRunningTime, int maxStartTime) {
        ArrayList<Process> res = new ArrayList<>();

        int zeroWaitingTimeProcs = ProcessesGenerator.randomInt(0, seriesLenght / 3);
        for (int i = 0; i < seriesLenght; i++) {
            int runningTime = ProcessesGenerator.randomInt(1, maxRunningTime);
            int startTime = i <= zeroWaitingTimeProcs ? 0 : ProcessesGenerator.randomInt(0, maxStartTime);
            res.add(new Process(i, runningTime, startTime));
        }

        return res;
    }
}
