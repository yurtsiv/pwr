package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Algorithm1 implements Algorithm {
    @Override
    public void serveNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config) {
        Processor initialProcessor = processors.get(0);

        for (int i = 1; i <= config.z; i++) {
            Processor processorToAsk = processors.get(i);
            if (processorToAsk.getLoad() < config.p) {
                processorToAsk.addProcess(process);
                processorToAsk.incerementMigrations();
                return;
            }
        }

        initialProcessor.addProcess(process);
    }
}
