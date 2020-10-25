import algorithms.*;
import request.Request;
import request.RequestsGenerator;
import simulation.Simulation;

import java.util.ArrayList;

public class Main {
    static int memorySegments = 4,
               requestsNumber = 10,
               pagesNumber = 5;

    public static void main(String[] args) {
        Simulation simulation = new Simulation();
        ArrayList<Request> requests = RequestsGenerator.generate(requestsNumber, pagesNumber);
        System.out.println(requests);

        int scRes = simulation.run(new SC(), requests, memorySegments);
        int lruRes = simulation.run(new LRU(), requests, memorySegments);
        int fifoRes = simulation.run(new FIFO(), requests, memorySegments);
        int randRes = simulation.run(new RAND(), requests, memorySegments);
        int optRes = simulation.run(new OPT(), requests, memorySegments);


        System.out.println("FIFO: " + fifoRes);
        System.out.println("RAND: " + randRes);
        System.out.println("OPT: " + optRes);
        System.out.println("LRU: " + lruRes);
        System.out.println("SC: " + scRes);
    }
}
