package simulation;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class Processor {
    private ArrayList<Integer> loadHistory = new ArrayList<>();
    private ArrayList<Process> processes = new ArrayList<>();
    private int servedProcs = 0;

    public void addProcess(Process process) {
        int currentLoad = getLoad();
        int procLoad = process.getLoad();
        if (currentLoad + procLoad > 100) {
            throw new IllegalArgumentException("Unable to add another process (overload)");
        }

        servedProcs++;
        processes.add(process);
    }

    public int getLoad() {
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
}
