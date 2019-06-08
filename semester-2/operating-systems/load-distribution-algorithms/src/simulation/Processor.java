package simulation;

import java.util.ArrayList;

public class Processor {
    private int load = 0;
    private ArrayList<Process> activeProcs = new ArrayList<>();
    private ArrayList<Processor> allProcs = new ArrayList<>();
    private SimulationConfig config;


    public void addProcess(Process process) {
        int procLoad = process.getLoad();
        if (load + procLoad > 100) {
            throw new IllegalArgumentException("Unable to add another process (overload)");
        }

        activeProcs.add(process);
        load += procLoad;
    }

    public void addProcessByAlgorithm(Process process, SimulationConfig config) {

    }

    public void setAllProcs(ArrayList<Processor> procs) {
        allProcs = procs;
    }

    public void setSimulationConfig(SimulationConfig config) {
        this.config = config;
    }

    public int getLoad() {
        return load;
    }
}
