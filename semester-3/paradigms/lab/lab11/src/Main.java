import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        ArrayList<Player> players = new ArrayList<>();

        for (int i = 0; i < 10 ; i++) {
            Player p = new Player(players, i);
            if (i < 1) {
               p.receiveBall(i);
            }
        }

        for (Player p : players)  {
            p.start();
        }
    }
}
