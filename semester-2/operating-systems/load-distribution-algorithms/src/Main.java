import algorithms.Algorithm1;
import algorithms.Algorithm2;
import simulation.*;
import simulation.Process;

import java.util.ArrayList;

public class Main {
    static int
        p = 80,
        r = 10,
        z = 3,
        n = 10,
        processNum = 1000;

    public static void main(String[] args) {
        SimulationConfig config = new SimulationConfig(p, r, z, n);

        Simulation simulation = new Simulation();
        ArrayList<Process> processes = ProcessGenerator.generate(processNum);

        ArrayList<Processor> alg1Result = simulation.run(processes, config, new Algorithm1());
        ArrayList<Processor> alg2Result = simulation.run(processes, config, new Algorithm2());
        System.out.println();
    }
}
