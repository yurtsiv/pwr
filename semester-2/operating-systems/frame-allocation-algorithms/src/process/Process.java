package process;

import algorithms.pageReplacement.LRU;
import simulation.SimulationConfig;
import utils.RandomNums;

import java.util.ArrayList;
import java.util.Set;
import java.util.TreeSet;

public class Process {
    private ArrayList<Request> requests;
    private int
        minPage,
        maxPage,
        pageReplacements = 0,
        timeWindowCounter = 0,
        localTime = 0;

    private double pageFaultFreq = 0;

    private ArrayList<Request> memory = new ArrayList<>();
    private TreeSet<Request> workingSet = new TreeSet<>();
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
            ArrayList<Request> newMemory = new ArrayList<>(newSize);
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

    private boolean isMemoryFull() {
        return memory.get(memory.size() - 1) != null;
    }

    public int getLastPageIndex() {
        return memory.indexOf(null);
    }

    public int getUniqPagesNum() {
        return maxPage - minPage;
    }

    public double getPageFaultFreq() {
        return pageFaultFreq;
    }

    private void updatePageFaultFreq() {
        pageFaultFreq = (double)pageReplacements / (double) localTime;
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

    public void serveNextRequest(SimulationConfig config) {
        if (requests.size() == 0) {
            return;
        }

        Request currReq = requests.get(requests.size() - 1);
        Request reqCopy = currReq.clone();
        requests.remove(requests.size() - 1);

        int indexOfMemoryPage = memory.indexOf(reqCopy);
        boolean pagePresent = indexOfMemoryPage != -1;

        if (timeWindowCounter > config.timeWindowSize) {
            System.out.println(workingSet.size());
            workingSet = new TreeSet<>();
            timeWindowCounter = 0;
        } else {
            workingSet.add(currReq);
        }


        if (!isMemoryFull() && !pagePresent) {
            reqCopy.setLastUsed(localTime);
            memory.set(getLastPageIndex(), reqCopy);
            pageReplacements++;
        } else if (pagePresent) {
            Request memoryPage = memory.get(indexOfMemoryPage);
            memoryPage.setLastUsed(localTime);
        } else {
            reqCopy.setLastUsed(localTime);
            lru.replacePage(memory, requests, reqCopy);
            pageReplacements++;
        }

        localTime++;
        timeWindowCounter++;
        updatePageFaultFreq();
    }

    public Process clone() {
        ArrayList<Request> clonedRequests = new ArrayList<>();
        for (Request req : requests) {
            clonedRequests.add(req.clone());
        }

       return new Process(clonedRequests, minPage, maxPage);
    }
}
