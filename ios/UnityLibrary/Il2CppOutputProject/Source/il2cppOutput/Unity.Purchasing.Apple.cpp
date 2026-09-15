#include "pch-cpp.hpp"






struct DelegateU5BU5D_tC5AB7E8F745616680F337909D3A8E6C722CDF771;
struct DelegateData_t9B286B493293CD2D23A5B2B5EF0E5B1324C2B77E;
struct MethodInfo_t;
struct String_t;
struct UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3;
struct Void_t4861ACF8F4594C3437BB48B6E56783494B843915;
struct iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0;

struct Delegate_t_marshaled_com;
struct Delegate_t_marshaled_pinvoke;


IL2CPP_EXTERN_C_BEGIN
IL2CPP_EXTERN_C_END

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
struct U3CModuleU3E_t61AF874F149C9609D7FF09D5A7130BC8BBDA6650 
{
};
struct String_t  : public RuntimeObject
{
	int32_t ____stringLength;
	Il2CppChar ____firstChar;
};
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F  : public RuntimeObject
{
};
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F_marshaled_pinvoke
{
};
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F_marshaled_com
{
};
struct iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0  : public RuntimeObject
{
};
struct Boolean_t09A6377A54BE2F9E6985A8149F19234FD7DDFE22 
{
	bool ___m_value;
};
struct Int32_t680FF22E76F6EFAD4375103CBBFFA0421349384C 
{
	int32_t ___m_value;
};
struct IntPtr_t 
{
	void* ___m_value;
};
struct Void_t4861ACF8F4594C3437BB48B6E56783494B843915 
{
	union
	{
		struct
		{
		};
		uint8_t Void_t4861ACF8F4594C3437BB48B6E56783494B843915__padding[1];
	};
};
struct Delegate_t  : public RuntimeObject
{
	intptr_t ___method_ptr;
	intptr_t ___invoke_impl;
	RuntimeObject* ___m_target;
	intptr_t ___method;
	intptr_t ___delegate_trampoline;
	intptr_t ___extra_arg;
	intptr_t ___method_code;
	intptr_t ___interp_method;
	intptr_t ___interp_invoke_impl;
	MethodInfo_t* ___method_info;
	MethodInfo_t* ___original_method_info;
	DelegateData_t9B286B493293CD2D23A5B2B5EF0E5B1324C2B77E* ___data;
	bool ___method_is_virtual;
};
struct Delegate_t_marshaled_pinvoke
{
	intptr_t ___method_ptr;
	intptr_t ___invoke_impl;
	Il2CppIUnknown* ___m_target;
	intptr_t ___method;
	intptr_t ___delegate_trampoline;
	intptr_t ___extra_arg;
	intptr_t ___method_code;
	intptr_t ___interp_method;
	intptr_t ___interp_invoke_impl;
	MethodInfo_t* ___method_info;
	MethodInfo_t* ___original_method_info;
	DelegateData_t9B286B493293CD2D23A5B2B5EF0E5B1324C2B77E* ___data;
	int32_t ___method_is_virtual;
};
struct Delegate_t_marshaled_com
{
	intptr_t ___method_ptr;
	intptr_t ___invoke_impl;
	Il2CppIUnknown* ___m_target;
	intptr_t ___method;
	intptr_t ___delegate_trampoline;
	intptr_t ___extra_arg;
	intptr_t ___method_code;
	intptr_t ___interp_method;
	intptr_t ___interp_invoke_impl;
	MethodInfo_t* ___method_info;
	MethodInfo_t* ___original_method_info;
	DelegateData_t9B286B493293CD2D23A5B2B5EF0E5B1324C2B77E* ___data;
	int32_t ___method_is_virtual;
};
struct MulticastDelegate_t  : public Delegate_t
{
	DelegateU5BU5D_tC5AB7E8F745616680F337909D3A8E6C722CDF771* ___delegates;
};
struct MulticastDelegate_t_marshaled_pinvoke : public Delegate_t_marshaled_pinvoke
{
	Delegate_t_marshaled_pinvoke** ___delegates;
};
struct MulticastDelegate_t_marshaled_com : public Delegate_t_marshaled_com
{
	Delegate_t_marshaled_com** ___delegates;
};
struct UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3  : public MulticastDelegate_t
{
};
struct String_t_StaticFields
{
	String_t* ___Empty;
};
struct Boolean_t09A6377A54BE2F9E6985A8149F19234FD7DDFE22_StaticFields
{
	String_t* ___TrueString;
	String_t* ___FalseString;
};
struct IntPtr_t_StaticFields
{
	intptr_t ___Zero;
};
#ifdef __clang__
#pragma clang diagnostic pop
#endif



IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_SetNativeCallback_m48C165929A4DFD0ABC5015941D3F46A68F46474D (UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3* ___0_callbackDelegate, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_DeallocateMemory_m038C009D4E37DF441F6E99D723C125A08DD3B168 (intptr_t ___0_pointer, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_FetchProducts_m394B980FD20D9985D4747CE1C0847793A28CF4B7 (String_t* ___0_json, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool String_IsNullOrEmpty_mEA9E3FB005AC28FE02E69FCF95A7B8456192B478 (String_t* ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_FinishTransaction_mAC15FECCFE5690F2A2564C384DA071509930D7E1 (String_t* ___0_transactionId, bool ___1_logFinishTransaction, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_RefreshAppReceipt_m06EF637EEE6B826AF51011D6F89E675AD09F7009 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2 (RuntimeObject* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C void DEFAULT_CALL unityPurchasing_SetNativeCallback(Il2CppMethodPointer);
IL2CPP_EXTERN_C void DEFAULT_CALL unityPurchasing_FetchProducts(char*);
IL2CPP_EXTERN_C void DEFAULT_CALL unityPurchasing_DeallocateMemory(intptr_t);
IL2CPP_EXTERN_C void DEFAULT_CALL unityPurchasing_FinishTransaction(char*, int32_t);
IL2CPP_EXTERN_C void DEFAULT_CALL unityPurchasing_RefreshAppReceipt();
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_SetNativeCallback_m48C165929A4DFD0ABC5015941D3F46A68F46474D (UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3* ___0_callbackDelegate, const RuntimeMethod* method) 
{
	typedef void (DEFAULT_CALL *PInvokeFunc) (Il2CppMethodPointer);

	Il2CppMethodPointer ____0_callbackDelegate_marshaled = NULL;
	____0_callbackDelegate_marshaled = il2cpp_codegen_marshal_delegate(reinterpret_cast<MulticastDelegate_t*>(___0_callbackDelegate));

	reinterpret_cast<PInvokeFunc>(unityPurchasing_SetNativeCallback)(____0_callbackDelegate_marshaled);

}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_FetchProducts_m394B980FD20D9985D4747CE1C0847793A28CF4B7 (String_t* ___0_json, const RuntimeMethod* method) 
{
	typedef void (DEFAULT_CALL *PInvokeFunc) (char*);

	char* ____0_json_marshaled = NULL;
	____0_json_marshaled = il2cpp_codegen_marshal_string(___0_json);

	reinterpret_cast<PInvokeFunc>(unityPurchasing_FetchProducts)(____0_json_marshaled);

	il2cpp_codegen_marshal_free(____0_json_marshaled);
	____0_json_marshaled = NULL;

}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_DeallocateMemory_m038C009D4E37DF441F6E99D723C125A08DD3B168 (intptr_t ___0_pointer, const RuntimeMethod* method) 
{
	typedef void (DEFAULT_CALL *PInvokeFunc) (intptr_t);

	reinterpret_cast<PInvokeFunc>(unityPurchasing_DeallocateMemory)(___0_pointer);

}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_FinishTransaction_mAC15FECCFE5690F2A2564C384DA071509930D7E1 (String_t* ___0_transactionId, bool ___1_logFinishTransaction, const RuntimeMethod* method) 
{
	typedef void (DEFAULT_CALL *PInvokeFunc) (char*, int32_t);

	char* ____0_transactionId_marshaled = NULL;
	____0_transactionId_marshaled = il2cpp_codegen_marshal_string(___0_transactionId);

	reinterpret_cast<PInvokeFunc>(unityPurchasing_FinishTransaction)(____0_transactionId_marshaled, static_cast<int32_t>(___1_logFinishTransaction));

	il2cpp_codegen_marshal_free(____0_transactionId_marshaled);
	____0_transactionId_marshaled = NULL;

}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_unityPurchasing_RefreshAppReceipt_m06EF637EEE6B826AF51011D6F89E675AD09F7009 (const RuntimeMethod* method) 
{
	typedef void (DEFAULT_CALL *PInvokeFunc) ();

	reinterpret_cast<PInvokeFunc>(unityPurchasing_RefreshAppReceipt)();

}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_SetUnityPurchasingCallback_m219BD679AD861A63ED28739140610DB5DA5463D6 (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3* ___0_AsyncCallback, const RuntimeMethod* method) 
{
	{
		UnityPurchasingCallback_t3C1333A45134D9A999AB29AEEBF05883A9A707F3* L_0 = ___0_AsyncCallback;
		iOSStoreBindings_unityPurchasing_SetNativeCallback_m48C165929A4DFD0ABC5015941D3F46A68F46474D(L_0, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_DeallocateMemory_mEBD5AACED8199802A7628078CD3396F89CC480E9 (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, intptr_t ___0_pointer, const RuntimeMethod* method) 
{
	{
		intptr_t L_0 = ___0_pointer;
		iOSStoreBindings_unityPurchasing_DeallocateMemory_m038C009D4E37DF441F6E99D723C125A08DD3B168(L_0, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_FetchProducts_m5ECD8737AF6F6849004DD88099D6FBD3132605AF (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, String_t* ___0_json, const RuntimeMethod* method) 
{
	{
		String_t* L_0 = ___0_json;
		iOSStoreBindings_unityPurchasing_FetchProducts_m394B980FD20D9985D4747CE1C0847793A28CF4B7(L_0, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_FinishTransaction_mDD77BBC44F32A0E5E508DEA91519F15B8F91C3F6 (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, String_t* ___0_productDescription, String_t* ___1_transactionId, const RuntimeMethod* method) 
{
	{
		String_t* L_0 = ___1_transactionId;
		String_t* L_1 = ___0_productDescription;
		bool L_2;
		L_2 = String_IsNullOrEmpty_mEA9E3FB005AC28FE02E69FCF95A7B8456192B478(L_1, NULL);
		iOSStoreBindings_unityPurchasing_FinishTransaction_mAC15FECCFE5690F2A2564C384DA071509930D7E1(L_0, (bool)((((int32_t)L_2) == ((int32_t)0))? 1 : 0), NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings_RefreshAppReceipt_mB71B723604356E85F2A7FE5A27D4ECA3723BD453 (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, const RuntimeMethod* method) 
{
	{
		iOSStoreBindings_unityPurchasing_RefreshAppReceipt_m06EF637EEE6B826AF51011D6F89E675AD09F7009(NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void iOSStoreBindings__ctor_mE32A73607E2E7F2341870734F6EA96375BB760DB (iOSStoreBindings_t6D0B0FA1099D0078AA43F5214A8DFAE1663323B0* __this, const RuntimeMethod* method) 
{
	{
		Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
