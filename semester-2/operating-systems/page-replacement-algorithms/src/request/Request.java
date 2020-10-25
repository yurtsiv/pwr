package request;

public class Request {
    private int page, lastUsed;
    private boolean hasSecondChance = false;

    public Request(int page) {
        this.page = page;
    }


    public void setSecondChance(boolean hasSecondChance) {
        this.hasSecondChance = hasSecondChance;
    }

    public boolean hasSecondChance() {
        return hasSecondChance;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        Request req = (Request)obj;
        return page == req.getPage();
    }

    public int getPage() {
        return page;
    }

    public int getLastUsed() {
        return lastUsed;
    }

    public void setLastUsed(int lastUsed) {
        this.lastUsed = lastUsed;
    }

    public Request clone() {
        Request res = new Request(page);
        res.setLastUsed(lastUsed);
        return res;
    }
}
