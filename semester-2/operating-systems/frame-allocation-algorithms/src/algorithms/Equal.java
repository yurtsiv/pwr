package algorithms;

import process.Process;

import java.util.ArrayList;

public class Equal implements FrameAllocAlgorithm {
    @Override
    public void assignMemorySizes(ArrayList<Process> processes, int totalMemorySize) {
        int pagesForProcess = totalMemorySize / processes.size();
        for (Process proc : processes) {
            proc.setMemorySize(pagesForProcess);
        }
    }
}
