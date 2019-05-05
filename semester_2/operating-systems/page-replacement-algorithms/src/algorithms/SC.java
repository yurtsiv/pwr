package algorithms;

import request.Request;

import java.util.ArrayList;

// Second Chance
public class SC implements Algorithm {
    @Override
    public void replacePage(ArrayList<Request> memory, ArrayList<Request> requests, Request currentRequest) {
        currentRequest.setSecondChance(true);

        int index = 0;
        Request pageToReplace = null;
        while (index < memory.size() && pageToReplace == null) {
            Request page = memory.get(index);
            if (page.hasSecondChance()) {
                page.setSecondChance(false);
            } else {
                pageToReplace = page;
            }
            index++;
        }

        int setAt = pageToReplace == null ? 0 : memory.indexOf(pageToReplace);
        memory.set(setAt, currentRequest);
    }
}
