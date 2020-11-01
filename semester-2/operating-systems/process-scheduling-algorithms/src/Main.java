import processes.Process;
import processes.ProcessesGenerator;
import processes.ResultsAnalyzer;
import scheduler.*;

import java.util.ArrayList;

public class Main {
    private static int
        numberOfSeries = 100,
        seriesLength = 50,
        maxRunningTime = 1000,
        maxStartTime = 50,
        rotQuantum = 10;

    private static void printProcSeries(ArrayList<Process> procSeries) {
        for (Process proc : procSeries) {
            System.out.println("----------------");
            System.out.format("ID: %12d \n", proc.getId());
            System.out.format("Running time: %d \n", proc.getEstimatedRunningTime());
            System.out.format("Start time: %4d \n", proc.getStartTime());
        }
    }

    private static void printSeriesResult(int fcfs, int sjfNonPree, int sjfPree, int rot) {
        System.out.format("FCFS: %20d \n", fcfs);
        System.out.format("SJF (non-preemptive): %d\n", sjfNonPree);
        System.out.format("SJF (preemptive): %8d \n",  sjfPree);
        System.out.format("ROT: %21d\n", rot);
    }

    public static void main(String[] args) {
        ArrayList<Integer> fcfsWaitingTimes = new ArrayList<>();
        ArrayList<Integer> sjfNonPreemptiveWaitingTimes = new ArrayList<>();
        ArrayList<Integer> sjfPreemptiveWaitingTimes = new ArrayList<>();
        ArrayList<Integer> rotWaitingTimes = new ArrayList<>();

        for (int i = 0; i < numberOfSeries; i++) {
            ArrayList<Process> procSeries = ProcessesGenerator.getSeries(seriesLength, maxRunningTime, maxStartTime);
            System.out.println("=========================================");
            System.out.println("Process series #" + i);
            System.out.println("=========================================");
            printProcSeries(procSeries);

            Scheduler scheduler = new Scheduler();

            ArrayList<Process> fcfsRes = scheduler.run(procSeries, new FCFS());
            ArrayList<Process> sjfNonPreemptiveRes = scheduler.run(procSeries, new SJFNonPreemptive());
            ArrayList<Process> sjfPreemptiveRes = scheduler.run(procSeries, new SJFPreemptive());
            ArrayList<Process> rotRes = scheduler.run(procSeries, new ROT(rotQuantum));


            int fcfsWaitingTime = ResultsAnalyzer.averageWaitingTime(fcfsRes);
            int sjfNonPreemptiveWaitingTime = ResultsAnalyzer.averageWaitingTime(sjfNonPreemptiveRes);
            int sjfPreemptiveWaitingTime = ResultsAnalyzer.averageWaitingTime(sjfPreemptiveRes);
            int rotWaitingTime = ResultsAnalyzer.averageWaitingTime(rotRes);

            fcfsWaitingTimes.add(fcfsWaitingTime);
            sjfNonPreemptiveWaitingTimes.add(sjfNonPreemptiveWaitingTime);
            sjfPreemptiveWaitingTimes.add(sjfPreemptiveWaitingTime);
            rotWaitingTimes.add(rotWaitingTime);

            System.out.println("-----------------------------------------");
            System.out.println("Series #" + i + " results:");
            printSeriesResult(fcfsWaitingTime, sjfNonPreemptiveWaitingTime, sjfPreemptiveWaitingTime, rotWaitingTime);
            System.out.println("-----------------------------------------");
        }


        System.out.println("//////////////  END  //////////////");
        System.out.println("Average waiting times:");
        printSeriesResult(
            ResultsAnalyzer.averageArithmetic(fcfsWaitingTimes),
            ResultsAnalyzer.averageArithmetic(sjfNonPreemptiveWaitingTimes),
            ResultsAnalyzer.averageArithmetic(sjfPreemptiveWaitingTimes),
            ResultsAnalyzer.averageArithmetic(rotWaitingTimes)
        );

    }
}
