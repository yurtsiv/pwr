using System;

namespace task1
{
    class MixedNumber
    {
        private int _numerator;
        private int _denominator;

        public int modifiedTimes = 0;
        public int whole { get; set; }

        public int numerator 
        {
            get => _numerator;
            set
            {
                _numerator = value < 0 ? -value : value;

                Simplify();
            }
        }

        public int denominator
        {
            get => _denominator;
            set
            {
                CheckDenominator(value);

                _denominator = value < 0 ? -value : value;
                Simplify();
            }
        }

        public double doubleRepresentation
        {
            get
            {
                return (whole * _denominator + _numerator) / (double)_denominator;
            }
        }

        public MixedNumber(int whole, int numerator, int denominator)
        {
            CheckDenominator(denominator);

            this.whole = whole;
            _numerator = numerator < 0 ? -numerator : numerator;
            _denominator = denominator < 0 ? -denominator : denominator;

            Simplify();
        }

        public MixedNumber(int numerator, int denominator): this(0, numerator, denominator)
        {
        }

        public MixedNumber(int whole) : this(whole, 0, 1)
        {
        }

        public MixedNumber(): this(0)
        {
        }

        private void Simplify()
        {

            if (_numerator == 0) return;

            if (_numerator == _denominator)
            {
                _numerator = 0;
                _denominator = 1;
                whole++;
                modifiedTimes++;
            }
            else if (_numerator > _denominator)
            {
                int prevNumerator = numerator;

                _numerator %= _denominator;
                whole += prevNumerator / _denominator;
                modifiedTimes++;
            }

            int gcd = GreatestCommonDivisor(_denominator, _numerator);
            if (gcd != 1)
            {
                _numerator /= gcd;
                _denominator /= gcd;
                modifiedTimes++;
            }
        }

        public static MixedNumber operator+(MixedNumber a, MixedNumber b)
        {
            int lcm = LeastCommonMultiple(a.denominator, b.denominator);
            int num1 = a.numerator * (lcm / a.denominator);
            int num2 = b.numerator * (lcm / b.denominator);
            MixedNumber res = new MixedNumber(a.whole + b.whole, num1 + num2, lcm);
            res.Simplify();
            return res;
        }

        public override string ToString()
        {
            return $"{whole} {numerator}/{denominator}";
        }

        private static void CheckDenominator(int denominator)
        {
            if (denominator == 0) throw new ArgumentException("Denominator can't be zero");
        }

        private static int LeastCommonMultiple(int a, int b)
        {
            int baseA = a, baseB = b;
            while (a != b)
            {
                if (a > b)
                {
                    b += baseB;
                }
                else
                {
                    a += baseA;
                }
            }
            return a;
        }

        private static int GreatestCommonDivisor(int a, int b)
        {
            if (b == 0)
            {
                return a;
            }

            return GreatestCommonDivisor(b, a % b);
        }

    }
}
