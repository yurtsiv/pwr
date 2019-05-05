package scheduler;

import processes.Process;

import java.util.ArrayList;

public class FCFS implements ScheduleAlgorithm {
    private void updateWaitingTimes(ArrayList<Process> readyProcesses) {
        for (int i = 1; i < readyProcesses.size(); i++) {
            readyProcesses.get(i).incrementWaitingTime();
        }
    }

    @Override
    public void tick(int currentTime, ArrayList<Process> readyProcesses) {
        Process currentProcess = readyProcesses.get(0);
        currentProcess.incrementProgress();
        updateWaitingTimes(readyProcesses);
    }
}
