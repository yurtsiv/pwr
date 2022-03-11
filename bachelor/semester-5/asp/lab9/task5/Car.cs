using System;

namespace task5
{
    class Car: Vehicle
    {
        public int doorsNum { get; set; }
        public double maxLoad { get; set; }

        public Car(string manufacturer, string model, double weight, double maxLoad, int doorsNum = 5)
        {
            this.manufacturer = manufacturer;
            this.model = model;
            this.weight = weight;
            this.maxLoad = maxLoad;
            this.doorsNum = doorsNum;
        }

        public void beep()
        {
            Console.WriteLine($"{manufacturer} {model} says 'Beeeeeep...'");
        }

        override public void ride() {
            Console.WriteLine($"Vehicle {manufacturer} {model} is riding...");  
        }

        public override string ToString()
        {
            return $"{base.ToString()}Max load: {maxLoad}kg\nDoors: {doorsNum}\n";
        }
    }
}
