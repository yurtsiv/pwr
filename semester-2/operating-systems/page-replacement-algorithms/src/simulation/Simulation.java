package simulation;

import algorithms.Algorithm;
import request.Request;

import java.util.ArrayList;
import java.util.Arrays;

public class Simulation {
    private ArrayList<Request> memory;

    public boolean isMemoryFull() {
        return memory.get(memory.size() - 1) != null;
    }

    public int getLastPageIndex() {
        return memory.indexOf(null);
    }

    public ArrayList<Request> cloneRequests(ArrayList<Request> requests) {
        ArrayList<Request> result = new ArrayList<>();
        for (Request req : requests) {
            result.add(req.clone());
        }
        return result;
    }

    public int run(Algorithm alg, ArrayList<Request> originalRequests, int segmentsNum) {
        ArrayList<Request> requests = cloneRequests(originalRequests);
        this.memory = new ArrayList<>(
            Arrays.asList(new Request[segmentsNum])
        );

        int replacements = 0;
        int time = 0;
        for (Request request : requests) {
            Request reqCopy = request.clone();
            int indexOfMemoryPage = memory.indexOf(reqCopy);
            boolean pagePresent = indexOfMemoryPage != -1;

            if (!isMemoryFull() && !pagePresent) {
                reqCopy.setLastUsed(time);
                reqCopy.setSecondChance(true);
                memory.set(getLastPageIndex(), reqCopy);
                replacements++;
            } else if (pagePresent) {
                Request memoryPage = memory.get(indexOfMemoryPage);
                memoryPage.setLastUsed(time);
                memoryPage.setSecondChance(true);
            } else {
                reqCopy.setLastUsed(time);
                alg.replacePage(memory, requests, reqCopy);
                replacements++;
            }

            time++;
        }

        return replacements;
    }
}
