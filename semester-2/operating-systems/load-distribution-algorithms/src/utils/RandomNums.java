package utils;

import java.util.Random;

public class RandomNums {
    private static Random rand = new Random();
    public static int getInt(int min, int max) {
        if (min > max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        return rand.nextInt((max - min) + 1) + min;
    }
}
