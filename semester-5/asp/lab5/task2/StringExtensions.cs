using System;
using System.Linq;

namespace task2
{
    public static class StringExtensions
    {
        public static string SampleExstensionMethod(this String str)
        {
            return string.Join(
                "",
                str.Select((c, index) =>
                {
                    if (!char.IsLetter(c)) return '.';
                    if (index % 2 == 0) return char.ToUpper(c);

                    return char.ToLower(c);
                })
            );
        }
    }
}
