import algorithms.Equal;
import algorithms.PageFaultFrequencyControl;
import algorithms.Proportional;
import process.Process;
import process.ProcessGenerator;
import simulation.Simulation;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Main {
    static int
        processesNum = 5,
        maxPage = 50,
        totalMemorySize = 20,
        maxReqSeqLen = 1000;
    static double
        minPageFaultFreqThreshold = 0.2,
        maxPageFaultFreqThreshold = 0.8;

    public static void main(String[] args) {
        ArrayList<Process> procs = ProcessGenerator.generate(processesNum, maxPage, maxReqSeqLen);
        SimulationConfig simulationConfig = new SimulationConfig(
            totalMemorySize,
            minPageFaultFreqThreshold,
            maxPageFaultFreqThreshold
        );

        ArrayList<Process> equalRes = Simulation.run(new Equal(), procs, simulationConfig);
        ArrayList<Process> proportinalRes = Simulation.run(new Proportional(), procs, simulationConfig);
        ArrayList<Process> pageFaultContRes = Simulation.run(new PageFaultFrequencyControl(), procs, simulationConfig);

        System.out.println();
    }
}
