package process;

public class Request {
    private int page, lastUsed;

    public Request(int page) {
        this.page = page;
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
