package simulation;

public class Process {
    private int load, remainingTime;

    public Process(int load, int remainingTime) {
        this.load = load;
        this.remainingTime = remainingTime;
    }

    public int getLoad() {
        return load;
    }

    public int getRemainingTime() {
        return remainingTime;
    }

    public void decrementRemainingTime() {
        remainingTime--;
    }

    public Process clone() {
        return new Process(load, remainingTime);
    }
}
