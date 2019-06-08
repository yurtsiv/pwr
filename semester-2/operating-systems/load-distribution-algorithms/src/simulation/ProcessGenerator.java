package simulation;

import utils.RandomNums;

import java.util.ArrayList;

public class ProcessGenerator {
    public static ArrayList<Process> generate(int length) {
       ArrayList<Process> result = new ArrayList<>();
       for (int i = 0; i < length; i++) {
           int load = RandomNums.getInt(1, 20);
           int time = RandomNums.getInt(2, 20);
           result.add(new Process(load, time));
       }
       return result;
    }
}
