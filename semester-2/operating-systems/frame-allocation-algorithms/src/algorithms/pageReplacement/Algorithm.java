package algorithms.pageReplacement;

import process.Request;

import java.util.ArrayList;

public interface Algorithm {
    void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest);
}
