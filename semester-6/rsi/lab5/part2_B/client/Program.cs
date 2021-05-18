using asyncClient.TaskRef;
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;
using Task = asyncClient.TaskRef.Task;

namespace asyncClient
{
    class AsyncTaskCallback : IAsyncTaskCallback
    {
        public void RepeatResult(string result)
        {
            Console.WriteLine("Async function ended execution: {0}", result);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Task task1 = new Task { id = 1, text = "hello", times = 5 };
            Task task2 = new Task { id = 2, text = "world", times = 2 };
            Task task3 = new Task { id = 3, text = "koala", times = 4 };
            Task task4 = new Task { id = 4, text = "macro", times = 3 };

            AsyncTaskCallback callback = new AsyncTaskCallback();
            InstanceContext ctx = new InstanceContext(callback);
            AsyncTaskClient asyncClient = new AsyncTaskClient(ctx);

            Console.WriteLine("Client ServiceTask is running");

            Console.WriteLine("Adding tasks");
            asyncClient.AddTask(task1);
            asyncClient.AddTask(task2);
            asyncClient.AddTask(task3);
            asyncClient.AddTask(task4);

            var removedTask = asyncClient.RemoveTask(3);
            var task = asyncClient.GetTaskById(3);
            Console.WriteLine("RemoveTask(3): {0}", removedTask.id);
            Console.WriteLine("GetTaskById(3): {0}", task);
            Console.WriteLine();

            Console.WriteLine("Sync requests:");
            var exampleTask = asyncClient.GetTaskById(4);

            Console.WriteLine("Async requests 1");
            asyncClient.Repeat(task1);
            Console.WriteLine("Async requests 2");
            asyncClient.Repeat(exampleTask);

            Console.WriteLine("Press ENTER to exit");
            Console.Read();

            asyncClient.Close();
        }
    }
}
