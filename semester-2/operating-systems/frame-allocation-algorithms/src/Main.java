import algorithms.Equal;
import process.Process;
import process.ProcessGenerator;
import simulation.Simulation;

import java.util.ArrayList;

public class Main {
    static int
        processesNum = 10,
        maxPage = 100,
        totalMemorySize = 20,
        maxReqSeqLen = 1000;

    public static void main(String[] args) {
        ArrayList<Process> procs = ProcessGenerator.generate(processesNum, maxPage, maxReqSeqLen);
        ArrayList<Process> equalRes = Simulation.run(new Equal(), procs, totalMemorySize);
        System.out.println();
    }
}
