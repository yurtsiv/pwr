package simulation;

import algorithms.FrameAllocAlgorithm;
import process.Process;

import java.util.ArrayList;

public class Simulation {
    public static int run(FrameAllocAlgorithm alg, ArrayList<Process> processes, int totalMemSize) {
        boolean requestsRemain = true;
        while(requestsRemain) {
            requestsRemain = false;
            alg.assignMemorySizes(processes, totalMemSize);
            for (Process proc : processes) {
                requestsRemain = proc.getRequests().size() != 0;
                proc.serveNextRequest();
            }
        }
    }
}
