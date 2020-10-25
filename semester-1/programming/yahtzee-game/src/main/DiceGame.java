package main;

import java.util.List;
import java.util.ArrayList;

public class DiceGame {
    private Player[] players;
    private int currentTurn = 1, currentPlayerIndex, gameRounds;

    private void initialize () {
        int playersNum;
        String playerName;

        playersNum = UserInteraction.getInt("Number of players (2-4):", 2, 4);
        players = new Player[playersNum];
        for (int i = 0; i < playersNum; i++) {
            playerName = UserInteraction.question("Player " + (i + 1) + ":");
            players[i] = new Player(playerName);
        }

        currentPlayerIndex = 0;
        gameRounds = UserInteraction.getInt("Number of rounds (3-13):", 3, 13);
    }

    private void turn () {
        UserInteraction.printSeparator();

        Player currentPlayer = players[currentPlayerIndex];
        int rollNum = 1;
        Dice diceToRoll = new Dice(5);
        List<Integer> keptDice = new ArrayList<>(), turnResult = new ArrayList<>();
        boolean shouldContinueTurn = true;

        System.out.println(currentPlayer.getName() + "'s turn #" + currentTurn + "\n");

        while (shouldContinueTurn && rollNum <= 3) {
            System.out.println("\nRoll #" + rollNum + "\n");

            if (keptDice.size() != 0) {
                System.out.print("Kept dice: ");
                Dice.printArbitrary(keptDice);
                if (UserInteraction.yesNoQuestion("Do you want to take some kept dice?")) {
                    int[] diceIndexesToTake = UserInteraction.getIntArray("Select dice you want to take:");
                    for (int indexToTake : diceIndexesToTake) {
                        keptDice.remove(indexToTake - 1);
                    }

                    diceToRoll.setNumber(diceToRoll.getNumber() + diceIndexesToTake.length);
                }
            }

            diceToRoll.roll();
            System.out.print("Roll result: ");
            diceToRoll.print();

            if (rollNum != 3) {
                shouldContinueTurn = UserInteraction.yesNoQuestion("Do you want to continue your turn?");
                if (shouldContinueTurn) {
                    if (UserInteraction.yesNoQuestion("Do you want to keep any dice?")) {
                        int[] diceIndexesToKeep = UserInteraction.getIntArray("Select dice you want to keep:");
                        keptDice.addAll(ArrayUtils.takeIndexes(diceIndexesToKeep, diceToRoll.getState()));
                        diceToRoll.setNumber(diceToRoll.getNumber() - diceIndexesToKeep.length);
                    }
                }
            }

            rollNum++;
        }

        // add remaining results to turn result
        turnResult.addAll(keptDice);
        for (int die : diceToRoll.getState()) {
            turnResult.add(die);
        }

        System.out.print("Your turn is finished. Result: ");
        Dice.printArbitrary(turnResult);

        currentPlayer.updateScore(turnResult.stream().mapToInt(Integer::intValue).toArray());

        if (players.length - 1 == currentPlayerIndex) {
            currentPlayerIndex = 0;
            currentTurn++;
        } else {
            currentPlayerIndex++;
        }
    }

    private Player[] getPlayers() { return players; }

    private int getRounds() { return gameRounds; }

    public static void main(String[] args) {
	    DiceGame game = new DiceGame();
	    game.initialize();

        for (int i = 0; i < game.getRounds() * game.getPlayers().length; i++) {
            game.turn();
        }

	    System.out.println("\n---- Game finished -----\n");
        Player winner = game.getPlayers()[0];
        for (Player player : game.getPlayers()) {
            System.out.println(player.getName() + " 's results:\n");
            player.getScoreTable().print();
            int totalScore = player.getScoreTable().getTotal();
            System.out.println("\nTotal score: " + totalScore);
            UserInteraction.printSeparator();
            if (totalScore > winner.getScoreTable().getTotal()) {
                winner = player;
            }
        }

        System.out.println(winner.getName() + " wins!");
    }
}
