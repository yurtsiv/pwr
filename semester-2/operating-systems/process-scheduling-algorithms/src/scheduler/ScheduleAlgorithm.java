package scheduler;

import processes.Process;

import java.util.ArrayList;

public interface ScheduleAlgorithm {
    void tick(int currentTime, ArrayList<Process> readyProcesses);
}
