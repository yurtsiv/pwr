package simulation;

public class SimulationConfig {
    public int
        memorySize,
        workingSetTimeWindow,
        pageFaultFreqTimeWindow,
        minPageFaultFreqThreshold,
        maxPageFaultFreqThreshold;

    public SimulationConfig(
        int memorySize,
        int workingSetTimeWindow,
        int pageFaultFreqTimeWindow,
        int minPageFaultThreshold,
        int maxPageFaultThreshold)
    {
        this.memorySize = memorySize;
        this.pageFaultFreqTimeWindow = pageFaultFreqTimeWindow;
        this.workingSetTimeWindow = workingSetTimeWindow;
        this.minPageFaultFreqThreshold = minPageFaultThreshold;
        this.maxPageFaultFreqThreshold = maxPageFaultThreshold;
    }
}
