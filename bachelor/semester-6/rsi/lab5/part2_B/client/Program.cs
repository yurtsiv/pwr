using client.TaskRef;
using System;
using System.ServiceModel;
using Todo = client.TaskRef.Todo;

namespace asyncClient
{
    class AsyncTaskCallback : IAsyncTodosCallback
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
            Todo task1 = new Todo { id = 1, text = "Milk", times = 5 };
            Todo task2 = new Todo { id = 2, text = "Water", times = 2 };
            Todo task3 = new Todo { id = 3, text = "Butter", times = 4 };
            Todo task4 = new Todo { id = 4, text = "Bread", times = 3 };

            AsyncTaskCallback callback = new AsyncTaskCallback();
            InstanceContext ctx = new InstanceContext(callback);
            AsyncTodosClient asyncClient = new AsyncTodosClient(ctx);

            Console.WriteLine("Client is running");

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

            var testTask = asyncClient.GetTaskById(4);

            Console.WriteLine("Async request 1");
            asyncClient.Repeat(task1);
            Console.WriteLine("Async request 2");
            asyncClient.Repeat(testTask);

            Console.WriteLine("Press ENTER to exit");
            Console.Read();

            asyncClient.Close();
        }
    }
}
