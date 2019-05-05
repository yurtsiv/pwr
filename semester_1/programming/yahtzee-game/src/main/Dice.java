package main;

import java.util.Random;
import java.util.List;

public class Dice {
    private int number, sides;
    private Random random = new Random();
    private int[] state;

    public Dice(int number, int sides, int mod) {
        this.number = number;
        this.sides = sides;
    }

    public Dice(int number) {
        this.number = number;
        this.sides = 6;
    }

    public void roll () {
        int[] result = new int[this.number];
        for (int i = 0; i < this.number; i++) {
            result[i] = this.random.nextInt(this.sides) + 1;
        }

        this.state = result;
    }

    public int[] getState() {
        return this.state;
    }

    public void setNumber(int newNumber) {
        this.state = new int[newNumber];
        this.number = newNumber;
    }

    public int getNumber() { return this.number; }

    public void print () {
        System.out.println();
        for (int i = 0; i < state.length; i++) {
            System.out.println((i + 1) + ". " + (state[i]));
        }
        System.out.println();
    }

    public static void printArbitrary (List<Integer> dice) {
        System.out.println();
        for (int i = 0; i < dice.size(); i++) {
            System.out.println((i + 1) + ". " + (dice.get(i)));
        }
        System.out.println();
    }
}
