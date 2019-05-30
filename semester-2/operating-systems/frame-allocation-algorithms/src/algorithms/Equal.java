package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Equal implements FrameAllocAlgorithm {
    @Override
    public void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config) {
        int pagesForProcess = config.memorySize / processes.size();
        for (Process proc : processes) {
            proc.setMemorySize(pagesForProcess);
        }

        int filledMemory = pagesForProcess * processes.size();
        while(filledMemory != config.memorySize) {
            for (Process proc : processes) {
                proc.incrementMemSize();
                filledMemory++;
                if (filledMemory == config.memorySize) {
                    return;
                }
            }
        }
    }
}
