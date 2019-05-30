package algorithms;

import process.Process;
import simulation.SimulationConfig;

import java.util.ArrayList;
import java.util.Comparator;

public class PageFaultFrequencyControl implements FrameAllocAlgorithm {
    private Process getMaxPageFaultFreqProc(ArrayList<Process> processes) {
        return processes
            .stream()
            .max(Comparator.comparing(Process::getRecentPageReplacements))
            .get();
    }

    private Process getMinPageFaultFreqProc(ArrayList<Process> processes) {
        return processes
            .stream()
            .min((proc1, proc2) -> {
                if (proc2.getMemory().size() == 1) {
                    return -1;
                }
                return proc1.getRecentPageReplacements() - proc2.getRecentPageReplacements();
            })
            .get();
    }

    @Override
    public void assignMemorySizes(ArrayList<Process> processes, SimulationConfig config) {
        for (Process proc : processes) {
            if (
                proc.getLocalTime() < config.pageFaultFreqTimeWindow ||
                proc.getLocalTime() % config.pageFaultFreqTimeWindow != 0
            ) {
                return;
            }

            int procFaultFreq = proc.getRecentPageReplacements();
            if (procFaultFreq != 1 && procFaultFreq > config.maxPageFaultFreqThreshold) {
                proc.incrementMemSize();
                Process min = getMinPageFaultFreqProc(processes);
                min.decrementMemSize();
            }

            if (procFaultFreq < config.minPageFaultFreqThreshold) {
                if (proc.getMemory().size() > 1) {
                    proc.decrementMemSize();
                    Process max = getMaxPageFaultFreqProc(processes);
                    max.incrementMemSize();
                }
            }
        }
    }
}
