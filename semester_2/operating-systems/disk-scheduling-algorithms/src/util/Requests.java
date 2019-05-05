package util;

import request.Request;

import java.util.ArrayList;
import java.util.Comparator;

public class Requests {
    public static Request findNearestToHead(ArrayList<Request> requests, int headPosition) {
        Request nearestRequest = requests.get(0);
        int minDistance = Math.abs(headPosition - nearestRequest.getDiskLocation());
        for (Request request : requests) {
            int nextDist = Math.abs(headPosition - request.getDiskLocation());

            if (nextDist < minDistance) {
                nearestRequest = request;
                minDistance = nextDist;
            }
        }

        return nearestRequest;
    }

    public static Request findTopPriorityRequest(ArrayList<Request> requests) {
        return requests
                .stream()
                .max(Comparator.comparing(Request::getPriority))
                .orElse(null);
    }

}
