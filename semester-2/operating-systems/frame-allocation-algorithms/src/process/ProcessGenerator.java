package process;

import utils.RandomNums;

import java.util.ArrayList;

public class ProcessGenerator {
    public ArrayList<Process> generate(int processNum, int maxPage, int maxReqSeqLen) {
        ArrayList<Integer> pageRanges = new ArrayList<>();
        int maxRange = (maxPage / processNum) + 2;
        int prevRangeEnd = 0;
        for (int i = 0; i < processNum; i++) {
            int newRangeEnd = RandomNums.randomInt(prevRangeEnd, prevRangeEnd + maxRange);
            pageRanges.add(prevRangeEnd);
            prevRangeEnd = newRangeEnd;
        }

        ArrayList<Process> result = new ArrayList<>();
        for (int i = 0; i < processNum; i++) {
            Process newProc = null;
            if (i == 0) {
                newProc = new Process(0, pageRanges.get(0), maxReqSeqLen);
            } else {
                newProc = new Process(pageRanges.get(i - 1), pageRanges.get(i), maxReqSeqLen);
            }

            result.add(newProc);
        }

        return result;
    }
}
