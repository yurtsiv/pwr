package request;

public class Request {
    private int id, arrivalTime, diskLocation, priority = 0;

    public Request(int id, int diskLocation, int arrivalTime) {
        this.id = id;
        this.diskLocation = diskLocation;
        this.arrivalTime = arrivalTime;
    }

    public int getId() {
        return id;
    }

    public int getArrivalTime() {
        return arrivalTime;
    }

    public int getDiskLocation() {
        return diskLocation;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public int getPriority() {
        return priority;
    }

    public Request clone() {
        Request res =  new Request(id, diskLocation, arrivalTime);
        res.setPriority(priority);
        return res;
    }
}

