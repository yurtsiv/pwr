package utils;

import java.util.ArrayList;
import java.util.Random;

public class RandomNums {
    public static int randomInt(int min, int max) {
        if (min > max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        Random rand = new Random();
        return rand.nextInt((max - min) + 1) + min;
    }

    public static ArrayList<Integer> getSequnce(int seqLen, int min, int max) {
        ArrayList<Integer> result = new ArrayList<>();

        int localityRegions = max;
        int numsPerRegion = seqLen / localityRegions;
        for (int region = 0; region < localityRegions; region++) {
            for (int i = 0; i < numsPerRegion; i++) {
                int from = Math.min(min + region, max / 2);
                int to = Math.min(numsPerRegion + region, max);
                int num = randomInt(from ,to);
                System.out.println(num);
                result.add(num);
            }
        }

        return result;
    }
}
