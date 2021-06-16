using Todos;
using System;
using System.ServiceModel;
using System.ServiceModel.Description;

namespace host
{
    class Program
    {
        static void Main(string[] args)
        {
            Uri baseAddress2 = new Uri("http://localhost:10000/AsyncTask");

            ServiceHost myHost2 = new ServiceHost(typeof(AsyncTodos), baseAddress2);

            ServiceEndpoint endpoint2 = myHost2.AddServiceEndpoint(typeof(IAsyncTodos), new WSDualHttpBinding(), "endpoint2");

            // metadata
            ServiceMetadataBehavior smb = new ServiceMetadataBehavior();
            smb.HttpGetEnabled = true;
            myHost2.Description.Behaviors.Add(smb);

            try
            {
                myHost2.Open();
                Console.WriteLine("Hhost is running.");
                Console.WriteLine("Binding endpoint with: {0}", endpoint2.Binding.ToString());
                Console.WriteLine("Press ENTER to exit");
                Console.WriteLine();
                
            } catch (CommunicationException e)
            {
                Console.WriteLine("Exception occurred: {0}", e);
                myHost2.Abort();
            }

            Console.Read();
            myHost2.Close();
        }
    }
}