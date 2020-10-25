package algorithms;

import simulation.Process;
import simulation.Processor;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Algorithm3 implements Algorithm {
    private Algorithm2 alg2 = new Algorithm2();
    @Override
    public void serveNewProcess(Process process, ArrayList<Processor> processors, SimulationConfig config) {
        alg2.serveNewProcess(process, processors, config);

        ArrayList<Processor> lowLoadedProcessors = new ArrayList<>();
        ArrayList<Processor> highLoadedProcessors = new ArrayList<>();

        for (Processor processor : processors) {
            int load = processor.getLoad();
            if (load < config.r) {
                lowLoadedProcessors.add(processor);
            }
            if (load > config.p) {
                highLoadedProcessors.add(processor);
            }
        }

        for (Processor lowLoadedProcessor : lowLoadedProcessors) {
            if (highLoadedProcessors.size() != 0) {
                Processor highLoadedProcessor = highLoadedProcessors.get(0);
                lowLoadedProcessor.addProcess(highLoadedProcessor.popProcess());
                lowLoadedProcessor.incerementMigrations();
                highLoadedProcessors.remove(0);
            }
        }
    }
}
