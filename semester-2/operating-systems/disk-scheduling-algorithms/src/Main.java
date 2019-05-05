import request.Request;
import request.RequestsGenerator;
import scheduler.*;
import util.RandomNums;
import util.ResultsAnalyzer;
import java.util.ArrayList;

public class Main {
    private static final int
        seriesLength = 10,
        maxDiskLocation = 100,
        maxArrivalTime = 10,
        priorityRequests = 10;


    private static void printRequests(ArrayList<Request> requests) {
        System.out.println("Generated requests:");
        requests.sort((req1, req2) -> req1.getArrivalTime() - req2.getArrivalTime());
        for (Request request : requests) {
            System.out.println(
                "ID: " + request.getId() +
                "; Time: " + request.getArrivalTime() +
                "; Address: " + request.getDiskLocation() +
                "; Priority: " + request.getPriority()
            );
            System.out.println("-----------");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        ArrayList<Request> generatedSeries = RequestsGenerator.getSeries(
            seriesLength,
            maxDiskLocation,
            maxArrivalTime,
            priorityRequests
        );

        printRequests(generatedSeries);

        Scheduler scheduler = new Scheduler();

        int initialHeadPosition = RandomNums.randomInt(0, maxDiskLocation);
        System.out.println("Initial head position: " + initialHeadPosition + "\n");

        ArrayList<Integer> fcfsResult = scheduler.run(generatedSeries, initialHeadPosition, new FCFS());
        ArrayList<Integer> sstfResult = scheduler.run(generatedSeries, initialHeadPosition, new SSTF());
        ArrayList<Integer> scanResult = scheduler.run(generatedSeries, initialHeadPosition, new SCAN());
        ArrayList<Integer> cscanResult = scheduler.run(generatedSeries, initialHeadPosition, new CSCAN());
        ArrayList<Integer> edfResult = scheduler.run(generatedSeries, initialHeadPosition, new EDF());
        ArrayList<Integer> fdscanResult = scheduler.run(generatedSeries, initialHeadPosition, new FDSCAN());

        System.out.println("\n-- FCFS result --");
        ResultsAnalyzer.analyzeAndPrint(fcfsResult);

        System.out.println("\n-- SSTF result --");
        ResultsAnalyzer.analyzeAndPrint(sstfResult);

        System.out.println("\n-- SCAN result --");
        ResultsAnalyzer.analyzeAndPrint(scanResult);

        System.out.println("\n-- C-SCAN result --");
        ResultsAnalyzer.analyzeAndPrint(cscanResult);

        System.out.println("\n-- EDF result --");
        ResultsAnalyzer.analyzeAndPrint(edfResult);

        System.out.println("\n-- FD-SCAN result --");
        ResultsAnalyzer.analyzeAndPrint(fdscanResult);
    }
}
