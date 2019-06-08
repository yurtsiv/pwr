package simulation;

import algorithms.Algorithm;

import java.util.ArrayList;

public class Simulation {
    int time = 0;

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
           clonnedProcesses.add(proc.clone());
       }

       for (Process process : clonnedProcesses) {
           time++;
          algorithm.serveNewProcess(process, processors, config);

          for (Processor processor : processors) {
              processor.tick();
          }
       }

       return processors;
    }
}
