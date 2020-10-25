package request;

import random.RandomNums;

import java.util.ArrayList;

public class RequestsGenerator {
    public static ArrayList<Request> generate(int seqLen, int maxPageNum) {
        ArrayList<Request> result = new ArrayList<>();
        ArrayList<Integer> seq = new ArrayList<>(); //RandomNums.getSequnce(seqLen, 0, maxPageNum);
        seq.add(1);
        seq.add(2);
        seq.add(3);
        seq.add(4);
        seq.add(1);
        seq.add(2);
        seq.add(5);
        seq.add(1);
        seq.add(2);
        seq.add(3);
        seq.add(4);
        seq.add(5);

        ArrayList<Request> allPossibleRequests = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            allPossibleRequests.add(new Request(i));
        }

        for (int nextPage : seq) {
            result.add(allPossibleRequests.get(nextPage-1));
        }

        return result;
    }
}
