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
        static string port = "10000";
        static string baseUri = $"http://localhost:{port}/MyCalculator";
        static void Main(string[] args)
        {
            Uri baseAddress = new Uri(baseUri);
            ServiceHost myHost = new ServiceHost(typeof(MyCalculator), baseAddress);

            WSHttpBinding myBinding = new WSHttpBinding();

            ServiceEndpoint endpoint1 = myHost.AddServiceEndpoint(typeof(ICalculator), myBinding, "endpoint1");

            ServiceMetadataBehavior smb = new ServiceMetadataBehavior();
            smb.HttpGetEnabled = true;
            myHost.Description.Behaviors.Add(smb);

            try
            {
                BasicHttpBinding binding2 = new BasicHttpBinding();
                ServiceEndpoint endpoint2 = myHost.AddServiceEndpoint(typeof(ICalculator), binding2, "endpoint2");
                ServiceEndpoint endpoint3 = myHost.Description.Endpoints.Find(
                    new Uri($"{baseUri}/endpoint3")
                );

                Console.WriteLine("\n----> Endpointy");
                Console.WriteLine($"\nService endpoint {endpoint1.Name}");
                Console.WriteLine($"Binding: {endpoint1.Binding.ToString()}");
                Console.WriteLine($"ListenUri: {endpoint1.ListenUri.ToString()}");

                Console.WriteLine($"\nService endpoint {endpoint2.Name}");
                Console.WriteLine($"Binding: {endpoint2.Binding.ToString()}");
                Console.WriteLine($"ListenUri: {endpoint2.ListenUri.ToString()}");

                Console.WriteLine($"\nService endpoint {endpoint3.Name}");
                Console.WriteLine($"Binding: {endpoint3.Binding.ToString()}");
                Console.WriteLine($"ListenUri: {endpoint3.ListenUri.ToString()}");

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
