package scheduler;

import request.Request;
import java.util.ArrayList;
import java.util.Iterator;

public class Scheduler {
    private int currentTime, currentHeadPosition;
    private ArrayList<Request>
            allRequests,
            activeRequests = new ArrayList<>(),
            inactiveRequests = new ArrayList<>();

    private ArrayList<Integer> headPath = new ArrayList<>();

    private ArrayList<Request> cloneRequests(ArrayList<Request> requests) {
        ArrayList<Request> res = new ArrayList<>();
        try {
            for (Request request : requests) {
                res.add(request.clone());
            }
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void splitRequests() {
        for (Request request : allRequests) {
            if (request.getArrivalTime() == 0) {
                activeRequests.add(request);
            } else {
                inactiveRequests.add(request);
            }
        }
    }

    private void addNewRequestsToActiveQueue() {
        Iterator<Request> iter = inactiveRequests.iterator();
        while (iter.hasNext()) {
            Request next = iter.next();
            if (next.getArrivalTime() == currentTime) {
                iter.remove();
                activeRequests.add(next);
            }
        }
    }

    private boolean allRequestsServerd() {
        return activeRequests.size() == 0 && inactiveRequests.size() == 0;
    }

    private void resetState() {
        currentTime = 0;
        activeRequests = new ArrayList<>();
        inactiveRequests = new ArrayList<>();
        headPath = new ArrayList<>();
    }

    public ArrayList<Integer> run(ArrayList<Request> requests, int initialHeadPosition, ScheduleAlgorithm algorithm) {
        resetState();
        allRequests = cloneRequests(requests);
        currentHeadPosition = initialHeadPosition;

        splitRequests();

        while(!allRequestsServerd()) {
            addNewRequestsToActiveQueue();

            if (activeRequests.size() != 0) {
                Request nextReq = algorithm.getNextRequest(activeRequests, currentHeadPosition);
                currentHeadPosition = nextReq.getDiskLocation();
                headPath.add(nextReq.getDiskLocation());
                activeRequests.remove(nextReq);
            }

            currentTime++;
        }

        return headPath;
    }
}
