using System;

namespace task1
{
    class Program
    {
        static void printComputerInfo()
        {
            Console.WriteLine("Stepan Yurtsiv, 246437");
            Console.WriteLine($"PC: {Environment.MachineName}\n");
        }

        static double getTotalLoad1(Vehicle[] vehicles)
        {
            double res = 0;
            foreach(Vehicle vehicle in vehicles)
            {
                Car samochod = vehicle as Car;
                if (samochod != null)
                {
                    res += samochod.maxLoad;
                }
            }

            return res;
        }
        static double getTotalLoad2(Vehicle[] vehicles)
        {
            double res = 0;
            foreach(Vehicle vehicle in vehicles)
            {
                if (vehicle is Car)
                {
                    res += ((Car)vehicle).maxLoad;
                }
            }

            return res;
        }

        static void Main(string[] args)
        {
            printComputerInfo();

            Car car1 = new Car("Nissan", "Juke", 1300, 1670); ;
            Car car2 = new Car("Toyota", "Corolla", 1190, 945);

            Bicycle bicycle1 = new Bicycle("Pride", "ROCX Tour", 14, "stal", BrakeType.MechanicalDisk);
            Bicycle bicycle2 = new Bicycle("Jamis", "Durango", 14.8, "stal", BrakeType.HydraulicDisc);

            PersonalCar personalCar1 = new PersonalCar("Fiat", "Grande Punto", 1030, 800, 275);
            PersonalCar personalCar2 = new PersonalCar("Volskwagen", "Golf 5", 1164, 1500, 350);

            Truck truck1 = new Truck("IVECO", "EUROCARGO", 15000, 26000, "różne", 2.36);
            Truck truck2 = new Truck("MAN", "TGA26", 15000, 44000, "drewno", 3.4);

            personalCar1.beep();
            truck2.beep();
            bicycle1.ride();
            car2.ride();
            personalCar2.putIntoTrunk(200);
            truck1.load(2000);

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

            Console.WriteLine("\n-- All vehicles --\n");

            foreach (Vehicle vehicle in vehicles)
            {
                Console.WriteLine(vehicle);
                Console.WriteLine();
            }

            Console.WriteLine($"Total max load (as): {getTotalLoad1(vehicles)}kg");
            Console.WriteLine($"Total max load (is): {getTotalLoad2(vehicles)}kg");
        }
    }
}
