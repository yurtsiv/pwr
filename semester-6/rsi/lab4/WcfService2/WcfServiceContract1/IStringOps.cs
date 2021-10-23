using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace WcfServiceContract1
{
    [ServiceContract(ProtectionLevel = System.Net.Security.ProtectionLevel.None)]
    public interface IStringOps
    {
        [OperationContract]
        string Concat(string s1, string s2);
        [OperationContract]
        bool Contains(string s1, string s2);
        [OperationContract]
        string Trim(string s);

        [OperationContract]
        string AppendAccum(string s);
        [OperationContract]
        string AverageStrLen(string[] l);
    }

    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    // You can add XSD files into the project. After building the project, you can directly use the data types defined there, with the namespace "WcfServiceContract1.ContractType".
    [DataContract]
    public class CompositeType
    {
        bool boolValue = true;
        string stringValue = "Hello ";

        [DataMember]
        public bool BoolValue
        {
            get { return boolValue; }
            set { boolValue = value; }
        }

        [DataMember]
        public string StringValue
        {
            get { return stringValue; }
            set { stringValue = value; }
        }
    }
}
