public class Main {
    public static void main(String[] args) {
        Queue<Integer> q = new Queue<>(3);

        try {
            q.enqueue(1);
            q.enqueue(2);
            q.enqueue(3);
//            q.enqueue(3);
            q.dequeue();
            q.dequeue();
            q.dequeue();
            System.out.println(q.first());
            q.first();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
