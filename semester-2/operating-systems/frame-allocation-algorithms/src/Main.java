import algorithms.Equal;
import algorithms.PageFaultFrequencyControl;
import algorithms.Proportional;
import algorithms.WorkingSet;
import process.Process;
import process.ProcessGenerator;
import simulation.ResultsAnalyzer;
import simulation.Simulation;
import simulation.SimulationConfig;

import java.util.ArrayList;

public class Main {
    static int
        processesNum = 10,
        maxPage = 100,
        totalMemorySize = 20,
        pageFaultFreqTimeWindow = 5,
        minPageFaultFreqThreshold = 1,
        maxPageFaultFreqThreshold = 3,
        workingSetTimeWindow = 10,
        maxReqSeqLen = 10000;

    public static void main(String[] args) {
        ArrayList<Process> procs = ProcessGenerator.generate(processesNum, maxPage, maxReqSeqLen);
        SimulationConfig simulationConfig = new SimulationConfig(
            totalMemorySize,
            workingSetTimeWindow,
            pageFaultFreqTimeWindow,
            minPageFaultFreqThreshold,
            maxPageFaultFreqThreshold
        );

        ArrayList<Process> equalRes = Simulation.run(new Equal(), procs, simulationConfig);
        ArrayList<Process> proportinalRes = Simulation.run(new Proportional(), procs, simulationConfig);
        ArrayList<Process> pageFaultContRes = Simulation.run(new PageFaultFrequencyControl(), procs, simulationConfig);
        ArrayList<Process> workingSetRes = Simulation.run(new WorkingSet(), procs, simulationConfig);

        ResultsAnalyzer.printResults("Equal", equalRes);
        ResultsAnalyzer.printResults("Proportional", proportinalRes);
        ResultsAnalyzer.printResults("Page fault frequency control", pageFaultContRes);
        ResultsAnalyzer.printResults("Working set", workingSetRes);
    }
}
