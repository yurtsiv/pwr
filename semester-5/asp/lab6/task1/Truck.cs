using System;

namespace task1
{
    class Truck : Car
    {
        private double _height;
        public double loadedMass { get; private set; } = 0;
        public string loadType { get; set; } 
        public double height {
            get => _height;
            set
            {
                if (value <= 0)
                    throw new ArgumentException($"Height can't be {value}");

                _height = value;
            }
        }

        public Truck(string manufacturer, string model, double weight, double load, string loadType, double height) :
            base(manufacturer, model, weight, load, 2)
        {
            this.loadType = loadType;
            this.height = height;
        }

        public void load(double weight)
        {
            if ((weight + loadedMass) > maxLoad)
                throw new ArgumentException("Too much");

            loadedMass += weight;
        }
        public override string ToString()
        {
            string zaladowanoProc = string.Format("{0:0.0}", (loadedMass / maxLoad) * 100);
            return $"{base.ToString()}Type: truck\nHeight: {height}\nLoaded: {zaladowanoProc}%";
        }
    }
}
