package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Proportional implements FrameAllocAlgorithm {
    @Override
    public void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config) {
        int memorySize = config.memorySize;
        int totalUniquePages = 0;
        for (Process proc : processes) {
            totalUniquePages += proc.getUniqPagesNum();
        }

        int filledMemory = 0;
        for (Process proc : processes) {
            int estimatedProcPages = (int)(memorySize * ((double)proc.getUniqPagesNum() / (double)totalUniquePages));
            int procPages = estimatedProcPages == 0 ? 1 : estimatedProcPages;
            filledMemory += procPages;
            proc.setMemorySize(procPages);
        }

        while (filledMemory != memorySize) {
            for (Process proc : processes) {
                filledMemory += 1;
                proc.incrementMemSize();

                if (filledMemory == memorySize) {
                    return;
                }
            }
        }
    }
}
