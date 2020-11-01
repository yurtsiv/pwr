package algorithms;

import random.RandomNums;
import request.Request;

import java.util.ArrayList;

// Random
public class RAND implements Algorithm {
    @Override
    public void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        int pageIndexToReplace = RandomNums.randomInt(0, memory.size() - 1);
        memory.set(pageIndexToReplace, currentRequest);
    }
}
