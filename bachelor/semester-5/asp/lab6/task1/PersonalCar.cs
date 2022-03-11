using System;

namespace task1
{
    class PersonalCar : Car
    {
        public double trunkLoaded { get; private set; }
        private int _seatsNum;
        public int seatsNum
        {
            get => _seatsNum;
            set
            {
                if (value < 0)
                    throw new ArgumentException("Invalid seats number");

                _seatsNum = value;
            }
        }
        private double _trunkVolume;
        public double trunkVolume
        {
            get => _trunkVolume;
            set
            {
                if (value < 0)
                    throw new ArgumentException("Ivalid trunk volume");

                _trunkVolume = value;
            }
        }

        public PersonalCar(string manufacturer, string model, double weight, double maxLoad, double trunkVolume, int seatsNum = 4):
            base(manufacturer, model, weight, maxLoad)
        {
            _seatsNum = seatsNum;
            _trunkVolume = trunkVolume;
        }

        public void putIntoTrunk(double objetosc)
        {
            if ((trunkLoaded + objetosc) > _trunkVolume)
                throw new ArgumentException("Does not fit");

            trunkLoaded += objetosc;
        }

        public override string ToString()
        {
            string loadedPercent = string.Format("{0:0.0}", (trunkLoaded / trunkVolume) * 100);
            return $"{base.ToString()}Type: personal car\nSeats: {seatsNum}\nTrunk load: {loadedPercent}%";
        }
    }
}
