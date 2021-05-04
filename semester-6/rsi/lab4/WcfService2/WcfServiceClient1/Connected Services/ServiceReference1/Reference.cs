﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WcfServiceClient1.ServiceReference1 {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="ServiceReference1.IStringOps")]
    public interface IStringOps {
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Concat", ReplyAction="http://tempuri.org/IStringOps/ConcatResponse")]
        string Concat(string s1, string s2);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Concat", ReplyAction="http://tempuri.org/IStringOps/ConcatResponse")]
        System.Threading.Tasks.Task<string> ConcatAsync(string s1, string s2);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Contains", ReplyAction="http://tempuri.org/IStringOps/ContainsResponse")]
        bool Contains(string s1, string s2);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Contains", ReplyAction="http://tempuri.org/IStringOps/ContainsResponse")]
        System.Threading.Tasks.Task<bool> ContainsAsync(string s1, string s2);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Trim", ReplyAction="http://tempuri.org/IStringOps/TrimResponse")]
        string Trim(string s);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/Trim", ReplyAction="http://tempuri.org/IStringOps/TrimResponse")]
        System.Threading.Tasks.Task<string> TrimAsync(string s);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/AppendAccum", ReplyAction="http://tempuri.org/IStringOps/AppendAccumResponse")]
        string AppendAccum(string s);
        
        [System.ServiceModel.OperationContractAttribute(ProtectionLevel=System.Net.Security.ProtectionLevel.None, Action="http://tempuri.org/IStringOps/AppendAccum", ReplyAction="http://tempuri.org/IStringOps/AppendAccumResponse")]
        System.Threading.Tasks.Task<string> AppendAccumAsync(string s);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IStringOpsChannel : WcfServiceClient1.ServiceReference1.IStringOps, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class StringOpsClient : System.ServiceModel.ClientBase<WcfServiceClient1.ServiceReference1.IStringOps>, WcfServiceClient1.ServiceReference1.IStringOps {
        
        public StringOpsClient() {
        }
        
        public StringOpsClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public StringOpsClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public StringOpsClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public StringOpsClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public string Concat(string s1, string s2) {
            return base.Channel.Concat(s1, s2);
        }
        
        public System.Threading.Tasks.Task<string> ConcatAsync(string s1, string s2) {
            return base.Channel.ConcatAsync(s1, s2);
        }
        
        public bool Contains(string s1, string s2) {
            return base.Channel.Contains(s1, s2);
        }
        
        public System.Threading.Tasks.Task<bool> ContainsAsync(string s1, string s2) {
            return base.Channel.ContainsAsync(s1, s2);
        }
        
        public string Trim(string s) {
            return base.Channel.Trim(s);
        }
        
        public System.Threading.Tasks.Task<string> TrimAsync(string s) {
            return base.Channel.TrimAsync(s);
        }
        
        public string AppendAccum(string s) {
            return base.Channel.AppendAccum(s);
        }
        
        public System.Threading.Tasks.Task<string> AppendAccumAsync(string s) {
            return base.Channel.AppendAccumAsync(s);
        }
    }
}
