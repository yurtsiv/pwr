using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.Text;
using System.Threading.Tasks;
using WcfServiceContract1;

namespace WcfServiceHost1
{
    class Program
    {
        static void Main(string[] args)
        {
            Uri baseAddress = new Uri("http://localhost:10000/MyCalculator");
            ServiceHost myHost = new ServiceHost(typeof(MyCalculator), baseAddress);

            WSHttpBinding myBinding = new WSHttpBinding();

            ServiceEndpoint endpoint = myHost.AddServiceEndpoint(typeof(ICalculator), myBinding, "endpoint1");

            ServiceMetadataBehavior smb = new ServiceMetadataBehavior();
            smb.HttpGetEnabled = true;
            myHost.Description.Behaviors.Add(smb);

            try
            {
                myHost.Open();
                Console.WriteLine("Serwis jest uruchomiony.");
                Console.WriteLine("Necisnij <ENTER> aby zakonczyc.");
                Console.WriteLine();
                Console.ReadLine();
                myHost.Close();
            }
            catch (CommunicationException ce)
            {
                Console.WriteLine($"Wystapil wyjatek: {ce.Message}");
                myHost.Abort();
            }
        }
    }
}
