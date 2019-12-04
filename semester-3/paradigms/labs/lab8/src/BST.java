import java.util.Comparator;


public class BST<T> implements ITree<T> {
    private class Node<T> {
        T value;
        Node<T> left;
        Node<T> right;

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
    private Node<T> root;

    public BST(Comparator<T> cmp) {
        this.cmp = cmp;
    }

    public void insert(T element) throws TreeInsertionException {
        Node<T> currentNode = this.root;

        if (currentNode ==  null) {
            this.root = new Node(element, null, null);
            return;
        }

        while(true) {
            int cmpWithCurr = cmp.compare(element, currentNode.value);

            if (cmpWithCurr == 0) throw new TreeInsertionException("Element " + element + " already exist");

            if (cmpWithCurr == -1) {
                if (currentNode.left == null) {
                   currentNode.left = new Node(element, null, null);
                   return;
                }

                currentNode = currentNode.left;
            } else {
                if (currentNode.right == null) {
                    currentNode.right = new Node(element, null, null);
                    return;
                }

                currentNode = currentNode.right;
            }
        }
    }

    public boolean contains(T element) {
        Node<T> currentNode = this.root;
        while(currentNode != null) {
            int cmpRes = cmp.compare(element, currentNode.value);
            if(cmpRes == 0) {
                return true;
            }

            currentNode = cmpRes == -1 ? currentNode.left : currentNode.right;
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
