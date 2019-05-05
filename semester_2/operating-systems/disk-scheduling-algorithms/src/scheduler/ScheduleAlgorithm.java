package scheduler;

import request.Request;
import java.util.ArrayList;

public interface ScheduleAlgorithm {
    Request getNextRequest(ArrayList<Request> activeRequests, int currentHeadPosition);
}
