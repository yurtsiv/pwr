import algorithms.Equal;
import algorithms.Proportional;
import process.Process;
import process.ProcessGenerator;
import simulation.Simulation;

import java.util.ArrayList;

public class Main {
    static int
        processesNum = 5,
        maxPage = 50,
        totalMemorySize = 20,
        maxReqSeqLen = 1000;

    public static void main(String[] args) {
        ArrayList<Process> procs = ProcessGenerator.generate(processesNum, maxPage, maxReqSeqLen);
        ArrayList<Process> equalRes = Simulation.run(new Equal(), procs, totalMemorySize);
        ArrayList<Process> proportinalRes = Simulation.run(new Proportional(), procs, totalMemorySize);
        System.out.println();
    }
}
