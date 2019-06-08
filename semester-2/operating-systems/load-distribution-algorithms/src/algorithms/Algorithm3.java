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

        processors
            .stream()
            .filter(processor -> processor.getLoad() < config.r)
            .forEach(notLoadedProc -> {
                Processor loadedProc = processors
                    .stream()
                    .filter(proc -> proc.getLoad() > config.p)
                    .findFirst()
                    .orElse(null);

                if (loadedProc != null) {
                    notLoadedProc.addProcess(loadedProc.popProcess());
                }
            });
    }
}
