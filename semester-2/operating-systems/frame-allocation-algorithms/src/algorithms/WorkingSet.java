package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class WorkingSet implements FrameAllocAlgorithm {
    @Override
    public void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config) {
       for (Process proc : processes) {
           if (proc.getTimeWindowCounter() == config.timeWindowSize) {
               int workingSetSize = proc.getWorkingSetSize();
               if (workingSetSize != 0) {
                   proc.setMemorySize(workingSetSize);
               }
           }
       }

       int filledMem = 0;
       for(Process proc : processes) {
           filledMem += proc.getMemory().size();
       }

       if (filledMem > config.memorySize) {
           while (filledMem != config.memorySize) {
               for (Process proc : processes) {
                   proc.decrementMemSize();
                   filledMem--;
                   if (filledMem == config.memorySize) {
                       return;
                   }
               }
           }
       }

       if (filledMem < config.memorySize) {
           while(filledMem != config.memorySize) {
               for (Process proc : processes) {
                   proc.incrementMemSize();
                   filledMem++;
                   if (filledMem == config.memorySize) {
                       return;
                   }
               }
           }
       }
    }
}
