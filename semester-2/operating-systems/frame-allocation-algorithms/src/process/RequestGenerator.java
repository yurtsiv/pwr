package process;

import utils.RandomNums;
import java.util.ArrayList;

public class RequestGenerator {
    public static ArrayList<Request> generate(int seqLen, int minPageNum, int maxPageNum) {
        ArrayList<Request> result = new ArrayList<>();
        ArrayList<Integer> seq = RandomNums.getSequnce(seqLen, minPageNum, maxPageNum);

        ArrayList<Request> allPossibleRequests = new ArrayList<>();
        for (int i = 0; i <= maxPageNum - minPageNum; i++) {
            allPossibleRequests.add(new Request(minPageNum + i));
        }

        for (int nextPage : seq) {
            result.add(allPossibleRequests.get(maxPageNum - nextPage));
        }

        return result;
    }
}

