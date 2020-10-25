package main;

import java.util.ArrayList;

public class ArrayUtils {
    public static ArrayList<Integer> takeIndexes (int[] indexes, int[] array) {
        ArrayList<Integer> result = new ArrayList<>();
        for (int index : indexes) {
            result.add(array[index - 1]);
        }
        return result;
    }


    public static boolean areAllElemsEqual (int[] array) {
        int firstElem = array[0];
        for (int elem : array) {
            if (elem != firstElem) {
                return false;
            }
        }
        return true;
    }

    private static boolean contains (int[] arr, int elemToFind) {
        for (int item : arr) {
            if (item == elemToFind) {
                return true;
            }
        }

        return false;
    }

    public static boolean containsAll (int[] outerArr, int[] innerArr) {
        for (int innerItem : innerArr) {
            if (!ArrayUtils.contains(outerArr, innerItem)) {
                return false;
            }
        }

        return true;
    }
}
