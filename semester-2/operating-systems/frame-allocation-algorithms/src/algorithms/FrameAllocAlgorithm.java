package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;

public interface FrameAllocAlgorithm {
    void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config);
}
