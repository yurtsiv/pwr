package simulation;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class Processor {
    private ArrayList<Integer> loadHistory = new ArrayList<>();
    private ArrayList<Process> processes = new ArrayList<>();
    private int migrations = 0, loadStateRequests = 0;

    public void addProcess(Process process) {
        int currentLoad = getLoad();
        int procLoad = process.getLoad();
        if (currentLoad + procLoad > 100) {
            throw new IllegalArgumentException("Unable to add another process (overload)");
        }

        processes.add(process);
    }

    public Process popProcess() {
        int lastIndex = processes.size() - 1;
        if (lastIndex < 0) {
            throw new RuntimeException("Can't pop a process. The queue is empty.");
        }

        Process res = processes.get(lastIndex);
        processes.remove(lastIndex);
        migrations++;
        return res;
    }

    public int getLoad() {
        loadStateRequests++;
        return processes
                .stream()
                .map(proc -> proc.getLoad())
                .reduce(0, Integer::sum);
    }

    public Processor clone() {
        return new Processor();
    }

    public void tick() {
        processes.forEach(process -> process.decrementRemainingTime());
        processes = processes
                .stream()
                .filter(process -> process.getRemainingTime() != 0)
                .collect(Collectors.toCollection(ArrayList::new));

        loadHistory.add(getLoad());
    }

    public ArrayList<Integer> getLoadHistory() {
        return loadHistory;
    }

    public int getMigrations() {
        return migrations;
    }

    public int getLoadStateRequests() {
        return loadStateRequests;
    }
}
