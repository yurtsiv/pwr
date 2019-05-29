package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;
import java.util.Comparator;

public class PageFaultFrequencyControl implements FrameAllocAlgorithm {
    private Process getMaxPageFaultFreqProc(ArrayList<Process> processes) {
        return processes
            .stream()
            .max(Comparator.comparing(Process::getPageFaultFreq))
            .get();
    }

    private Process getMinPageFaultFreqProc(ArrayList<Process> processes) {
        return processes
            .stream()
            .min((proc1, proc2) -> {
                if (proc1.getMemory().size() == 1) {
                    return 1;
                } if (proc2.getMemory().size() == 1) {
                    return -1;
                } else if (proc1.getPageFaultFreq() - proc2.getPageFaultFreq() < 0) {
                    return -1;
                }
                return 1;
            })
            .get();
    }

    @Override
    public void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config) {
        for (Process proc : processes) {
            double procFaultFreq = proc.getPageFaultFreq();
            if (procFaultFreq != 1 && procFaultFreq > config.maxPageFaultFreqThreshold) {
                proc.incrementMemSize();
                getMinPageFaultFreqProc(processes).decrementMemSize();
            }

            if (procFaultFreq < config.minPageFaultFreqThreshold) {
                if (proc.getMemory().size() > 1) {
                    proc.decrementMemSize();
                    getMaxPageFaultFreqProc(processes).incrementMemSize();
                }
            }
        }
    }
}
