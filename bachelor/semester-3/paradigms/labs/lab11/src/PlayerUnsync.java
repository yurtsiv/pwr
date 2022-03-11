import java.util.ArrayList;
import java.util.Random;

public class PlayerUnsync extends Thread {
    private static Random random = new Random();
    private ArrayList<PlayerUnsync> players;
    private int waitingTime = 0, num;
    private volatile int ballNum = -1;

    public PlayerUnsync(ArrayList<PlayerUnsync> players, int num, int ballNum) {
        this.num = num;
        this.players = players;
        this.ballNum = ballNum;
        players.add(this);
    }

    public void receiveBall(int ballNum) {
        this.ballNum = ballNum;
    }

    private static int getRandomInt(int min, int max) {
        return random.nextInt(max - min) + min;
    }

    public int getWaitingTime() {
        return waitingTime;
    }

    public int getNum() {
        return num;
    }

    private PlayerUnsync getRandomPlayer() {
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
        int time = getRandomInt(500, 2000);
        System.out.println("Player " + num + " sleeps for " + time);
        sleep(time);
    }

    private void passBallToRandomPlayer() {
        PlayerUnsync otherPlayer = getRandomPlayer();
        while(otherPlayer == this) {
            otherPlayer = getRandomPlayer();
        }

        System.out.println("Player " + num + " gives the ball " + ballNum + " to the player " + otherPlayer.getNum());
        while(otherPlayer.getWaitingTime() > 0) {
            int time = otherPlayer.getWaitingTime();
            System.out.println("Player " + otherPlayer.getNum() + " is busy. Player " + num + " is waiting for " + time);
            sleep(time);
        }


        otherPlayer.receiveBall(ballNum);
        ballNum = -1;
    }


    public void run() {
        while(true) {
            if (ballNum != -1) {
                System.out.println("Player " + num + " has received the ball " + ballNum);
                sleepRandomTime();
                passBallToRandomPlayer();
            }
        }

    }

}
