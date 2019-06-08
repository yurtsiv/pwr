import algorithms.Algorithm1;
import simulation.*;
import simulation.Process;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class Main {
    static int
        p = 3,
        r = 10,
        z = 10,
        n = 50,
        processNum = 1000;

    public static void main(String[] args) {
        SimulationConfig config = new SimulationConfig(p, r, z, n);

        Simulation simulation = new Simulation();
        ArrayList<Process> processes = ProcessGenerator.generate(processNum);

        ArrayList<Processor> alg1Result = simulation.run(processes, config, new Algorithm1());
    }
}
