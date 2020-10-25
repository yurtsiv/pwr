package process;

import algorithms.pageReplacement.LRU;
import simulation.SimulationConfig;
import utils.RandomNums;

import java.util.ArrayList;
import java.util.TreeSet;

public class Process {
    private ArrayList<Request> requests;
    private int
        minPage,
        maxPage,
        pageReplacements = 0,
        // since last time window (freq control)
        recentPageReplacements = 0,
        timeWindowCounter = 0,
        localTime = 0,
        orignalReqSeqLen = 0;

    private ArrayList<Request> memory = new ArrayList<>();
    private TreeSet<Request> workingSet = new TreeSet<>();
    private LRU lru = new LRU();

    public Process(ArrayList<Request> requests, int minPage, int maxPage) {
        this.requests = requests;
        this.orignalReqSeqLen = requests.size();
        this.minPage = minPage;
        this.maxPage = maxPage;
    }

    public Process(int minPage, int maxPage, int maxReqSeqLen) {
        this.minPage = minPage;
        this.maxPage = maxPage;
        int seqLen = RandomNums.randomInt(maxReqSeqLen / 2, maxReqSeqLen);
        this.requests = RequestGenerator.generate(seqLen, minPage, maxPage);
        this.orignalReqSeqLen = seqLen;
    }

    public int getOrignalReqSeqLen() {
        return orignalReqSeqLen;
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

    public void incrementMemSize() {
        setMemorySize(memory.size() + 1);
    }

    public void decrementMemSize() {
        if (memory.size() > 1) {
            setMemorySize(memory.size() - 1);
        }
    }

    public ArrayList<Request> getMemory() {
        return memory;
    }

    public ArrayList<Request> getRequests() {
        return requests;
    }

    public int getPageReplacements() {
        return pageReplacements;
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


    public void incrementTimeWindowCounter() {
        timeWindowCounter++;
    }

    public int getTimeWindowCounter() {
        return timeWindowCounter;
    }

    public int getWorkingSetSize() {
        return workingSet.size();
    }

    public int getRecentPageReplacements() {
        return recentPageReplacements;
    }

    public void serveNextRequest(SimulationConfig config) {
        if (requests.size() == 0) {
            return;
        }

        Request currReq = requests.get(requests.size() - 1);
        Request reqCopy = currReq.clone();
        requests.remove(requests.size() - 1);

        int indexOfMemoryPage = memory.indexOf(reqCopy);
        boolean pagePresent = indexOfMemoryPage != -1;

        if (timeWindowCounter > config.workingSetTimeWindow) {
            workingSet = new TreeSet<>();
            timeWindowCounter = 0;
        } else {
            workingSet.add(currReq);
        }


        if (!isMemoryFull() && !pagePresent) {
            reqCopy.setLastUsed(localTime);
            memory.set(getLastPageIndex(), reqCopy);
            recentPageReplacements++;
            pageReplacements++;
        } else if (pagePresent) {
            Request memoryPage = memory.get(indexOfMemoryPage);
            memoryPage.setLastUsed(localTime);
        } else {
            reqCopy.setLastUsed(localTime);
            lru.replacePage(memory, requests, reqCopy);
            recentPageReplacements++;
            pageReplacements++;
        }

        localTime++;
        timeWindowCounter++;
        if (localTime > config.pageFaultFreqTimeWindow && localTime % config.pageFaultFreqTimeWindow == 1) {
            recentPageReplacements = 0;
        }
    }

    public int getLocalTime() {
        return localTime;
    }

    public Process clone() {
        ArrayList<Request> clonedRequests = new ArrayList<>();
        for (Request req : requests) {
            clonedRequests.add(req.clone());
        }

       return new Process(clonedRequests, minPage, maxPage);
    }

    public int getMaxPage() {
        return maxPage;
    }

    public int getMinPage() {
        return minPage;
    }
}
