package simulation;

import algorithms.Algorithm;

import java.util.ArrayList;

public class Simulation {
    public ArrayList<Processor> run(
        ArrayList<Process> processes,
        SimulationConfig config,
        Algorithm algorithm
    ) {
       ArrayList<Processor> processors = new ArrayList<>();
       for (int i = 0; i < config.n; i++) {
           processors.add(new Processor());
       }

       ArrayList<Process> clonnedProcesses = new ArrayList<>();
       for (Process proc : processes) {
           processes.add(proc.clone());
       }

       for (Process process : clonnedProcesses) {
          algorithm.serveNewProcess(process, processors, config);

          for (Processor processor : processors) {
              processor.tick();
          }
       }

       return processors;
    }
}
