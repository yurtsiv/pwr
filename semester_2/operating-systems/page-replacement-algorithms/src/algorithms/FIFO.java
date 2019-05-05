package algorithms;

import request.Request;

import java.util.ArrayList;

// Fist-In, First-Out
public class FIFO implements Algorithm {
    @Override
    public void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        memory.remove(0);
        memory.add(currentRequest);
    }
}
