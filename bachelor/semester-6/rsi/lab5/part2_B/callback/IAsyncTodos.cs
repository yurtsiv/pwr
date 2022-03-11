using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace Todos
{
    public interface IAsyncTodosCallback
    {
        [OperationContract(IsOneWay = true)]
        void RepeatResult(string result);
    }

    [ServiceContract (SessionMode = SessionMode.Required, CallbackContract = typeof(IAsyncTodosCallback))]
    public interface IAsyncTodos
    {
        [OperationContract(IsOneWay = true)]
        void Repeat(Todo task);

        [OperationContract]
        Todo GetTaskById(int id);

        [OperationContract]
        void AddTask(Todo task);

        [OperationContract]
        Todo RemoveTask(int id);

        [OperationContract]
        Todo UpdateTask(int id, string text, int times);

    }

    [DataContract]
    public class Todo
    {
        [DataMember]
        public int id;

        [DataMember]
        public string text;

        [DataMember]
        public int times;

        public Todo(int id, string text, int times)
        {
            this.id = id;
            this.text = text;
            this.times = times;
        }
    }

}
