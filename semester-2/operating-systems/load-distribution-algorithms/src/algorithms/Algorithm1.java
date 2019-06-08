package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;
import utils.RandomNums;

import java.util.ArrayList;

public class Algorithm1 implements Algorithm {
    @Override
    public void serveNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config) {
        int initialProcessorIndex = RandomNums.getInt(0, processors.size() - 1);
        Processor initialProcessor = processors.get(initialProcessorIndex);

        int migrationAttempts = 0;
        ArrayList<Integer> prevAsked = new ArrayList<>();

        while(migrationAttempts < config.z) {
           int processorToAskIndex = initialProcessorIndex;
           while (processorToAskIndex == initialProcessorIndex || prevAsked.contains(processorToAskIndex)) {
              processorToAskIndex = RandomNums.getInt(0, processors.size() - 1);
           }

           Processor processorToAsk = processors.get(processorToAskIndex);
           if (processorToAsk.getLoad() < config.p) {
               processorToAsk.addProcess(process);
               return;
           }
        }

        // in case each processor is loaded
        initialProcessor.addProcess(process);
    }
}
