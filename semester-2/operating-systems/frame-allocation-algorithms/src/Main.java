import process.Process;
import process.ProcessGenerator;

import java.util.ArrayList;

public class Main {
    static int
        processesNum = 10,
        maxPage = 100,
        totalMemorySize = 10,
        maxReqSeqLen = 1000;


    public static void main(String[] args) {
        ArrayList<Process> proc = ProcessGenerator.generate(processesNum, maxPage, maxReqSeqLen);
        System.out.println();
    }
}
