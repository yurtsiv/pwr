import java.util.ArrayList;
import java.util.Random;

public class Player extends Thread {
    private ArrayList<Player> players;
    private int waitingTIme = 0, num;
    private volatile int ballNum = -1;

    public Player(ArrayList<Player> players, int num) {
        this.num = num;
        this.players = players;
        players.add(this);
    }

    public void receiveBall(int ballNum) {
        this.ballNum = ballNum;
    }

    private static int getRandomInt(int min, int max) {
        Random r = new Random();
        return r.nextInt(max);
    }

    public int getWaitingTime() {
        return waitingTIme;
    }

    public int getNum() {
        return num;
    }

    private Player getRandomPlayer() {
        return players.get(getRandomInt(0, players.size()));
    }

    private void sleep(int time) {
        waitingTIme = time;
        try {
            Thread.sleep(time);
            waitingTIme = 0;
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
        Player otherPlayer = getRandomPlayer();
        while(otherPlayer == this) {
            otherPlayer = getRandomPlayer();
        }


        System.out.println("Player " + num + " tries to give the ball " + ballNum + " to the player " + otherPlayer.getNum());

        while(otherPlayer.getWaitingTime() > 0) {
            int time = otherPlayer.getWaitingTime();
            System.out.println("Player " + otherPlayer.getNum() + " is busy. Player " + num + " is waiting for " + time);
            sleep(time);
        }

        System.out.println("Player " + num + " gives the ball " + ballNum + " to the player " + otherPlayer.getNum());

        otherPlayer.receiveBall(ballNum);
        ballNum = -1;
    }


    public void run() {
        while(true) {
            if (ballNum != -1) {
                System.out.println("Player " + num + " has received ball " + ballNum);
                sleepRandomTime();
                passBallToRandomPlayer();
            }
        }

    }

}
