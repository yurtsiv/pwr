package main;

public class Player {
    private String name;
    private ScoreTable scoreTable = new ScoreTable();

    public Player (String name) {
        this.name = name;
    }

    public String getName () { return name; }

    public ScoreTable getScoreTable () {
        return scoreTable;
    }

    public void updateScore (int[] turnResult) {
        String category = UserInteraction.selectOption(
                "Which category do you choose?",
                scoreTable.getAvailableFields()
        );

        scoreTable.update(category, turnResult);
    }
}
