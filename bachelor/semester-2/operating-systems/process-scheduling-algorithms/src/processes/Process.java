package processes;

public class Process implements Cloneable {
    private int id, estimatedRunningTime, startTime, runningProgress = 0, waitingTime = 0;
    private boolean isFinished = false, isRunning = false;

    public Process(int id, int estimatedRunningTime, int startTime) {
        this.id = id;
        this.estimatedRunningTime = estimatedRunningTime;
        this.startTime = startTime;
    }

    public void incrementProgress() {
        runningProgress++;
        if (runningProgress == estimatedRunningTime) {
            isFinished = true;
            isRunning = false;
        }
    }

    public int getId() {
        return id;
    }

    public int getWaitingTime() {
        return waitingTime;
    }

    public int getStartTime() {
        return startTime;
    }

    public void incrementWaitingTime() {
        waitingTime++;
    }

    public boolean getIsFinished() {
        return isFinished;
    }

    public boolean getIsRunning() {
        return isRunning;
    }

    public void setIsRunning(boolean isRunning) {
        this.isRunning = isRunning;
    }

    public int getEstimatedRunningTime() {
        return estimatedRunningTime;
    }

    public Process clone() throws CloneNotSupportedException {
        return (Process) super.clone();
    }

    public int getRemainingRunningTime() {
        return estimatedRunningTime - runningProgress;
    }
}
