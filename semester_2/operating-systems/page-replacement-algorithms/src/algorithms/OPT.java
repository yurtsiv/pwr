package algorithms;

import request.Request;

import java.util.ArrayList;
import java.util.List;

// Optimal
public class OPT implements Algorithm {
    private FIFO fifoAlg = new FIFO();

    // in the future
    private int indexOfLeastUsedPage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        int startIndex = requests.indexOf(currentRequest);
        List<Request> remainingRequests = requests.subList(startIndex, requests.size() - 1);

        int maxReqIndex = 0;
        int leastUsedPageIndex = -1;

        for(int i = 0; i < memory.size(); i++) {
            int nextReqIndex = remainingRequests.indexOf(memory.get(i));
            if (nextReqIndex > maxReqIndex) {
                maxReqIndex = nextReqIndex;
                leastUsedPageIndex = i;
            }
        }

        return leastUsedPageIndex;
    }

    @Override
    public void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        int leastUsedIndex = indexOfLeastUsedPage(memory, requests, currentRequest);

        if (leastUsedIndex == -1) {
            fifoAlg.replacePage(memory, requests, currentRequest);
        } else {
            memory.set(leastUsedIndex, currentRequest);
        }
    }
}
