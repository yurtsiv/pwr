package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;

import java.util.ArrayList;

public interface Algorithm {
    void putNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config);
}
