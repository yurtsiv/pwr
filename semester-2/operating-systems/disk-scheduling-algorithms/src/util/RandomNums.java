package util;

import java.util.Random;

public class RandomNums {
    public static int randomInt(int min, int max) {
        if (min > max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        Random rand = new Random();
        return rand.nextInt((max - min) + 1) + min;
    }

}
