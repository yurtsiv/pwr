using System;
using System.Linq;
using System.Reflection;
using static System.Console;

namespace task5
{
    class Task
    {
        public double CalcTotalMaxLoad(Vehicle[] vehicles)
        {
            return vehicles.Sum(v => v is Car ? (v as Car).maxLoad : 0);
        }
        public void Solve()
        {
            Car car1 = new Car("Nissan", "Juke", 1300, 1670); ;
            Car car2 = new Car("Toyota", "Corolla", 1190, 945);

            Bicycle bicycle1 = new Bicycle("Pride", "ROCX Tour", 14, "stal", BrakeType.MechanicalDisk);
            Bicycle bicycle2 = new Bicycle("Jamis", "Durango", 14.8, "stal", BrakeType.HydraulicDisc);

            PersonalCar personalCar1 = new PersonalCar("Fiat", "Grande Punto", 1030, 800, 275);
            PersonalCar personalCar2 = new PersonalCar("Volskwagen", "Golf 5", 1164, 1500, 350);

            Truck truck1 = new Truck("IVECO", "EUROCARGO", 15000, 26000, "różne", 2.36);
            Truck truck2 = new Truck("MAN", "TGA26", 15000, 44000, "drewno", 3.4);

            Vehicle[] vehicles = {
                car1,
                car2,
                bicycle1,
                bicycle2,
                personalCar1,
                personalCar2,
                truck1,
                truck2
            };

            foreach (var v in vehicles)
            {
                WriteLine(v);
                WriteLine();
            }

            MethodInfo methodInfo = GetType().GetMethod("CalcTotalMaxLoad");
            double result = (double)methodInfo.Invoke(this, new object[] { vehicles });

            WriteLine($"\nTotal load (regular):    {CalcTotalMaxLoad(vehicles)}");
            WriteLine($"Total load (reflection): {result}");
        }
    }

    static class Program
    {
        static void PrintInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static void Main(string[] args)
        {
            PrintInfo();
            WriteLine();

            new Task().Solve();
        }
    }
}
