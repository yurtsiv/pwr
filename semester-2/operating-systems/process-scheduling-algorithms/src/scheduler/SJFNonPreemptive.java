package scheduler;

import processes.Process;

import java.util.ArrayList;

public class SJFNonPreemptive extends SJF implements ScheduleAlgorithm {
    @Override
    public void tick(int currentTime, ArrayList<Process> readyProcesses) {
        super.tick(currentTime, readyProcesses, (proc1, proc2) -> {
            if (proc2.getIsRunning()) {
                return 1;
            }

            return proc1.getEstimatedRunningTime() - proc2.getEstimatedRunningTime();
        });
    }
}
