package process;

import utils.RandomNums;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class Process {
    private ArrayList<Request> requests;
    private int minPage, maxPage, memorySize = 0;
    private ArrayList<Request> memory;

    public Process(ArrayList<Request> requests, int minPage, int maxPage) {
        this.requests = requests;
        this.minPage = minPage;
        this.maxPage = maxPage;
        this.memorySize = memorySize;
    }

    public Process(int minPage, int maxPage, int maxReqSeqLen) {
        this.minPage = minPage;
        this.maxPage = maxPage;
        this.memorySize = memorySize;
        int seqLen = RandomNums.randomInt(maxReqSeqLen / 2, maxReqSeqLen);
        this.requests = RequestGenerator.generate(seqLen, minPage, maxPage);
    }

    public void setMemorySize(int newSize) {
        if (newSize < 1) {
            throw new IllegalArgumentException("Memory size should be at least 1");
        }

        if (newSize < this.memorySize) {
            memory = new ArrayList<>(memory.subList(0, newSize));
        }

        this.memorySize = newSize;
    }

    public ArrayList<Request> getMemory() {
        return memory;
    }

    public ArrayList<Request> getRequests() {
        return requests;
    }

    public void serveNextRequest() {

    }

    public Process clone() {
        ArrayList<Request> clonedRequests = new ArrayList<>();
        for (Request req : requests) {
            clonedRequests.add(req.clone());
        }

       return new Process(clonedRequests, minPage, maxPage);
    }
}
