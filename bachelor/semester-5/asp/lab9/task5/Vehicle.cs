using System;

namespace task5
{
    abstract class Vehicle
    {
        private double _weight = 0;
        public double weight
        {
            get => _weight;
            set
            {
                if (value < 0)
                    throw new ArgumentException("Weight can't be negative");

                _weight = value;
            }
        }
        public string manufacturer { get; set; }
        public string model { get; set; }

        public abstract void ride();

        public override string ToString()
        {
            return $"Vehicle: {manufacturer} {model}\nWeight: {weight}kg\n";
        }
    }
}
