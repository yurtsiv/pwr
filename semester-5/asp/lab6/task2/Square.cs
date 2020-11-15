namespace task2
{
    class Square: IFigure, IHasInterior
    {
        public string color { get; set; }

        public Square(string color)
        {
            this.color = color;
        }
    }
}
