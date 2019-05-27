package utils;

import java.util.ArrayList;
import java.util.Random;

public class RandomNums {
    private static Random rand = new Random();

    public static int randomInt(int min, int max) {
        if (min > max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        return rand.nextInt((max - min) + 1) + min;
    }

    public static ArrayList<Integer> getSequnce(int seqLen, int minNum, int maxNum) {
        ArrayList<Integer> result = new ArrayList<>();

        int localityRegions = maxNum;
        int numsPerRegion = seqLen / localityRegions;
        for (int region = 0; region < localityRegions; region++) {
            for (int i = 0; i < numsPerRegion; i++) {
                int from = Math.min(minNum + region, minNum + (maxNum - minNum) / 2);
                int to = Math.min(minNum + numsPerRegion + region, maxNum);
                int num = randomInt(from ,to);
                result.add(num);
            }
        }

        return result;
    }
}
