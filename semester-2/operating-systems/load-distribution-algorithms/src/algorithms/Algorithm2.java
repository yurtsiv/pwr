package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;
import utils.RandomNums;

import java.util.ArrayList;

public class Algorithm2 implements Algorithm {
    @Override
    public void serveNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config) {
        int initialProcessorIndex = RandomNums.getInt(0, processors.size() - 1);
        Processor initialProcessor = processors.get(initialProcessorIndex);

        if (initialProcessor.getLoad() <= config.p) {
            initialProcessor.addProcess(process);
            return;
        }

        Processor processor = initialProcessor;
        while (processor.getLoad() > config.p) {
            int processorIndex = RandomNums.getInt(0, processors.size() - 1);
            processor = processors.get(processorIndex);
        }
        processor.addProcess(process);
    }
}
