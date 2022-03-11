import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner; 

class Task3 {
	public static void main(String[] args) {
		try {
			System.out.println("Country: ");
			Scanner stdIn = new Scanner(System.in);
			String country = stdIn.nextLine();

			File covidFile = new File("Covid.txt");
			Scanner fileReader = new Scanner(covidFile);
			int totalCases = 0;

			fileReader.nextLine();
			while (fileReader.hasNextLine()) {
				String[] row = fileReader.nextLine().split("\t");
		
				if (row[6].equals(country)) {
					totalCases += Integer.parseInt(row[4]);
				}
			}

			fileReader.close();
			stdIn.close();

			System.out.println(totalCases);
		} catch (FileNotFoundException e) {
			System.out.println("An error occurred.");
			e.printStackTrace();
		}
	}
}