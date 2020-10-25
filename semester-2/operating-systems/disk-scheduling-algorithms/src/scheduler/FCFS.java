package scheduler;

import request.Request;

import java.util.ArrayList;

public class FCFS implements ScheduleAlgorithm {
    @Override
    public Request getNextRequest(ArrayList<Request> activeRequests, int currentHeadPosition) {
        return activeRequests.get(0);
    }
}
