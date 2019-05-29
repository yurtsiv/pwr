package simulation;

public class SimulationConfig {
    public int memorySize, timeWindowSize;
    public double minPageFaultFreqThreshold, maxPageFaultFreqThreshold;

    public SimulationConfig(int memorySize, int timeWindowSize, double minPageFaultThreshold, double maxPageFaultThreshold) {
        this.memorySize = memorySize;
        this.minPageFaultFreqThreshold = minPageFaultThreshold;
        this.maxPageFaultFreqThreshold = maxPageFaultThreshold;
        this.timeWindowSize = timeWindowSize;
    }
}
