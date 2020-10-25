class CountMonitor extends Thread {
    private static IntCell n = new IntCell();

    @Override
    public void run() {
        int temp;
        for (int i = 0; i < 200000; i++) {
            synchronized (n) {
                temp = n.getN();
                n.setN(temp + 1);
            }
        }
    }

    // should be "public static void main(String[] args)" in the task
    public static void test() {
        CountMonitor p = new CountMonitor();
        CountMonitor q = new CountMonitor();

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

