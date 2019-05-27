package algorithms;

import process.Process;

import java.util.ArrayList;

public interface FrameAllocAlgorithm {
    void assignMemorySizes(ArrayList<Process> processes, int totalMemorySize);
}
