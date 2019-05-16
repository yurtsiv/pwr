package process;

import utils.RandomNums;

import java.util.ArrayList;

public class Process {
    private ArrayList<Request> requests;
    private int minPage, maxPage;

    public Process(ArrayList<Request> requests, int minPage, int maxPage) {
        this.requests = requests;
        this.minPage = minPage;
        this.maxPage = maxPage;
    }

    public Process(int minPage, int maxPage, int maxReqSeqLen) {
        this.minPage = minPage;
        this.maxPage = maxPage;
        int seqLen = RandomNums.randomInt(maxReqSeqLen / 2, maxReqSeqLen);
        this.requests = RequestGenerator.generate(seqLen, minPage, maxPage);
    }

    public Process clone() {
        ArrayList<Request> clonedRequests = new ArrayList<>();
        for (Request req : requests) {
            clonedRequests.add(req.clone());
        }
        
       return new Process(clonedRequests, minPage, maxPage);
    }
}
