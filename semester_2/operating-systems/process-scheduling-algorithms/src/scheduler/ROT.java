package scheduler;

import processes.Process;

import java.util.ArrayList;

public class ROT implements ScheduleAlgorithm {
    private int quantum,
                quantumProgress = 0,
                currentProcessIndex = 0;

    public ROT(int quantum) {
        if (quantum <= 0) {
            throw new IllegalArgumentException("quantum should be >= 0");
        }

        this.quantum = quantum;
    }

    private void updateWaitingTimes(ArrayList<Process> readyProcesses) {
        for (int i = 0; i < readyProcesses.size(); i++) {
            if (i != currentProcessIndex) {
                readyProcesses.get(i).incrementWaitingTime();
            }
        }
    }

    @Override
    public void tick(int currentTime, ArrayList<Process> readyProcesses) {
        if (currentProcessIndex >= readyProcesses.size() - 1) {
            currentProcessIndex = 0;
        }

        if (quantumProgress == quantum) {
            quantumProgress = 0;
            if (currentProcessIndex >= readyProcesses.size() - 1) {
                currentProcessIndex = 0;
            } else {
                currentProcessIndex++;
            }
        }

        if (readyProcesses.size() != 0) {
            Process currentProcess = readyProcesses.get(currentProcessIndex);
            currentProcess.incrementProgress();
            updateWaitingTimes(readyProcesses);
            quantumProgress++;
        }
    }
}
