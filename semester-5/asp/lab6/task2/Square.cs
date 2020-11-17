namespace task2
{
    class Square: IFigure, IHasInterior
    {
        public double x { get; set; } = 0;
        public double y { get; set; } = 0;

        string IHasInterior.color { get; set; }

        public Square(string color)
        {

            ((IHasInterior)this).color = color;
        }

        public void moveTo(double x, double y)
        {
            this.x = x;
            this.y = y;
        }
    }
}
