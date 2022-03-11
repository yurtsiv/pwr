import java.io.File;
import java.util.Scanner; 

class Task2 {
	public static void main(String[] args) {
		try {
			File covidFile = new File("Covid.txt");
			Scanner fileReader = new Scanner(covidFile);
			int totalCases = 0;

			fileReader.nextLine();
			while (fileReader.hasNextLine()) {
				String line = fileReader.nextLine();
				
				totalCases += Integer.parseInt(line.split("\t")[4]);
			}
			fileReader.close();

			System.out.println(totalCases);
		} catch (Exception e) {
			System.out.println("An error occurred.");
			e.printStackTrace();
		}
	}
}
