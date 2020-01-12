import java.util.ArrayList;
import java.util.Random;

public class PlayerMonitor extends Thread {
    private ArrayList<PlayerMonitor> players;
    private int waitingTime = 0, num;
    private volatile int ballNum = -1;

    public PlayerMonitor(ArrayList<PlayerMonitor> players, int num, int ballNum) {
        this.num = num;
        this.players = players;
        this.ballNum = ballNum;

        players.add(this);
    }

    public synchronized void giveBall(int ballNum) {
        this.ballNum = ballNum;
    }

    private static int getRandomInt(int min, int max) {
        Random r = new Random();
        return r.nextInt(max - min) + min;
    }

    public int getWaitingTime() {
        return waitingTime;
    }

    public int getNum() {
        return num;
    }

    private PlayerMonitor getRandomPlayer() {
        return players.get(getRandomInt(0, players.size()));
    }

    private void sleep(int time) {
        waitingTime = time;
        try {
            Thread.sleep(time);
            waitingTime = 0;
        } catch (InterruptedException e) {
            System.err.println(e);
        }
    }

    private void sleepRandomTime() {
        int time = getRandomInt(500, 3000);
        System.out.println("Player " + num + " sleeps for " + time);
        sleep(time);
    }

    private void passBallToRandomPlayer() {
        PlayerMonitor otherPlayer = getRandomPlayer();
        while(otherPlayer == this) {
            otherPlayer = getRandomPlayer();
        }


        System.out.println("Player " + num + " gives the ball " + ballNum + " to the player " + otherPlayer.getNum());

        while(otherPlayer.getWaitingTime() > 0) {
            int time = otherPlayer.getWaitingTime();
            System.out.println("Player " + otherPlayer.getNum() + " is busy. Player " + num + " is waiting for " + time);
            sleep(time);
        }

        otherPlayer.giveBall(ballNum);
        ballNum = -1;
    }


    public void run() {
        while(true) {
            if (ballNum != -1) {
                System.out.println("Player " + num + " has received the  ball " + ballNum);
                sleepRandomTime();
                passBallToRandomPlayer();
            }
        }

    }
}
