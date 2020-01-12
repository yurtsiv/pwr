import java.util.concurrent.Semaphore;

class CountSemaphore extends Thread {
    private static IntCell n = new IntCell();
    private Semaphore sem;

    public CountSemaphore(Semaphore sem) {
        this.sem = sem;
    }

    @Override
    public void run() {
        int temp;
        for (int i = 0; i < 200000; i++) {
            try {
                sem.acquire();
                temp = n.getN();
                n.setN(temp + 1);
                sem.release();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    // should be "public static void main(String[] args)" in task
    public static void test() {
        Semaphore sem = new Semaphore(1);
        CountSemaphore p = new CountSemaphore(sem);
        CountSemaphore q = new CountSemaphore(sem);

        long before = System.currentTimeMillis(); // Not included in the task

        p.start();
        q.start();
        try { p.join(); q.join(); }
        catch (InterruptedException e) { }

        System.out.println("The value of n is " + n.getN());

        // Not included in the task
        long after = System.currentTimeMillis();
        System.out.println("Time: " + (after - before));
    }
}

