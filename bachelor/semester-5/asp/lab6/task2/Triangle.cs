namespace task2
{
    class Triangle: IHasInterior
    {
        public string color { get; set; }

        public Triangle(string color)
        {
            this.color = color;
        }
    }
}
