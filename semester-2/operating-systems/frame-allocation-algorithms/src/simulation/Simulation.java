package simulation;

import algorithms.Equal;
import algorithms.FrameAllocAlgorithm;
import process.Process;

import java.util.ArrayList;
import java.util.Iterator;

public class Simulation {
    private static Equal equalAlg = new Equal();

    public static ArrayList<Process> run(FrameAllocAlgorithm alg, ArrayList<Process> procs, SimulationConfig config) {
        ArrayList<Process> procsCopy = new ArrayList<>();
        ArrayList<Process> workingProcs = new ArrayList<>();
        for (Process proc : procs) {
            Process clone = proc.clone();
            procsCopy.add(clone);
            workingProcs.add(clone);
        }


        equalAlg.assignMemorySizes(procsCopy, config);

        while(workingProcs.size() != 0) {
            alg.assignMemorySizes(procsCopy, config);
            for (Process proc : workingProcs) {
                proc.incrementTimeWindowCounter();
                proc.serveNextRequest(config);
            }

            Iterator<Process> procIter = workingProcs.iterator();
            while(procIter.hasNext()) {
                if (procIter.next().getRequests().size() == 0) {
                    procIter.remove();
                }
            }
        }

        return procsCopy;
    }
}
