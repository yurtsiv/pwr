class Main {
  public static <T> T[] repeat(T[] array, int[] repeats) {
    if (array.length == 0 || repeats.length == 0) {
      return (T[])new Object[0];
    }

    int res_len = 0;
    int smaller_arr_len = Math.min(array.length, repeats.length);
    for (int i = 0; i < smaller_arr_len; i++) {
      res_len += repeats[i];
    }

    T[] res = (T[])new Object[res_len];
    int res_i = 0;
    for (int i = 0; i < smaller_arr_len; i++) {
      int times = repeats[i];
      for (int j = 0; j < times; j++) {
        res[res_i++] = array[i];
      }
    }

    return res;
  }

  static <T> void printArr (T[] arr) {
    if (arr.length == 0) {
      System.out.println("Empty arr");
      return;
    }

    for (int i = 0; i < arr.length; i++) {
      System.out.print(" | " + arr[i]);
    }

    System.out.println();
  }

  public static void main(String[] args) {
    String[] array1 = new String[]{"a","b","c"};
    int[] repeats1 = {2,1,0,3};
    Object[] res1 = Main.<String>repeat(array1, repeats1);
    printArr(res1);

    String[] array2 = new String[]{"a","b","c"};
    int[] repeats2 = {2};
    Object[] res2 = Main.<String>repeat(array2, repeats2);
    printArr(res2);

    String[] array3 = new String[]{"a","b","c"};
    int[] repeats3 = {};
    Object[] res3 = Main.<String>repeat(array3, repeats3);
    printArr(res3);

    String[] array4 = new String[]{};
    int[] repeats4 = {2,1,0,3};
    Object[] res4 = Main.<String>repeat(array4, repeats4);
    printArr(res4);
  }
}