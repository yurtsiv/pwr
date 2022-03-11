using System;
					
public class Program
{
	public static (int, int) GetFromConsoleXY(String comment1, String comment2)
	{
		Console.WriteLine(comment1);
		int firstNum;
		while (int.TryParse(Console.ReadLine(), out firstNum))
		{
			Console.WriteLine(comment1);
		}
		
		Console.WriteLine(comment2);
		int secondNum;
		while (int.TryParse(Console.ReadLine(), out secondNum))
		{
			Console.WriteLine(comment2);
		}
		
		return (firstNum, secondNum);
	}
	
	public static void Main()
	{
		Console.WriteLine(GetFromConsoleXY("First", "Second"));
	}
}