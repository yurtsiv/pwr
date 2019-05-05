package algorithms;

import request.Request;

import java.util.ArrayList;
import java.util.Comparator;

// Least Recently Used
public class LRU implements Algorithm {
    @Override
    public void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        Request leastRecentlyUsed = memory
                .stream()
                .min(Comparator.comparing(Request::getLastUsed))
                .get();


        memory.set(memory.indexOf(leastRecentlyUsed), currentRequest);
    }
}
