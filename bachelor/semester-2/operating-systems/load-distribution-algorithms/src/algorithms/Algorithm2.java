package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Algorithm2 implements Algorithm {
    @Override
    public void serveNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config) {
        Processor initialProcessor = processors.get(0);

        if (initialProcessor.getLoad() <= config.p) {
            initialProcessor.addProcess(process);
            return;
        }

        for (Processor processor : processors) {
            if (processor.getLoad() <= config.p) {
                processor.addProcess(process);
                processor.incerementMigrations();
                return;
            }
        }

        throw new RuntimeException("Algorithm2: Every processor is overloaded");
    }
}
