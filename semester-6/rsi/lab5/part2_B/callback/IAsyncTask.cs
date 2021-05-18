using contract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace callback
{
    public interface IAsyncTaskCallback
    {
        [OperationContract(IsOneWay = true)]
        void RepeatResult(string result);
    }

    [ServiceContract (SessionMode = SessionMode.Required, CallbackContract = typeof(IAsyncTaskCallback))]
    public interface IAsyncTask
    {
        [OperationContract(IsOneWay = true)]
        void Repeat(Task task);

        [OperationContract]
        Task GetTaskById(int id);

        [OperationContract]
        void AddTask(Task task);

        [OperationContract]
        Task RemoveTask(int id);

        [OperationContract]
        Task UpdateTask(int id, string text, int times);

    }
}
