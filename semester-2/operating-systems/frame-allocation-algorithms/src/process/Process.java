package process;

import utils.RandomNums;

import java.util.ArrayList;

public class Process {
    private ArrayList<Request> requests;
    private int minPage, maxPage;

    public Process(int minPage, int maxPage, int maxReqSeqLen) {
        this.minPage = minPage;
        this.maxPage = maxPage;
        int seqLen = RandomNums.randomInt(maxReqSeqLen / 2, maxReqSeqLen);
        this.requests = RequestGenerator.generate(seqLen, minPage, maxPage);
    }
}
