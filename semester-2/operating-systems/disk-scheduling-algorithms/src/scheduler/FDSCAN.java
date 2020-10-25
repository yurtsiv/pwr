package scheduler;

import request.Request;
import util.Requests;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class FDSCAN implements ScheduleAlgorithm {
    // all requests that are between current head position and top priority request
    private ArrayList<Request> reqsBeforeTopPrior = new ArrayList<>();
    private Request topPriorityReq = null;
    private SCAN scan = new SCAN();

    private void updatePathToTopPriorityReq(ArrayList<Request> activeRequests, int headPos, int moveDirection) {
         reqsBeforeTopPrior = activeRequests
            .stream()
            .filter((req) -> {
                int reqLocation = req.getDiskLocation();
                if (moveDirection == 1) {
                   return reqLocation >= headPos && reqLocation <= topPriorityReq.getDiskLocation();
                } else {
                    return reqLocation <= headPos && reqLocation >= topPriorityReq.getDiskLocation();
                }
            })
            .collect(Collectors.toCollection(ArrayList::new));
    }

    @Override
    public Request getNextRequest(ArrayList<Request> activeRequests, int currentHeadPosition) {
        if (reqsBeforeTopPrior.size() == 0) {
            topPriorityReq = Requests.findTopPriorityRequest(activeRequests);
        }

        int moveDirection = 1;
        if (topPriorityReq.getDiskLocation() <= currentHeadPosition) {
            moveDirection = -1;
        }

        updatePathToTopPriorityReq(activeRequests, currentHeadPosition, moveDirection);

        scan.setMoveDirection(moveDirection);
        Request nextReq = scan.getNextRequest(reqsBeforeTopPrior, currentHeadPosition);
        reqsBeforeTopPrior.remove(nextReq);
        return nextReq;
    }
}
