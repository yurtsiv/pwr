package scheduler;

import request.Request;
import util.Requests;

import java.util.ArrayList;

public class SSTF implements ScheduleAlgorithm {
   @Override
   public Request getNextRequest(ArrayList<Request> activeRequests, int currentHeadPosition) {
      return Requests.findNearestToHead(activeRequests, currentHeadPosition);
   }
}
