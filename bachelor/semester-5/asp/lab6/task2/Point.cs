namespace task2
{
    class Point : IFigure
    {
        public double x { get; set; } = 0;
        public double y { get; set; } = 0;

        public void moveTo(double x, double y)
        {
            this.x = x;
            this.y = y;
        }
    }
}
