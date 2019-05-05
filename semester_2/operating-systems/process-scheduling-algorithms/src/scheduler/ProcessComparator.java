package scheduler;

import processes.Process;

public interface ProcessComparator {
    int compare(Process proc1, Process proc2);
}
