import java.util.Comparator;


public class BST<T> implements ITree<T> {
    private class Node {
        T value;
        Node left;
        Node right;

        public Node(T value, Node left, Node right) {
            this.value = value;
            this.left = left;
            this.right = right;
        }

        @Override
        public String toString() {
            String leftStr = left == null ? "Empty" : left.toString();
            String rightStr = right == null ? "Empty" : right.toString();
            return "Node(" + value + ", " + leftStr + ", " + rightStr + ")";
        }
    }

    private Comparator<T> cmp;
    private Node root;

    public BST(Comparator<T> cmp) {
        this.cmp = cmp;
    }

    public void insert(T element) throws TreeInsertionException {
        Node currentNode = this.root;

        if (currentNode ==  null) {
            this.root = new Node(element, null, null);
            return;
        }

        boolean inserted = false;
        while(!inserted) {
            int cmpWithCurr = cmp.compare(element, currentNode.value);

            if (cmpWithCurr == 0) throw new TreeInsertionException("Element " + element + " already exist");

            if (cmpWithCurr < 0) {
                if (currentNode.left == null) {
                   currentNode.left = new Node(element, null, null);
                   inserted = true;
                } else {
                   currentNode = currentNode.left;
                }

            } else {
                if (currentNode.right == null) {
                    currentNode.right = new Node(element, null, null);
                    inserted = true;
                } else {
                    currentNode = currentNode.right;
                }
            }
        }
    }

    public boolean contains(T element) {
        Node currentNode = this.root;
        while(currentNode != null) {
            int cmpRes = cmp.compare(element, currentNode.value);
            if(cmpRes == 0) {
                return true;
            }

            currentNode = cmpRes < 0 ? currentNode.left : currentNode.right;
        }

        return false;
    }

    @Override
    public String toString() {
        if (this.root == null) {
            return "Empty";
        }

        return this.root.toString();
    }
}
