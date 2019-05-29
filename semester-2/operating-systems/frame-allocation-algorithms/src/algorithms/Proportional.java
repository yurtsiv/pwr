package algorithms;

import process.Process;

import java.util.ArrayList;

public class Proportional implements FrameAllocAlgorithm {
    @Override
    public void assignMemorySizes(ArrayList<Process> processes, int totalMemorySize) {
        int totalUniquePages = 0;
        for (Process proc : processes) {
            totalUniquePages += proc.getUniqPagesNum();
        }

        int filledMemory = 0;
        for (Process proc : processes) {
            int estimatedProcPages = (int)(totalMemorySize * ((double)proc.getUniqPagesNum() / (double)totalUniquePages));
            int procPages = estimatedProcPages == 0 ? 1 : estimatedProcPages;
            filledMemory += procPages;
            proc.setMemorySize(procPages);
        }

        while (filledMemory != totalMemorySize) {
            for (Process proc : processes) {
                filledMemory += 1;
                proc.setMemorySize(proc.getMemory().size() + 1);

                if (filledMemory == totalMemorySize) {
                    return;
                }
            }
        }
    }
}
