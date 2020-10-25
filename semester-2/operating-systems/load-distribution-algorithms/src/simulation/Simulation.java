package simulation;

import algorithms.Algorithm;

import java.util.ArrayList;
import java.util.Collections;

public class Simulation {
    public ArrayList<Processor> run(ArrayList<Process> processes, SimulationConfig config, Algorithm algorithm) {
       ArrayList<Processor> processors = new ArrayList<>();
       for (int i = 0; i < config.n; i++) {
           processors.add(new Processor());
       }

       ArrayList<Process> clonnedProcesses = new ArrayList<>();
       for (Process proc : processes) {
           clonnedProcesses.add(proc.clone());
       }

       for (Process process : clonnedProcesses) {
          Collections.shuffle(processors);
          algorithm.serveNewProcess(process, processors, config);
          processors.forEach(Processor::tick);
       }

       return processors;
    }
}
