import java.util.ArrayList;

public class Main {
    static int playersNum = 3;
    static int ballsNum = 2;


    private static void testUnSynchronized() {
        ArrayList<PlayerUnsync> players = new ArrayList<>();

        for (int i = 0; i < playersNum; i++) {
            PlayerUnsync p = new PlayerUnsync(players, i, i < ballsNum ? i : -1);
        }

        for (PlayerUnsync p : players)  {
            p.start();
        }
    }

    private static void testMonitors() {
        ArrayList<PlayerMonitor> players = new ArrayList<>();

        for (int i = 0; i < playersNum; i++) {
            PlayerMonitor p = new PlayerMonitor(players, i, i < ballsNum ? i : -1);
        }

        for (PlayerMonitor p : players)  {
            p.start();
        }
    }

    private static void testSemaphores() {
        ArrayList<PlayerSemaphore> players = new ArrayList<>();

        for (int i = 0; i < playersNum; i++) {
            PlayerSemaphore p = new PlayerSemaphore(players, i, i < ballsNum ? i : -1);
        }

        for (PlayerSemaphore p : players)  {
            p.start();
        }
    }

    public static void main(String[] args) {
//        testUnSynchronized();
        testMonitors();
//        testSemaphores();
    }
}
