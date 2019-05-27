package process;

import utils.RandomNums;

import java.util.ArrayList;

public class ProcessGenerator {
    public static ArrayList<Process> generate(int processNum, int maxPage, int maxReqSeqLen) {
        ArrayList<Integer> pageRanges = new ArrayList<>();

        int maxRange = (maxPage / processNum);
        int rangesSum = 0;
        for (int i = 0; i < processNum / 2; i++) {
            int newRange = RandomNums.randomInt(1, maxRange * 2);
            pageRanges.add(newRange);
            rangesSum += newRange;
        }
        for (int i = processNum / 2; i < processNum - 1; i++) {
            int newRange = RandomNums.randomInt(1, maxRange);
            pageRanges.add(newRange);
            rangesSum += newRange;
        }
        pageRanges.add(maxPage - rangesSum);

        ArrayList<Process> result = new ArrayList<>();
        int prevMaxPage = 0;
        for (int i = 0; i < processNum; i++) {
            int newMaxPage = prevMaxPage + pageRanges.get(i);
            Process newProc = new Process(prevMaxPage, newMaxPage, maxReqSeqLen);
            result.add(newProc);
            prevMaxPage = newMaxPage;
        }

        return result;
    }
}
