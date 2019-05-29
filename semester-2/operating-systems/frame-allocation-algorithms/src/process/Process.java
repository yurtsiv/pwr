package process;

import algorithms.pageReplacement.LRU;
import utils.RandomNums;

import java.util.ArrayList;

public class Process {
    private ArrayList<Request> requests;
    private int minPage, maxPage, pageReplacements = 0, time = 0;
    private ArrayList<Request> memory = new ArrayList<>();
    private LRU lru = new LRU();

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

    public void setMemorySize(int newSize) {
        if (newSize < 1) {
            throw new IllegalArgumentException("Memory size should be at least 1");
        }

        if (newSize < memory.size()) {
            memory = new ArrayList<>(memory.subList(0, newSize));
        } else {
            ArrayList<Request> newMemory = new ArrayList<>();
            for (Request memPage : memory) {
                newMemory.add(memPage);
            }
            for (int i = 0; i < newSize - memory.size(); i++) {
                newMemory.add(null);
            }
            this.memory = newMemory;
        }
    }

    public ArrayList<Request> getMemory() {
        return memory;
    }

    public ArrayList<Request> getRequests() {
        return requests;
    }

    private boolean isMemoryFull() {
        return memory.get(memory.size() - 1) != null;
    }

    public int getLastPageIndex() {
        return memory.indexOf(null);
    }

    public int getUniqPagesNum() {
        return maxPage - minPage;
    }

    public void serveNextRequest() {
        if (requests.size() == 0) {
            return;
        }

        Request currReq = requests.get(requests.size() - 1);
        Request reqCopy = currReq.clone();
        requests.remove(requests.size() - 1);

        int indexOfMemoryPage = memory.indexOf(reqCopy);
        boolean pagePresent = indexOfMemoryPage != -1;

        if (!isMemoryFull() && !pagePresent) {
            reqCopy.setLastUsed(time);
            memory.set(getLastPageIndex(), reqCopy);
            pageReplacements++;
        } else if (pagePresent) {
            Request memoryPage = memory.get(indexOfMemoryPage);
            memoryPage.setLastUsed(time);
        } else {
            reqCopy.setLastUsed(time);
            lru.replacePage(memory, requests, reqCopy);
            pageReplacements++;
        }

        time++;
    }

    public Process clone() {
        ArrayList<Request> clonedRequests = new ArrayList<>();
        for (Request req : requests) {
            clonedRequests.add(req.clone());
        }

       return new Process(clonedRequests, minPage, maxPage);
    }
}
