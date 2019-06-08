import algorithms.Algorithm1;
import algorithms.Algorithm2;
import algorithms.Algorithm3;
import simulation.*;
import simulation.Process;

import java.util.ArrayList;

public class Main {
    static int
        p = 70,
        r = 10,
        z = 3,
        n = 10,
        processNum = 10000;

    public static void main(String[] args) {
        SimulationConfig config = new SimulationConfig(p, r, z, n);

        Simulation simulation = new Simulation();
        ArrayList<Process> processes = ProcessGenerator.generate(processNum);

        ArrayList<Processor> alg1Result = simulation.run(processes, config, new Algorithm1());
        ArrayList<Processor> alg2Result = simulation.run(processes, config, new Algorithm2());
        ArrayList<Processor> alg3Result = simulation.run(processes, config, new Algorithm3());

        System.out.println("\nALGORITHM 1:");
        ResultsAnalyzer.printResults(alg1Result);
        System.out.println("\nALGORITHM 2:");
        ResultsAnalyzer.printResults(alg2Result);
        System.out.println("\nALGORITHM 3:");
        ResultsAnalyzer.printResults(alg3Result);
    }
}
