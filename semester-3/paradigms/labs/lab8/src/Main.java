public class Main {
    private static void testIntBst() {
        System.out.println("BST of ints: ");
        BST<Integer> intBst = new BST<>((val1, val2) -> {
            if (val1 == val2) {
                return 0;
            } else if (val1 < val2) {
                return -1;
            }

            return 1;
        });

        System.out.println(intBst);

        try {
            intBst.insert(8);

            intBst.insert(6);
            intBst.insert(3);
            intBst.insert(1);
            intBst.insert(7);
            intBst.insert(4);

            intBst.insert(14);
            intBst.insert(10);
            intBst.insert(13);

            System.out.println("Contains 8: " + intBst.contains(8));
            System.out.println("Contains 4: " + intBst.contains(4));
            System.out.println("Contains 14: " + intBst.contains(14));
            System.out.println("Contains 100: " + intBst.contains(100));

            System.out.println("Resulting tree: ");
            System.out.println(intBst);

            intBst.insert(7);
        } catch (TreeInsertionException e) {
            System.out.println(e);
        }
    }

    private static void testStrBst() {
        System.out.println("BST of strings: ");
        BST<String> strBst = new BST<>((val1, val2) -> {
            if (val1 == null && val2 == null) return 0;
            if (val1 == null) return -1;
            if (val2 == null) return 1;

            return val1.compareTo(val2);
        });

        System.out.println(strBst);

        try {
            strBst.insert("F");

            strBst.insert("D");
            strBst.insert("B");
            strBst.insert("A");
            strBst.insert("C");

            strBst.insert("M");
            strBst.insert("Q");
            strBst.insert("L");

            System.out.println("Contains F: " + strBst.contains("F"));
            System.out.println("Contains C: " + strBst.contains("C"));
            System.out.println("Contains M: " + strBst.contains("M"));
            System.out.println("Contains Z: " + strBst.contains("Z"));

            System.out.println("Resulting tree: ");
            System.out.println(strBst);

            strBst.insert("C");
        } catch (TreeInsertionException e) {
            System.out.println(e);
        }
    }

    public static void main(String[] args) {
        testIntBst();
        System.out.println();
        testStrBst();
    }
}
