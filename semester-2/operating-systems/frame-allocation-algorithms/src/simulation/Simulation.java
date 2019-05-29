package simulation;

import algorithms.FrameAllocAlgorithm;
import process.Process;

import java.util.ArrayList;

public class Simulation {
    public static ArrayList<Process> run(FrameAllocAlgorithm alg, ArrayList<Process> procs, SimulationConfig config) {
        ArrayList<Process> procsCopy = new ArrayList<>();
        for (Process proc : procs) {
            procsCopy.add(proc.clone());
        }

        boolean requestsRemain = true;
        while(requestsRemain) {
            requestsRemain = false;
            alg.assignMemorySizes(procsCopy, config);
            for (Process proc : procsCopy) {
                requestsRemain = proc.getRequests().size() != 0;
                proc.serveNextRequest();
            }
        }

        return procsCopy;
    }
}
