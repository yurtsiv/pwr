package request;

import util.RandomNums;

import java.util.ArrayList;

public class RequestsGenerator {
    public static ArrayList<Request> getSeries(int seriesLen, int maxAddress, int maxArrivalTime, int priorityReqs) {
        ArrayList<Request> res = new ArrayList<>();

        int zeroArrivalTimeRequests = RandomNums.randomInt(0, seriesLen / 3);
        for (int i = 0; i < seriesLen; i++) {
            int diskLocation = RandomNums.randomInt(1, maxAddress);
            int arrivalTime = i <= zeroArrivalTimeRequests ? 0 : RandomNums.randomInt(0, maxArrivalTime);
            Request newReq = new Request(i, diskLocation, arrivalTime);
            if (i < priorityReqs) {
                newReq.setPriority(RandomNums.randomInt(0, 10));
            }

            res.add(newReq);
        }

        return res;
    }
}
