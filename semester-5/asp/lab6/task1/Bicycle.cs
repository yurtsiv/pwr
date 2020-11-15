using System;

namespace task1
{
    enum BrakeType
    {
        VBrake,
        MechanicalDisk,
        HydraulicDisc
    }

    class Bicycle: Vehicle
    {
        public string frameMaterial { get; set; }
        public BrakeType brakes { get; set; }

        public Bicycle(string manufacturer, string model, double weight, string frameMaterial, BrakeType brakes = BrakeType.VBrake)
        {
            this.manufacturer = manufacturer;
            this.model = model;
            this.weight = weight;
            this.frameMaterial = frameMaterial;
            this.brakes = brakes;
        }

        public override void ride()
        {
            Console.WriteLine($"Bicycle {manufacturer} {model} is riding...");
        }

        private static string getBrakeType(BrakeType hamulec)
        {
            switch (hamulec)
            {
                case BrakeType.VBrake:
                    return "V-Brake";
                case BrakeType.MechanicalDisk:
                    return "Disk, Mechanical";
                case BrakeType.HydraulicDisc:
                    return "Disc, Hydraulic";
                default:
                    return "";
            }
        }

        public override string ToString()
        {
            return $"{base.ToString()}\nTyp: rower\nMaterial ramy: {frameMaterial}\nHamulec: {getBrakeType(brakes)}";
        }
    }
}
