package simulation;

public class SimulationConfig {
    public int memorySize;
    public double minPageFaultFreqThreshold, maxPageFaultFreqThreshold;

    public SimulationConfig(int memorySize, double minPageFaultThreshold, double maxPageFaultThreshold) {
        this.memorySize = memorySize;
        this.minPageFaultFreqThreshold = minPageFaultThreshold;
        this.maxPageFaultFreqThreshold = maxPageFaultThreshold;
    }
}
