package simulation;

import process.Process;

import java.util.ArrayList;

public class ResultsAnalyzer {
    private static int calcTotalPageFaults(ArrayList<Process> procs) {
        int res = 0;
        for (Process proc : procs) {
            res += proc.getPageReplacements();
        }
        return res;
    }

    private static int calcTotalReqSeqLen(ArrayList<Process> procs) {
        int res = 0;
        for (Process proc : procs) {
            res += proc.getOrignalReqSeqLen();
        }
        return res;
    }


    public static void printResults(String title, ArrayList<Process> procs) {
        System.out.println("-----------------------");
        System.out.println(title);
        System.out.println("Total page faults: " + calcTotalPageFaults(procs));
        System.out.println("Global requests sequence length: " + calcTotalReqSeqLen(procs));
        System.out.println("Processes info:");
        int i = 0;
        for (Process proc : procs) {
            System.out.println("- Process #" + i);
            System.out.println("  Page range: " + proc.getMinPage() + " - " + proc.getMaxPage());
            System.out.println("  Requests sequence length: " + proc.getOrignalReqSeqLen());
            System.out.println("  Page faults: " + proc.getPageReplacements());
            System.out.println("  Memory size: " + proc.getMemory().size());
           i++;
        }
    }
}
