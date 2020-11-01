package algorithms.pageReplacement;

import process.Request;

import java.util.ArrayList;

public interface PageReplaceAlgorithm {
    void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest);
}
