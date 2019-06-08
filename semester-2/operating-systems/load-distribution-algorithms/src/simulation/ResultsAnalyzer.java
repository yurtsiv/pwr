package simulation;

import java.util.ArrayList;

public class ResultsAnalyzer {
    private static double getAverageLoadOfProcessor(Processor processor) {
        return processor
            .getLoadHistory()
            .stream()
            .distinct()
            .mapToInt((x) -> x)
            .average()
            .orElse(0);
    }

    private static double getAverageLoad(ArrayList<Processor> processors) {
        return processors
            .stream()
            .map(processor -> getAverageLoadOfProcessor(processor))
            .mapToDouble((x) -> x)
            .average()
            .orElse(0);
    }

    private static double getLoadStandardDeviation(ArrayList<Processor> processes, double averageLoad) {
        double deviation = 0;
        for (Processor proc : processes) {
            deviation += Math.pow(getAverageLoadOfProcessor(proc) - averageLoad, 2);
        }

        return Math.sqrt(deviation / processes.size());
    }

    private static int sumLoadStateRequests(ArrayList<Processor> processors) {
        return processors
            .stream()
            .map(Processor::getLoadStateRequests)
            .reduce(0, Integer::sum);
    }

    private static int sumMigrations(ArrayList<Processor> processors) {
        return processors
                .stream()
                .map(Processor::getMigrations)
                .reduce(0, Integer::sum);
    }

    public static void printResults(ArrayList<Processor> processors) {
        double averageLoad = getAverageLoad(processors);
        System.out.println("Average load: " + averageLoad);
        System.out.println("Standard deviation: " + getLoadStandardDeviation(processors, averageLoad));
        System.out.println("Load state requests: " + sumLoadStateRequests(processors));
        System.out.println("Migrations: " + sumMigrations(processors));
    }
}
