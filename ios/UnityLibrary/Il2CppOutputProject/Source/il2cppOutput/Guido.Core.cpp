#include "pch-cpp.hpp"





template <typename T1, typename T2>
struct VirtualActionInvoker2
{
	typedef void (*Action)(void*, T1, T2, const RuntimeMethod*);

	static inline void Invoke (Il2CppMethodSlot slot, RuntimeObject* obj, T1 p1, T2 p2)
	{
		const VirtualInvokeData& invokeData = il2cpp_codegen_get_virtual_invoke_data(slot, obj);
		((Action)invokeData.methodPtr)(obj, p1, p2, invokeData.method);
	}
};
template <typename R>
struct VirtualFuncInvoker0
{
	typedef R (*Func)(void*, const RuntimeMethod*);

	static inline R Invoke (Il2CppMethodSlot slot, RuntimeObject* obj)
	{
		const VirtualInvokeData& invokeData = il2cpp_codegen_get_virtual_invoke_data(slot, obj);
		return ((Func)invokeData.methodPtr)(obj, invokeData.method);
	}
};
struct InterfaceActionInvoker0
{
	typedef void (*Action)(void*, const RuntimeMethod*);

	static inline void Invoke (Il2CppMethodSlot slot, RuntimeClass* declaringInterface, RuntimeObject* obj)
	{
		const VirtualInvokeData& invokeData = il2cpp_codegen_get_interface_invoke_data(slot, obj, declaringInterface);
		((Action)invokeData.methodPtr)(obj, invokeData.method);
	}
};
template <typename T1>
struct InterfaceActionInvoker1
{
	typedef void (*Action)(void*, T1, const RuntimeMethod*);

	static inline void Invoke (Il2CppMethodSlot slot, RuntimeClass* declaringInterface, RuntimeObject* obj, T1 p1)
	{
		const VirtualInvokeData& invokeData = il2cpp_codegen_get_interface_invoke_data(slot, obj, declaringInterface);
		((Action)invokeData.methodPtr)(obj, p1, invokeData.method);
	}
};

struct Action_1_tE8693FF0E67CDBA52BAFB211BFF1844D076ABAFB;
struct Action_2_t0573B13685F7D1632AFBF12A72947EC189082208;
struct Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8;
struct GenericEventChannelSO_1_t8D716B7E7446940F16504CA7E0AAD35DA7CE8F6E;
struct GenericEventChannelSO_1_t5AC28C96BE6309EA31ADB7FB6DAAE59DBE4AAFEA;
struct GenericEventChannelSO_1_tFDABE3C9DDB21BA0C689D8B649DD8B4B3F3E6F38;
struct GenericEventChannelSO_1_t94C91634A143708415B4CA825916B3CEE57BCD1B;
struct GenericEventChannelSO_1_tB6EF6389EEEA591B0EF70C0FB1917E9E68C12FC1;
struct GenericEventChannelSO_1_t82BDD65F27E341CDD32A08BE4386ABB75CDB94F3;
struct List_1_tB2FB3A51525B691C3FF8B27FD20E9C31736D1713;
struct List_1_t1380C530A5D2929C738AA31853B9EA4A6757EA30;
struct List_1_t4B1084108031EF9530DD18F6C30A4BAF00462C0B;
struct List_1_t71EFF5A5F787719FCA16651E55B031F15ECF78AB;
struct List_1_tBB25F7EA475FB5AB9F915049CB3BB346A234C92C;
struct List_1_tDB72209F35D56F62A287633F9450978E90B90987;
struct List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A;
struct UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A;
struct UnityAction_2_t742C43FA6EAABE0458C753DFE15FDDFAE01EA73F;
struct ActionU5BU5D_tF6161335A0A12A221AB081D78725C8AB6FE506D2;
struct AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F;
struct ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031;
struct CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B;
struct CharU5BU5D_t799905CF001DD5F13F7DBB310181FC4D8B7D0AAB;
struct DelegateU5BU5D_tC5AB7E8F745616680F337909D3A8E6C722CDF771;
struct IntPtrU5BU5D_tFD177F8C806A6921AD7150264CCC62FA00CAD832;
struct MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7;
struct ObjectU5BU5D_t8061030B0A12A55D5AD8652A20C922FE99450918;
struct StackTraceU5BU5D_t32FBCB20930EAF5BAE3F450FF75228E5450DA0DF;
struct StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248;
struct TypeU5BU5D_t97234E1129B564EB38B8D85CAC2AD8B5B9522FFB;
struct __Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC;
struct Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07;
struct AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C;
struct Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA;
struct AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35;
struct Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA;
struct Binder_t91BFCE95A7057FADF4D8A1A342AFE52872246235;
struct BoolEventChannelSO_t9A16108D782FA74ABE10D2C07CECBE863E7CDF32;
struct Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184;
struct CancellationTokenSource_tAAE1E0033BCFC233801F8CB4CED5C852B350CB7B;
struct Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3;
struct Delegate_t;
struct DelegateData_t9B286B493293CD2D23A5B2B5EF0E5B1324C2B77E;
struct EmbeddedAttribute_tA7D5468C6D3F39D2C974C36BC3E6721320294217;
struct EventInfo_t;
struct Exception_t;
struct FloatEventChannelSO_t3024DD408E0E10E9D724C0752D12BD4E01AF7BAC;
struct GameObject_t76FEDD663AB33C991A9C9A23129337651094216F;
struct Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E;
struct IDictionary_t6D03155AF1FA9083817AA5B6AD7DEEACC26AB220;
struct IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8;
struct IntEventChannelSO_t70D68D92C915B0A21096F763ADB17BC18E5F2B0D;
struct MemberFilter_tF644F1AE82F611B677CE1964D5A3277DDA21D553;
struct MethodInfo_t;
struct MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71;
struct NullableAttribute_t82D15F098529F06E211478717327DD391DCD9D9B;
struct NullableContextAttribute_t1A534AEEDCB6F8CE900B734C9A370AF7951399B0;
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C;
struct QualityPresetEventChannelSO_tE1C99F5541B59D973E5C3BDEDA3F7D96C0C58CE1;
struct RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA;
struct SafeSerializationManager_tCBB85B95DFD1634237140CD892E82D06ECB3F5E6;
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A;
struct StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96;
struct String_t;
struct StringEventChannelSO_t1B8C059DCA2CBC16BC4FB5F811A657EB888AB994;
struct Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1;
struct Type_t;
struct UnitySourceGeneratedAssemblyMonoScriptTypes_v1_t235D228E4864CB3B2043FAF6ECC420F6D2F9C385;
struct VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02;
struct Void_t4861ACF8F4594C3437BB48B6E56783494B843915;
struct VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347;
struct CameraCallback_t844E527BFE37BC0495E7F67993E43C07642DA9DD;
struct AddEventAdapter_tE0DE36700D110F4D267B26686541ABCF9588A6DD;

IL2CPP_EXTERN_C RuntimeClass* Action_2_t0573B13685F7D1632AFBF12A72947EC189082208_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Exception_t_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* GC_t920F9CF6EBB7C787E5010A4352E1B587F356DC58_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* GameObject_t76FEDD663AB33C991A9C9A23129337651094216F_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* List_1_tDB72209F35D56F62A287633F9450978E90B90987_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* LoadSceneMode_t3E17ADA25A3C4F14ECF6026741219437DA054963_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Math_tEB65DE7CA8B083C412C969C92981C030865486CE_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* SceneManager_tA0EF56A88ACA4A15731AF7FDC10A869FA4C698FA_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeField* U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____43391750B3DD3EB770B251CD65ACC059FEE2FB06EC7DDE49315C1CAEF4178376_FieldInfo_var;
IL2CPP_EXTERN_C RuntimeField* U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____957CE894FD2093C88F7ED5A6047325DC43F03D67652BC252AE0EED3A78FB8453_FieldInfo_var;
IL2CPP_EXTERN_C String_t* _stringLiteral03A4D076B6CD9A4B5F0A0F97119D1F56E9DC4029;
IL2CPP_EXTERN_C String_t* _stringLiteral21368742647C64881FA2CF76FFA64DEECA581E78;
IL2CPP_EXTERN_C String_t* _stringLiteral24301BAB550EA3EDCE733629ED5B2C4EAC51D777;
IL2CPP_EXTERN_C String_t* _stringLiteral2678DF1F1EF33CB814D18B41F3EBC54C47C8B6EA;
IL2CPP_EXTERN_C String_t* _stringLiteral3144D3F473EBCC1B9BC49D9037872EC6D4FE15DC;
IL2CPP_EXTERN_C String_t* _stringLiteral338604A89C31D04CCF99255B458AB629651157AB;
IL2CPP_EXTERN_C String_t* _stringLiteral35A0B4FD90759A33EA223EBB8BEA69368E955F11;
IL2CPP_EXTERN_C String_t* _stringLiteral4110DFC6A27616FFCA93EC70E7DCD20FEE985F91;
IL2CPP_EXTERN_C String_t* _stringLiteral58BB01568EA9632856160FC015FD7B06EDD1F667;
IL2CPP_EXTERN_C String_t* _stringLiteral60F65CC9C00585B68DA57ED71FF30B3BC3F80896;
IL2CPP_EXTERN_C String_t* _stringLiteral753F7D6BB673707350C1F4C6F341972B7F8D5CEA;
IL2CPP_EXTERN_C String_t* _stringLiteral75F619534A93FA16E3265FD238517C8064975836;
IL2CPP_EXTERN_C String_t* _stringLiteral7DA1E12011380B8307A333B91B409E670F7704F8;
IL2CPP_EXTERN_C String_t* _stringLiteral82D9834C0789DEA27A1C0AABE4EB99B77AEA3659;
IL2CPP_EXTERN_C String_t* _stringLiteral85BC080D94161C99BB2439899C225C54D81C4E15;
IL2CPP_EXTERN_C String_t* _stringLiteral8CCEF704EA3F7EE31DBE57B1D38B190FC62E7054;
IL2CPP_EXTERN_C String_t* _stringLiteral9816E74B93E1C26A72AD4D2196C8A3C7A3C28924;
IL2CPP_EXTERN_C String_t* _stringLiteral98CEDCF77F67B56E17FDDC62623475CE278853E6;
IL2CPP_EXTERN_C String_t* _stringLiteralA6A37A7EF98C3D357B5014405CDFF9A1813578C9;
IL2CPP_EXTERN_C String_t* _stringLiteralA70D6CDC1F06B9FC50E6DAC070AEC4AE209ABA17;
IL2CPP_EXTERN_C String_t* _stringLiteralB11483976AA9882F71817EA7C833D646C34C0D86;
IL2CPP_EXTERN_C String_t* _stringLiteralB7C45DD316C68ABF3429C20058C2981C652192F2;
IL2CPP_EXTERN_C String_t* _stringLiteralBB939A96D8BF5583810D5B0D326E59C194ED7AAD;
IL2CPP_EXTERN_C String_t* _stringLiteralBCB8EA8CE44BF70D2BDF275460B04C40B746F52E;
IL2CPP_EXTERN_C String_t* _stringLiteralC7A7939E82BEFEF8DDB755713442AA62963F09F8;
IL2CPP_EXTERN_C String_t* _stringLiteralE1E18CE96394C50555C8148849B23AD9FC1CBBC5;
IL2CPP_EXTERN_C String_t* _stringLiteralE302AA9BECF9F1CB69CF2A3E5B33E0716BEA97F6;
IL2CPP_EXTERN_C String_t* _stringLiteralE91FE173F59B063D620A934CE1A010F2B114C1F3;
IL2CPP_EXTERN_C String_t* _stringLiteralEA2D7547088757F5477C2A061305F2DAD5939558;
IL2CPP_EXTERN_C String_t* _stringLiteralEF1CAE2AA83E021BE2F831D444881036EC9D3CCF;
IL2CPP_EXTERN_C String_t* _stringLiteralF1A9CD2C6466E3BBDCF6FDEB6ADD2509BAE430B6;
IL2CPP_EXTERN_C const RuntimeMethod* Component_GetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m18720A555FC6A050CCD144559DC24C2DD39FDB0B_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* Component_GetComponentsInChildren_TisMonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71_m802D8975EFA14B49D71AFFBCCE19FBB480EE0C66_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* Component_TryGetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m6BA3859778F8DD9E3AB12FB8CDAD6EB9BA75CAA5_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GameObject_AddComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_mA30AC51FE6287A9D0057077D99F694600A3D844E_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GenericEventChannelSO_1__ctor_mA74BA91BA6D1979DAC4F47F402DFC007C2C45E2F_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GenericEventChannelSO_1__ctor_mA81A109554A78181BB23114752E3B9BEDB8CF01A_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GenericEventChannelSO_1__ctor_mC2FDABB71598996FE8DB22F384677A6ED000DE46_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GenericEventChannelSO_1__ctor_mCC1C0EE91DA2D5F6DD88E51F10405EC6D88AF9BF_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* GenericEventChannelSO_1__ctor_mF75F9F4F07B28C70BAC3EF57E4F63759F2C3B3A5_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* JsonUtility_FromJson_TisRotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA_m0DC882EF0486A2C8429FE72EF58E917FFF8203C3_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_Add_m5B99D67CB378BFA8A1142343F9DB44D94322EAD3_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_Clear_m344AD90676A608EA37B9DF93050BA9F80C23D17E_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_Contains_m181F2DB6756B1ADDCEC909ADA27A8FDDBD18C002_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_Remove_m2F58C9F48DA11B2DF2D297626E97A25B1050D822_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1__ctor_mEBBE8A30276CDE4C03E41569F6553229F093035E_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* Object_FindObjectsByType_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m41F4E631A15C9290412B4A4BC98BAC8FA83CD5C6_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B_RuntimeMethod_var;
IL2CPP_EXTERN_C const RuntimeMethod* VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876_RuntimeMethod_var;
struct Delegate_t_marshaled_com;
struct Delegate_t_marshaled_pinvoke;
struct Exception_t_marshaled_com;
struct Exception_t_marshaled_pinvoke;

struct AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F;
struct ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031;
struct CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B;
struct MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7;
struct StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248;
struct __Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC;

IL2CPP_EXTERN_C_BEGIN
IL2CPP_EXTERN_C_END

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
struct U3CModuleU3E_tB108A31290E1BA37F635B7F51166BB9F95CEA9A2 
{
};
struct List_1_tDB72209F35D56F62A287633F9450978E90B90987  : public RuntimeObject
{
	ActionU5BU5D_tF6161335A0A12A221AB081D78725C8AB6FE506D2* ____items;
	int32_t ____size;
	int32_t ____version;
	RuntimeObject* ____syncRoot;
};
struct List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A  : public RuntimeObject
{
	__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* ____items;
	int32_t ____size;
	int32_t ____version;
	RuntimeObject* ____syncRoot;
};
struct U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A  : public RuntimeObject
{
};
struct Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA  : public RuntimeObject
{
};
struct Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E  : public RuntimeObject
{
	int32_t ___m_GyroIndex;
};
struct MemberInfo_t  : public RuntimeObject
{
};
struct RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA  : public RuntimeObject
{
	float ___dx;
	float ___dy;
};
struct StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96  : public RuntimeObject
{
	RuntimeObject* ____currentState;
	RuntimeObject* ____previousState;
	bool ____isTransitioning;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* ___OnStateChanged;
};
struct String_t  : public RuntimeObject
{
	int32_t ____stringLength;
	Il2CppChar ____firstChar;
};
struct UnitySourceGeneratedAssemblyMonoScriptTypes_v1_t235D228E4864CB3B2043FAF6ECC420F6D2F9C385  : public RuntimeObject
{
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
struct YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D  : public RuntimeObject
{
};
struct YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D_marshaled_pinvoke
{
};
struct YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D_marshaled_com
{
};
struct Boolean_t09A6377A54BE2F9E6985A8149F19234FD7DDFE22 
{
	bool ___m_value;
};
struct Byte_t94D9231AC217BE4D2E004C4CD32DF6D099EA41A3 
{
	uint8_t ___m_value;
};
struct Color_tD001788D726C3A7F1379BEED0260B9591F440C1F 
{
	float ___r;
	float ___g;
	float ___b;
	float ___a;
};
struct Double_tE150EF3D1D43DEE85D533810AB4C742307EEDE5F 
{
	double ___m_value;
};
struct EmbeddedAttribute_tA7D5468C6D3F39D2C974C36BC3E6721320294217  : public Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA
{
};
struct EntityId_t982FBD037EAC5CA077B1602A7EA40E3523AA0FC8 
{
	union
	{
		struct
		{
			int32_t ___m_Data;
		};
		uint8_t EntityId_t982FBD037EAC5CA077B1602A7EA40E3523AA0FC8__padding[4];
	};
};
struct Enum_t2A1A94B24E3B776EEF4E5E485E290BB9D4D072E2  : public ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F
{
};
struct Enum_t2A1A94B24E3B776EEF4E5E485E290BB9D4D072E2_marshaled_pinvoke
{
};
struct Enum_t2A1A94B24E3B776EEF4E5E485E290BB9D4D072E2_marshaled_com
{
};
struct EventInfo_t  : public MemberInfo_t
{
	AddEventAdapter_tE0DE36700D110F4D267B26686541ABCF9588A6DD* ___cached_add_event;
};
struct Int32_t680FF22E76F6EFAD4375103CBBFFA0421349384C 
{
	int32_t ___m_value;
};
struct IntPtr_t 
{
	void* ___m_value;
};
struct MethodBase_t  : public MemberInfo_t
{
};
struct NullableAttribute_t82D15F098529F06E211478717327DD391DCD9D9B  : public Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA
{
	ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* ___NullableFlags;
};
struct NullableContextAttribute_t1A534AEEDCB6F8CE900B734C9A370AF7951399B0  : public Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA
{
	uint8_t ___Flag;
};
struct Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 
{
	float ___x;
	float ___y;
	float ___z;
	float ___w;
};
struct Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D 
{
	float ___m_XMin;
	float ___m_YMin;
	float ___m_Width;
	float ___m_Height;
};
struct Single_t4530F2FF86FCB0DC29F35385CA1BD21BE294761C 
{
	float ___m_value;
};
struct Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 
{
	float ___x;
	float ___y;
};
struct Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 
{
	float ___x;
	float ___y;
	float ___z;
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
#pragma pack(push, tp, 1)
struct __StaticArrayInitTypeSizeU3D588_tF62990ADF2BCF3774E5F60709830E5D35490CB0B 
{
	union
	{
		struct
		{
			union
			{
			};
		};
		uint8_t __StaticArrayInitTypeSizeU3D588_tF62990ADF2BCF3774E5F60709830E5D35490CB0B__padding[588];
	};
};
#pragma pack(pop, tp)
#pragma pack(push, tp, 1)
struct __StaticArrayInitTypeSizeU3D802_tE181652709C351E05532E1537B9B9BCFF4DDEDF8 
{
	union
	{
		struct
		{
			union
			{
			};
		};
		uint8_t __StaticArrayInitTypeSizeU3D802_tE181652709C351E05532E1537B9B9BCFF4DDEDF8__padding[802];
	};
};
#pragma pack(pop, tp)
struct MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE 
{
	ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* ___FilePathsData;
	ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* ___TypesData;
	int32_t ___TotalTypes;
	int32_t ___TotalFiles;
	bool ___IsEditorOnly;
};
struct MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_pinvoke
{
	Il2CppSafeArray* ___FilePathsData;
	Il2CppSafeArray* ___TypesData;
	int32_t ___TotalTypes;
	int32_t ___TotalFiles;
	int32_t ___IsEditorOnly;
};
struct MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_com
{
	Il2CppSafeArray* ___FilePathsData;
	Il2CppSafeArray* ___TypesData;
	int32_t ___TotalTypes;
	int32_t ___TotalFiles;
	int32_t ___IsEditorOnly;
};
struct AppLanguage_tD134779F1D4F54A6362733D6E1B007324E51485F 
{
	int32_t ___value__;
};
struct AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C  : public YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D
{
	intptr_t ___m_Ptr;
	Action_1_tE8693FF0E67CDBA52BAFB211BFF1844D076ABAFB* ___m_completeCallback;
};
struct AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C_marshaled_pinvoke : public YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D_marshaled_pinvoke
{
	intptr_t ___m_Ptr;
	Il2CppMethodPointer ___m_completeCallback;
};
struct AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C_marshaled_com : public YieldInstruction_tFCE35FD0907950EFEE9BC2890AC664E41C53728D_marshaled_com
{
	intptr_t ___m_Ptr;
	Il2CppMethodPointer ___m_completeCallback;
};
struct CameraClearFlags_t91B921013F611457A09B92EF9C6B218CECF67202 
{
	int32_t ___value__;
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
struct Exception_t  : public RuntimeObject
{
	String_t* ____className;
	String_t* ____message;
	RuntimeObject* ____data;
	Exception_t* ____innerException;
	String_t* ____helpURL;
	RuntimeObject* ____stackTrace;
	String_t* ____stackTraceString;
	String_t* ____remoteStackTraceString;
	int32_t ____remoteStackIndex;
	RuntimeObject* ____dynamicMethods;
	int32_t ____HResult;
	String_t* ____source;
	SafeSerializationManager_tCBB85B95DFD1634237140CD892E82D06ECB3F5E6* ____safeSerializationManager;
	StackTraceU5BU5D_t32FBCB20930EAF5BAE3F450FF75228E5450DA0DF* ___captured_traces;
	IntPtrU5BU5D_tFD177F8C806A6921AD7150264CCC62FA00CAD832* ___native_trace_ips;
	int32_t ___caught_in_unmanaged;
};
struct Exception_t_marshaled_pinvoke
{
	char* ____className;
	char* ____message;
	RuntimeObject* ____data;
	Exception_t_marshaled_pinvoke* ____innerException;
	char* ____helpURL;
	Il2CppIUnknown* ____stackTrace;
	char* ____stackTraceString;
	char* ____remoteStackTraceString;
	int32_t ____remoteStackIndex;
	Il2CppIUnknown* ____dynamicMethods;
	int32_t ____HResult;
	char* ____source;
	SafeSerializationManager_tCBB85B95DFD1634237140CD892E82D06ECB3F5E6* ____safeSerializationManager;
	StackTraceU5BU5D_t32FBCB20930EAF5BAE3F450FF75228E5450DA0DF* ___captured_traces;
	Il2CppSafeArray* ___native_trace_ips;
	int32_t ___caught_in_unmanaged;
};
struct Exception_t_marshaled_com
{
	Il2CppChar* ____className;
	Il2CppChar* ____message;
	RuntimeObject* ____data;
	Exception_t_marshaled_com* ____innerException;
	Il2CppChar* ____helpURL;
	Il2CppIUnknown* ____stackTrace;
	Il2CppChar* ____stackTraceString;
	Il2CppChar* ____remoteStackTraceString;
	int32_t ____remoteStackIndex;
	Il2CppIUnknown* ____dynamicMethods;
	int32_t ____HResult;
	Il2CppChar* ____source;
	SafeSerializationManager_tCBB85B95DFD1634237140CD892E82D06ECB3F5E6* ____safeSerializationManager;
	StackTraceU5BU5D_t32FBCB20930EAF5BAE3F450FF75228E5450DA0DF* ___captured_traces;
	Il2CppSafeArray* ___native_trace_ips;
	int32_t ___caught_in_unmanaged;
};
struct FindObjectsSortMode_t3C83F8C6588F54EBB0CEB21F79D54CD19460AE9E 
{
	int32_t ___value__;
};
struct LoadSceneMode_t3E17ADA25A3C4F14ECF6026741219437DA054963 
{
	int32_t ___value__;
};
struct MethodInfo_t  : public MethodBase_t
{
};
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C  : public RuntimeObject
{
	intptr_t ___m_CachedPtr;
};
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_pinvoke
{
	intptr_t ___m_CachedPtr;
};
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_com
{
	intptr_t ___m_CachedPtr;
};
struct QualityPreset_tC1B53DB7C5BF9A1BDB8F9DEC3D2B33A0E33A2543 
{
	int32_t ___value__;
};
struct Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00 
{
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___m_Origin;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___m_Direction;
};
struct RenderingPath_t8FE80D49AAC236E30E65DAB2FCDB53A4151B654D 
{
	int32_t ___value__;
};
struct RuntimeFieldHandle_t6E4C45B6D2EA12FC99185805A7E77527899B25C5 
{
	intptr_t ___value;
};
struct RuntimeTypeHandle_t332A452B8B6179E4469B69525D0FE82A88030F7B 
{
	intptr_t ___value;
};
struct SceneHandle_t4C3B517546B91EF78A6ED15DDC6C54AB5E03D8A3 
{
	EntityId_t982FBD037EAC5CA077B1602A7EA40E3523AA0FC8 ___m_Value;
};
struct ScreenOrientation_t928A8AFB38625B9356E57BA75BBD90FA653DCFC2 
{
	int32_t ___value__;
};
struct SessionState_tB41709513F8186320155D493FD85007914DAF452 
{
	int32_t ___value__;
};
struct StringComparison_tE14A55CCFA001A5AC85D754179BF2888F45CC94D 
{
	int32_t ___value__;
};
struct TouchPhase_t54E0A1AF80465997849420A72317B733E1D49A9E 
{
	int32_t ___value__;
};
struct TouchType_t84F82C73BC1A6012141735AD84DA67AA7F7AB43F 
{
	int32_t ___value__;
};
struct Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3  : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C
{
};
struct GameObject_t76FEDD663AB33C991A9C9A23129337651094216F  : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C
{
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
struct Scene_tA1DC762B79745EB5140F054C884855B922318356 
{
	SceneHandle_t4C3B517546B91EF78A6ED15DDC6C54AB5E03D8A3 ___m_Handle;
};
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A  : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C
{
};
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A_marshaled_pinvoke : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_pinvoke
{
};
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A_marshaled_com : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_com
{
};
struct Touch_t03E51455ED508492B3F278903A0114FA0E87B417 
{
	int32_t ___m_FingerId;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___m_Position;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___m_RawPosition;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___m_PositionDelta;
	float ___m_TimeDelta;
	int32_t ___m_TapCount;
	int32_t ___m_Phase;
	int32_t ___m_Type;
	float ___m_Pressure;
	float ___m_maximumPossiblePressure;
	float ___m_Radius;
	float ___m_RadiusVariance;
	float ___m_AltitudeAngle;
	float ___m_AzimuthAngle;
};
struct Type_t  : public MemberInfo_t
{
	RuntimeTypeHandle_t332A452B8B6179E4469B69525D0FE82A88030F7B ____impl;
};
struct Action_2_t0573B13685F7D1632AFBF12A72947EC189082208  : public MulticastDelegate_t
{
};
struct Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8  : public MulticastDelegate_t
{
};
struct GenericEventChannelSO_1_t8D716B7E7446940F16504CA7E0AAD35DA7CE8F6E  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_tB2FB3A51525B691C3FF8B27FD20E9C31736D1713* ____listeners;
};
struct GenericEventChannelSO_1_t5AC28C96BE6309EA31ADB7FB6DAAE59DBE4AAFEA  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_t1380C530A5D2929C738AA31853B9EA4A6757EA30* ____listeners;
};
struct GenericEventChannelSO_1_tFDABE3C9DDB21BA0C689D8B649DD8B4B3F3E6F38  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_t4B1084108031EF9530DD18F6C30A4BAF00462C0B* ____listeners;
};
struct GenericEventChannelSO_1_t94C91634A143708415B4CA825916B3CEE57BCD1B  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_t71EFF5A5F787719FCA16651E55B031F15ECF78AB* ____listeners;
};
struct GenericEventChannelSO_1_tB6EF6389EEEA591B0EF70C0FB1917E9E68C12FC1  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_tBB25F7EA475FB5AB9F915049CB3BB346A234C92C* ____listeners;
};
struct UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A  : public MulticastDelegate_t
{
};
struct Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07  : public MulticastDelegate_t
{
};
struct Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA  : public Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3
{
};
struct Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1  : public Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3
{
};
struct VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	List_1_tDB72209F35D56F62A287633F9450978E90B90987* ____listeners;
};
struct AudioBehaviour_t2DC0BEF7B020C952F3D2DA5AAAC88501C7EEB941  : public Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA
{
};
struct BoolEventChannelSO_t9A16108D782FA74ABE10D2C07CECBE863E7CDF32  : public GenericEventChannelSO_1_t8D716B7E7446940F16504CA7E0AAD35DA7CE8F6E
{
};
struct Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184  : public Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA
{
	uint32_t ___m_NonSerializedVersion;
};
struct FloatEventChannelSO_t3024DD408E0E10E9D724C0752D12BD4E01AF7BAC  : public GenericEventChannelSO_1_t94C91634A143708415B4CA825916B3CEE57BCD1B
{
};
struct IntEventChannelSO_t70D68D92C915B0A21096F763ADB17BC18E5F2B0D  : public GenericEventChannelSO_1_t5AC28C96BE6309EA31ADB7FB6DAAE59DBE4AAFEA
{
};
struct MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71  : public Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA
{
	CancellationTokenSource_tAAE1E0033BCFC233801F8CB4CED5C852B350CB7B* ___m_CancellationTokenSource;
};
struct QualityPresetEventChannelSO_tE1C99F5541B59D973E5C3BDEDA3F7D96C0C58CE1  : public GenericEventChannelSO_1_tFDABE3C9DDB21BA0C689D8B649DD8B4B3F3E6F38
{
};
struct StringEventChannelSO_t1B8C059DCA2CBC16BC4FB5F811A657EB888AB994  : public GenericEventChannelSO_1_tB6EF6389EEEA591B0EF70C0FB1917E9E68C12FC1
{
};
struct AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35  : public AudioBehaviour_t2DC0BEF7B020C952F3D2DA5AAAC88501C7EEB941
{
};
struct VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02  : public MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71
{
	Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* ____headTransform;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ____leftEyeCamera;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ____rightEyeCamera;
	AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* ____headAudioListener;
	float ____ipdMeters;
	bool ____isVrMode;
	bool ____enableGyroTracking;
	float ____touchSensitivity;
	float ____panSmoothing;
	float ____minPitch;
	float ____maxPitch;
	bool ____enableEditorMouseLook;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ____leftEyeLocalPosStereo;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ____rightEyeLocalPosStereo;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ____eyeLocalPosMono;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ____recalibrationOffset;
	bool ____hasGyro;
	bool ____isInitialized;
	float ____targetYaw;
	float ____targetPitch;
	float ____currentYaw;
	float ____currentPitch;
};
struct List_1_tDB72209F35D56F62A287633F9450978E90B90987_StaticFields
{
	ActionU5BU5D_tF6161335A0A12A221AB081D78725C8AB6FE506D2* ___s_emptyArray;
};
struct List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A_StaticFields
{
	__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* ___s_emptyArray;
};
struct U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A_StaticFields
{
	__StaticArrayInitTypeSizeU3D588_tF62990ADF2BCF3774E5F60709830E5D35490CB0B ___43391750B3DD3EB770B251CD65ACC059FEE2FB06EC7DDE49315C1CAEF4178376;
	__StaticArrayInitTypeSizeU3D802_tE181652709C351E05532E1537B9B9BCFF4DDEDF8 ___957CE894FD2093C88F7ED5A6047325DC43F03D67652BC252AE0EED3A78FB8453;
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
struct Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974_StaticFields
{
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___identityQuaternion;
};
struct Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D_StaticFields
{
	Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D ___kZero;
};
struct Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7_StaticFields
{
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___zeroVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___oneVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___upVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___downVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___leftVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___rightVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___positiveInfinityVector;
	Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 ___negativeInfinityVector;
};
struct Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2_StaticFields
{
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___zeroVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___oneVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___upVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___downVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___leftVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___rightVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___forwardVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___backVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___positiveInfinityVector;
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___negativeInfinityVector;
};
struct Exception_t_StaticFields
{
	RuntimeObject* ___s_EDILock;
};
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_StaticFields
{
	int32_t ___OffsetOfInstanceIDInCPlusPlusObject;
};
struct Type_t_StaticFields
{
	Binder_t91BFCE95A7057FADF4D8A1A342AFE52872246235* ___s_defaultBinder;
	Il2CppChar ___Delimiter;
	TypeU5BU5D_t97234E1129B564EB38B8D85CAC2AD8B5B9522FFB* ___EmptyTypes;
	RuntimeObject* ___Missing;
	MemberFilter_tF644F1AE82F611B677CE1964D5A3277DDA21D553* ___FilterAttribute;
	MemberFilter_tF644F1AE82F611B677CE1964D5A3277DDA21D553* ___FilterName;
	MemberFilter_tF644F1AE82F611B677CE1964D5A3277DDA21D553* ___FilterNameIgnoreCase;
};
struct Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_StaticFields
{
	CameraCallback_t844E527BFE37BC0495E7F67993E43C07642DA9DD* ___onPreCull;
	CameraCallback_t844E527BFE37BC0495E7F67993E43C07642DA9DD* ___onPreRender;
	CameraCallback_t844E527BFE37BC0495E7F67993E43C07642DA9DD* ___onPostRender;
};
struct VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields
{
	VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* ____instance;
	bool ___U3CGlobalIsVrModeU3Ek__BackingField;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___BaseOrientation;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___LandscapeLeftCompensation;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___LandscapeRightCompensation;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___PortraitCompensation;
	Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D ___RectStereoLeft;
	Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D ___RectStereoRight;
	Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D ___RectMonoFullScreen;
};
#ifdef __clang__
#pragma clang diagnostic pop
#endif
struct ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031  : public RuntimeArray
{
	ALIGN_FIELD (8) uint8_t m_Items[1];

	inline uint8_t GetAt(il2cpp_array_size_t index) const
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items[index];
	}
	inline uint8_t* GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + index;
	}
	inline void SetAt(il2cpp_array_size_t index, uint8_t value)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		m_Items[index] = value;
	}
	inline uint8_t GetAtUnchecked(il2cpp_array_size_t index) const
	{
		return m_Items[index];
	}
	inline uint8_t* GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + index;
	}
	inline void SetAtUnchecked(il2cpp_array_size_t index, uint8_t value)
	{
		m_Items[index] = value;
	}
};
struct CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B  : public RuntimeArray
{
	ALIGN_FIELD (8) Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* m_Items[1];

	inline Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* GetAt(il2cpp_array_size_t index) const
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items[index];
	}
	inline Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184** GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + index;
	}
	inline void SetAt(il2cpp_array_size_t index, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* value)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
	inline Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* GetAtUnchecked(il2cpp_array_size_t index) const
	{
		return m_Items[index];
	}
	inline Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184** GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + index;
	}
	inline void SetAtUnchecked(il2cpp_array_size_t index, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* value)
	{
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
};
struct AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F  : public RuntimeArray
{
	ALIGN_FIELD (8) AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* m_Items[1];

	inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* GetAt(il2cpp_array_size_t index) const
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items[index];
	}
	inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35** GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + index;
	}
	inline void SetAt(il2cpp_array_size_t index, AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* value)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
	inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* GetAtUnchecked(il2cpp_array_size_t index) const
	{
		return m_Items[index];
	}
	inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35** GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + index;
	}
	inline void SetAtUnchecked(il2cpp_array_size_t index, AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* value)
	{
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
};
struct MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7  : public RuntimeArray
{
	ALIGN_FIELD (8) MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* m_Items[1];

	inline MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* GetAt(il2cpp_array_size_t index) const
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items[index];
	}
	inline MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71** GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + index;
	}
	inline void SetAt(il2cpp_array_size_t index, MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* value)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
	inline MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* GetAtUnchecked(il2cpp_array_size_t index) const
	{
		return m_Items[index];
	}
	inline MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71** GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + index;
	}
	inline void SetAtUnchecked(il2cpp_array_size_t index, MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* value)
	{
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
};
struct StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248  : public RuntimeArray
{
	ALIGN_FIELD (8) String_t* m_Items[1];

	inline String_t* GetAt(il2cpp_array_size_t index) const
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items[index];
	}
	inline String_t** GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + index;
	}
	inline void SetAt(il2cpp_array_size_t index, String_t* value)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
	inline String_t* GetAtUnchecked(il2cpp_array_size_t index) const
	{
		return m_Items[index];
	}
	inline String_t** GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + index;
	}
	inline void SetAtUnchecked(il2cpp_array_size_t index, String_t* value)
	{
		m_Items[index] = value;
		Il2CppCodeGenWriteBarrier((void**)m_Items + index, (void*)value);
	}
};
struct __Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC  : public RuntimeArray
{
	ALIGN_FIELD (8) uint8_t m_Items[1];

	inline uint8_t* GetAddressAt(il2cpp_array_size_t index)
	{
		IL2CPP_ARRAY_BOUNDS_CHECK(index, (uint32_t)(this)->max_length);
		return m_Items + il2cpp_array_calc_byte_offset(this, index);
	}
	inline uint8_t* GetAddressAtUnchecked(il2cpp_array_size_t index)
	{
		return m_Items + il2cpp_array_calc_byte_offset(this, index);
	}
};


IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnityAction_2__ctor_m17203366119014F4963976DF6B8E83DE49274252_gshared (UnityAction_2_t742C43FA6EAABE0458C753DFE15FDDFAE01EA73F* __this, RuntimeObject* ___0_object, intptr_t ___1_method, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Component_TryGetComponent_TisIl2CppFullySharedGenericAny_m754E9486E0B3F9C50B4261F1F2088D02098E214B_gshared (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, Il2CppFullySharedGenericAny* ___0_component, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR RuntimeObject* GameObject_AddComponent_TisRuntimeObject_m69B93700FACCF372F5753371C6E8FB780800B824_gshared (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Component_GetComponent_TisIl2CppFullySharedGenericAny_m47CBDD147982125387F078ABBFDAAB92D397A6C2_gshared (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, Il2CppFullySharedGenericAny* il2cppRetVal, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR ObjectU5BU5D_t8061030B0A12A55D5AD8652A20C922FE99450918* Object_FindObjectsByType_TisRuntimeObject_m9F3B83321CD4E4F4F764805ADCEF338CF2BA8409_gshared (int32_t ___0_sortMode, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR __Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* Component_GetComponentsInChildren_TisIl2CppFullySharedGenericAny_mB27BBCE995DC86EC5D047AE9D0804238DA9B4E28_gshared (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, bool ___0_includeInactive, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void JsonUtility_FromJson_TisIl2CppFullySharedGenericAny_mCA9E8A2C7BF60F5C6F2FE4812F33F4C06E5B44D0_gshared (String_t* ___0_json, Il2CppFullySharedGenericAny* il2cppRetVal, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Action_2_Invoke_m6343941059117DF354182855F996EB3D08B4C06C_gshared_inline (Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8* __this, Il2CppFullySharedGenericAny ___0_arg1, Il2CppFullySharedGenericAny ___1_arg2, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared (GenericEventChannelSO_1_t82BDD65F27E341CDD32A08BE4386ABB75CDB94F3* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t List_1_get_Count_mD2ED26ACAF3BAF386FFEA83893BA51DB9FD8BA30_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool List_1_Contains_m8DA550B703DFB328B69C4712064C667D7CA33DF1_gshared (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void List_1_Add_mD4F3498FBD3BDD3F03CBCFB38041CBAC9C28CAFC_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool List_1_Remove_m9BCE8CEF94E6F2BF8624D65214FF4F3CA686D60C_gshared (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void List_1_get_Item_m6E4BA37C1FB558E4A62AE4324212E45D09C5C937_gshared (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, int32_t ___0_index, Il2CppFullySharedGenericAny* il2cppRetVal, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void List_1_Clear_mD615D1BCB2C9DD91DAD86A2F9E5CF1DFFCBF7925_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void List_1__ctor_m3069CACB5775E013107F559C825422266A09F9E8_gshared (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, int32_t ___0_capacity, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_NO_INLINE IL2CPP_METHOD_ATTR void List_1_AddWithResize_mA6DFDBC2B22D6318212C6989A34784BD8303AF33_gshared (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method) ;

IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Attribute__ctor_m79ED1BF1EE36D1E417BA89A0D9F91F8AAD8D19E2 (Attribute_tFDA8EFEFB0711976D22474794576DAF28F7440AA* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void RuntimeHelpers_InitializeArray_m751372AA3F24FBF6DA9B9D687CBFA2DE436CAB9B (RuntimeArray* ___0_array, RuntimeFieldHandle_t6E4C45B6D2EA12FC99185805A7E77527899B25C5 ___1_fldHandle, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2 (RuntimeObject* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, bool ___0_enableVr, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___0_x, Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___1_y, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371 (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Transform_get_position_m69CD5FA214FDAE7BB701552943674846C220FDE1 (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Transform_get_rotation_m32AF40CA0D50C797DA639A696F8EAEC7524C179C (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Transform_get_forward_mFCFACF7165FDAB21E80E384C494DF278386CEE2F (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Ray__ctor_mE298992FD10A3894C38373198385F345C58BD64C_inline (Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00* __this, Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_origin, Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___1_direction, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Input_GetMouseButtonDown_m8DFC792D15FFF15D311614D5CC6C5D055E5A1DE3 (int32_t ___0_button, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___0_x, Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___1_y, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Object_DontDestroyOnLoad_m4B70C3AEF886C176543D1295507B6455C9DCAEA7 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___0_target, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Object_Destroy_mE97D0A766419A81296E8D4E5C23D01D3FE91ACBB (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___0_obj, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_InitializeHardwareAndMath_m269EA7577AD73EA661EDAA4D7CF61179EA3A84C2 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_AutoSetupRig_mB4E61BD00002D79D4CDF37BA86E3DECC26B28B2F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
inline void UnityAction_2__ctor_m0E0C01B7056EB1CB1E6C6F4FC457EBCA3F6B0041 (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A* __this, RuntimeObject* ___0_object, intptr_t ___1_method, const RuntimeMethod* method)
{
	((  void (*) (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A*, RuntimeObject*, intptr_t, const RuntimeMethod*))UnityAction_2__ctor_m17203366119014F4963976DF6B8E83DE49274252_gshared)(__this, ___0_object, ___1_method, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void SceneManager_add_sceneLoaded_m14BEBCC5E4A8DD2C806A48D79A4773315CB434C6 (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A* ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void SceneManager_remove_sceneLoaded_m72A7C2A1B8EF1C21A208A9A015375577768B3978 (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A* ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_GlobalIsVrMode_m58848EB9B12A8C4233CCD1A08CA5F4BB35BED018_inline (const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Vector3__ctor_m376936E6B999EF1ECBE57D990A386303E2283DE0_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, float ___0_x, float ___1_y, float ___2_z, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool SystemInfo_get_supportsGyroscope_m98477EC99D88396F076A93EF5C28A6129DC4E211 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Gyroscope_set_enabled_m2B22BC93369BA61034A80350405FE1B493822DAB (Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* __this, bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Gyroscope_set_updateInterval_m477CB8AF6D656813C14467CCB62EDC3BF1383925 (Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* __this, float ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB (RuntimeObject* ___0_message, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9 (RuntimeObject* ___0_message, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* Transform_Find_m3087032B0E1C5B96A2D2C27020BAEAE2DA08F932 (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, String_t* ___0_n, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void GameObject__ctor_m37D512B05D292F954792225E6C6EEE95293A9B88 (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* __this, String_t* ___0_name, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56 (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Transform_SetParent_m9BDD7B7476714B2D7919B10BDC22CE75C0A0A195 (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* ___0_parent, bool ___1_worldPositionStays, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Vector3_get_zero_m0C1249C3F25B1C70EAD3CC8B31259975A457AE39_inline (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Transform_set_localPosition_mDE1C997F7D79C0885210B7732B4BA50EE7D73134 (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_value, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA (Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* __this, Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___0_value, const RuntimeMethod* method) ;
inline bool Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882 (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184** ___0_component, const RuntimeMethod* method)
{
	return ((  bool (*) (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3*, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184**, const RuntimeMethod*))Component_TryGetComponent_TisIl2CppFullySharedGenericAny_m754E9486E0B3F9C50B4261F1F2088D02098E214B_gshared)(__this, ___0_component, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* Camera_get_main_m52C992F18E05355ABB9EEB64A4BF2215E12762DF (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Object_set_name_mC79E6DC8FFD72479C90F0C4CC7F42A0FEAF5AE47 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* __this, String_t* ___0_value, const RuntimeMethod* method) ;
inline Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142 (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* __this, const RuntimeMethod* method)
{
	return ((  Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* (*) (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F*, const RuntimeMethod*))GameObject_AddComponent_TisRuntimeObject_m69B93700FACCF372F5753371C6E8FB780800B824_gshared)(__this, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Component_set_tag_mAF8B6EC052F8AA67088F1841B57EA37F13D0451E (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, String_t* ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_nearClipPlane_m78482B5E4E0CE4C195D9CE0332AA75B2D9CCDDF6 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, float ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_farClipPlane_m84EF39B09573168734613481FD979BFF31C60139 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, float ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_CopyCameraSettings_m9330BC1529F0DA8E737B1F3A3D5D40944FB7C63F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ___0_source, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ___1_destination, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_EnsureSingleAudioListener_m73DA48FDAA6C1556710392B7C831316AF5F16E5A (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_DisableConflictingPoseDrivers_mC0EFFF6591DA7104A001E7C857BA41DCD7A0DD1D (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B* Camera_get_allCameras_m04BE279D34E474DEAF8237A5509CF2C0E6865571 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A (Behaviour_t01970CFBBA658497AE30F311C447DB0440BAB7FA* __this, bool ___0_value, const RuntimeMethod* method) ;
inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* Component_GetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m18720A555FC6A050CCD144559DC24C2DD39FDB0B (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, const RuntimeMethod* method)
{
	AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* il2cppRetVal;
	((  void (*) (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3*, Il2CppFullySharedGenericAny*, const RuntimeMethod*))Component_GetComponent_TisIl2CppFullySharedGenericAny_m47CBDD147982125387F078ABBFDAAB92D397A6C2_gshared)((Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3*)__this, (Il2CppFullySharedGenericAny*)&il2cppRetVal, method);
	return il2cppRetVal;
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* Object_get_name_mAC2F6B897CF1303BA4249B4CB55271AFACBB6392 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Concat_m8855A6DE10F84DA7F4EC113CADDB59873A25573B (String_t* ___0_str0, String_t* ___1_str1, String_t* ___2_str2, const RuntimeMethod* method) ;
inline bool Component_TryGetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m6BA3859778F8DD9E3AB12FB8CDAD6EB9BA75CAA5 (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35** ___0_component, const RuntimeMethod* method)
{
	return ((  bool (*) (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3*, AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35**, const RuntimeMethod*))Component_TryGetComponent_TisIl2CppFullySharedGenericAny_m754E9486E0B3F9C50B4261F1F2088D02098E214B_gshared)(__this, ___0_component, method);
}
inline AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* GameObject_AddComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_mA30AC51FE6287A9D0057077D99F694600A3D844E (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* __this, const RuntimeMethod* method)
{
	return ((  AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* (*) (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F*, const RuntimeMethod*))GameObject_AddComponent_TisRuntimeObject_m69B93700FACCF372F5753371C6E8FB780800B824_gshared)(__this, method);
}
inline AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* Object_FindObjectsByType_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m41F4E631A15C9290412B4A4BC98BAC8FA83CD5C6 (int32_t ___0_sortMode, const RuntimeMethod* method)
{
	return ((  AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* (*) (int32_t, const RuntimeMethod*))Object_FindObjectsByType_TisRuntimeObject_m9F3B83321CD4E4F4F764805ADCEF338CF2BA8409_gshared)(___0_sortMode, method);
}
inline MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* Component_GetComponentsInChildren_TisMonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71_m802D8975EFA14B49D71AFFBCCE19FBB480EE0C66 (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3* __this, bool ___0_includeInactive, const RuntimeMethod* method)
{
	return ((  MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* (*) (Component_t39FBE53E5EFCF4409111FB22C15FF73717632EC3*, bool, const RuntimeMethod*))Component_GetComponentsInChildren_TisIl2CppFullySharedGenericAny_mB27BBCE995DC86EC5D047AE9D0804238DA9B4E28_gshared)(__this, ___0_includeInactive, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Type_t* Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3 (RuntimeObject* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool String_Contains_m6D77B121FADA7CA5F397C0FABB65DA62DF03B6C3 (String_t* __this, String_t* ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Concat_m647EBF831F54B6DF7D5AFA5FD012CF4EE7571B6A (StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* ___0_values, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t Camera_get_clearFlags_mA74F538C124B391EF03C46A50CA7FF7B505B7602 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_clearFlags_m66541D9CC43CBAA5FE7364A50D43CA5569FD4D93 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, int32_t ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Color_tD001788D726C3A7F1379BEED0260B9591F440C1F Camera_get_backgroundColor_m1577A81D1E6A91D7934CECB8A284AA2D4704D96F (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_backgroundColor_m036FD8C316A93A0B168ACC89AFF16D396B872138 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, Color_tD001788D726C3A7F1379BEED0260B9591F440C1F ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t Camera_get_cullingMask_m6F5AFF8FB522F876D99E839BF77D8F27F26A1EF8 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_cullingMask_m14F426710530BA8FA53AEC02F79C418AA558CB32 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, int32_t ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Camera_get_orthographic_m904DEFC76C54DA4E30C20A62A86D5D87B7D4DD8F (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_orthographic_m64915C0840A68E526830A69F1C40257206185020 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR float Camera_get_fieldOfView_m9A93F17BBF89F496AE231C21817AFD1C1E833FBB (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_fieldOfView_m5AA9EED4D1603A1DEDBF883D9C42814B2BDEB777 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, float ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR float Camera_get_nearClipPlane_m5E8FAF84326E3192CB036BD29DCCDAF6A9861013 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR float Camera_get_farClipPlane_m1D7128B85B5DB866F75FBE8CEBA48335716B67BD (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR float Camera_get_depth_mDF67FFF8ED61750467DFC4C6D8F236850AD1BB1D (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_depth_m595FA2A4FEBC90E730810BBFB55E4A2C2134066F (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, float ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t Camera_get_renderingPath_m4011069F4C73EFF95BCB322E354C7E01C2D38CCF (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_renderingPath_m5BD8E4230DE3DD68F722AED5D85271E2A2B026B3 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, int32_t ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Camera_get_useOcclusionCulling_m7A138C52EB27EB62A0D1197D5557B075F9ED53B1 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_useOcclusionCulling_mD3036B0CBB5E6A1BF33810AB8FDEE3CD1A4D7C04 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Camera_get_allowHDR_m3187E9118CB52D5D7F0658D7ECF5E2B00E296A67 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_allowHDR_m44211153DAF6DF9A51142EC7760A53777C1F3315 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Camera_get_allowMSAA_mC316155B22B679709F85BA9AE3F7931C30EE7AF4 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_allowMSAA_m7BE26D3FAAA64202C49DE6CA95C02A85770F8268 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Camera_set_rect_mA81158BC169AF8674DE240AE9460FC5A0EADBB19 (Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* __this, Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Gyroscope_get_enabled_m10F5B3F646AB1A6EEE2831010642E9E1E0BCBDB9 (Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Format_mA0534D6E2AE4D67A6BD8D45B3321323930EB930C (String_t* ___0_format, RuntimeObject* ___1_arg0, RuntimeObject* ___2_arg1, RuntimeObject* ___3_arg2, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline (float ___0_x, float ___1_y, float ___2_z, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Repeat_m6F1560A163481BB311D685294E1B463C3E4EB3BA_inline (float ___0_t, float ___1_length, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Clamp_mEB9AEA827D27D20FCC787F7375156AF46BB12BBF_inline (float ___0_value, float ___1_min, float ___2_max, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool String_IsNullOrEmpty_mEA9E3FB005AC28FE02E69FCF95A7B8456192B478 (String_t* ___0_value, const RuntimeMethod* method) ;
inline RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* JsonUtility_FromJson_TisRotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA_m0DC882EF0486A2C8429FE72EF58E917FFF8203C3 (String_t* ___0_json, const RuntimeMethod* method)
{
	RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* il2cppRetVal;
	((  void (*) (String_t*, Il2CppFullySharedGenericAny*, const RuntimeMethod*))JsonUtility_FromJson_TisIl2CppFullySharedGenericAny_mCA9E8A2C7BF60F5C6F2FE4812F33F4C06E5B44D0_gshared)(___0_json, (Il2CppFullySharedGenericAny*)&il2cppRetVal, method);
	return il2cppRetVal;
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RotateCamera_m2EF3E3A2F7E473642F2DA795256A4AF03152F82E (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, float ___0_dx, float ___1_dy, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Concat_m093934F71A9B351911EE46311674ED463B180006 (String_t* ___0_str0, String_t* ___1_str1, String_t* ___2_str2, String_t* ___3_str3, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void VRStereoCameraRig_set_GlobalIsVrMode_m6109AA5B3EE40574B27EFE754C4C41397246BC97_inline (bool ___0_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool String_op_Equality_m030E1B219352228970A076136E455C4E568C02C1 (String_t* ___0_a, String_t* ___1_b, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool String_Equals_mCC34895D0DB2AD440C9D8767032215BC86B5C48B (String_t* ___0_a, String_t* ___1_b, int32_t ___2_comparisonType, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Gyroscope_get_attitude_mF6D8131ED2D0E5BF979C7FC4AAC99E87A01CBE85 (Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Quaternion__ctor_m868FD60AA65DD5A8AC0C5DEB0608381A8D85FCD8_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974* __this, float ___0_x, float ___1_y, float ___2_z, float ___3_w, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t Screen_get_orientation_mA6B22A441187D50831B2B18CA48A8F64BD1BD89E (const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___0_lhs, Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___1_rhs, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Quaternion_get_eulerAngles_m2DB5158B5C3A71FD60FC8A6EE43D3AAA1CFED122_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Format_mA8DBB4C2516B9723C5A41E6CB1E2FAF4BBE96DD8 (String_t* ___0_format, RuntimeObject* ___1_arg0, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t Input_get_touchCount_m057388BFC67A0F4CA53764B1022867ED81D01E39 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Touch_t03E51455ED508492B3F278903A0114FA0E87B417 Input_GetTouch_m75D99FE801A94279874FA8DC6B6ADAD35F5123B1 (int32_t ___0_index, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t Touch_get_phase_mB82409FB2BE1C32ABDBA6A72E52A099D28AB70B0_inline (Touch_t03E51455ED508492B3F278903A0114FA0E87B417* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 Touch_get_deltaPosition_m2D51F960B74C94821ED0F6A09E44C80FD796D299_inline (Touch_t03E51455ED508492B3F278903A0114FA0E87B417* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR float Time_get_unscaledDeltaTime_mF057EECA857E5C0F90A3F910D26D3EE59F27C4B5 (const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_LerpAngle_m0653422E15193C2E4A4E5AF05236B6315C789C23_inline (float ___0_a, float ___1_b, float ___2_t, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Lerp_m47EF2FFB7647BD0A1FDC26DC03E28B19812139B5_inline (float ___0_a, float ___1_b, float ___2_t, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* Scene_get_name_m3C818DFA663E159274DAD823B780C7616C5E2A8C (Scene_tA1DC762B79745EB5140F054C884855B922318356* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C* Resources_UnloadUnusedAssets_m4003CD3EBC3AC2738DE9F2960D5BC45818C1F12B (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void GC_Collect_m43D435501E4B72E382DB08A0431DE01D550F76A7 (const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Type_op_Inequality_m83209C7BB3C05DFBEA3B6199B0BEFE8037301172 (Type_t* ___0_left, Type_t* ___1_right, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR EventInfo_t* Type_GetEvent_mB4D71EF747D967D102846CB4FADA5DA0291E6A83 (Type_t* __this, String_t* ___0_name, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool EventInfo_op_Inequality_m4B5352D516359B10994084CAE273A1EF64E50B40 (EventInfo_t* ___0_left, EventInfo_t* ___1_right, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR MethodInfo_t* Type_GetMethod_m66AD062187F19497DBCA900823B0C268322DC231 (Type_t* __this, String_t* ___0_name, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Delegate_t* Delegate_CreateDelegate_mE2117ED279628E4E63D357AFAB3653DD909CB2D7 (Type_t* ___0_type, RuntimeObject* ___1_firstArgument, MethodInfo_t* ___2_method, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR String_t* String_Concat_m9E3155FB84015C823606188F53B47CB44C444991 (String_t* ___0_str0, String_t* ___1_str1, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void MonoBehaviour__ctor_m592DB0105CA0BC97AA1C5F4AD27B12D68A3B7C1E (MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Rect__ctor_m18C3033D135097BEE424AAA68D91C706D2647F23_inline (Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D* __this, float ___0_x, float ___1_y, float ___2_width, float ___3_height, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Delegate_t* Delegate_Combine_m1F725AEF318BE6F0426863490691A6F4606E7D00 (Delegate_t* ___0_a, Delegate_t* ___1_b, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Delegate_t* Delegate_Remove_m8B7DD5661308FA972E23CA1CC3FC9CEB355504E3 (Delegate_t* ___0_source, Delegate_t* ___1_value, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Debug_LogError_mB00B2B4468EF3CAF041B038D840820FB84C924B2 (RuntimeObject* ___0_message, const RuntimeMethod* method) ;
inline void Action_2_Invoke_mA60F6B56FCF50002888F967B8D4EF9D27DA99CFF_inline (Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* __this, RuntimeObject* ___0_arg1, RuntimeObject* ___1_arg2, const RuntimeMethod* method)
{
	((  void (*) (Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8*, Il2CppFullySharedGenericAny, Il2CppFullySharedGenericAny, const RuntimeMethod*))Action_2_Invoke_m6343941059117DF354182855F996EB3D08B4C06C_gshared_inline)((Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8*)__this, (Il2CppFullySharedGenericAny)___0_arg1, (Il2CppFullySharedGenericAny)___1_arg2, method);
}
inline void GenericEventChannelSO_1__ctor_mA74BA91BA6D1979DAC4F47F402DFC007C2C45E2F (GenericEventChannelSO_1_t8D716B7E7446940F16504CA7E0AAD35DA7CE8F6E* __this, const RuntimeMethod* method)
{
	((  void (*) (GenericEventChannelSO_1_t8D716B7E7446940F16504CA7E0AAD35DA7CE8F6E*, const RuntimeMethod*))GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared)(__this, method);
}
inline void GenericEventChannelSO_1__ctor_mA81A109554A78181BB23114752E3B9BEDB8CF01A (GenericEventChannelSO_1_t94C91634A143708415B4CA825916B3CEE57BCD1B* __this, const RuntimeMethod* method)
{
	((  void (*) (GenericEventChannelSO_1_t94C91634A143708415B4CA825916B3CEE57BCD1B*, const RuntimeMethod*))GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared)(__this, method);
}
inline void GenericEventChannelSO_1__ctor_mC2FDABB71598996FE8DB22F384677A6ED000DE46 (GenericEventChannelSO_1_t5AC28C96BE6309EA31ADB7FB6DAAE59DBE4AAFEA* __this, const RuntimeMethod* method)
{
	((  void (*) (GenericEventChannelSO_1_t5AC28C96BE6309EA31ADB7FB6DAAE59DBE4AAFEA*, const RuntimeMethod*))GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared)(__this, method);
}
inline void GenericEventChannelSO_1__ctor_mCC1C0EE91DA2D5F6DD88E51F10405EC6D88AF9BF (GenericEventChannelSO_1_tFDABE3C9DDB21BA0C689D8B649DD8B4B3F3E6F38* __this, const RuntimeMethod* method)
{
	((  void (*) (GenericEventChannelSO_1_tFDABE3C9DDB21BA0C689D8B649DD8B4B3F3E6F38*, const RuntimeMethod*))GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared)(__this, method);
}
inline void GenericEventChannelSO_1__ctor_mF75F9F4F07B28C70BAC3EF57E4F63759F2C3B3A5 (GenericEventChannelSO_1_tB6EF6389EEEA591B0EF70C0FB1917E9E68C12FC1* __this, const RuntimeMethod* method)
{
	((  void (*) (GenericEventChannelSO_1_tB6EF6389EEEA591B0EF70C0FB1917E9E68C12FC1*, const RuntimeMethod*))GenericEventChannelSO_1__ctor_m3DBCB0D9A789C0A3B734D946F00822A540C4400E_gshared)(__this, method);
}
inline int32_t List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_inline (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, const RuntimeMethod* method)
{
	return ((  int32_t (*) (List_1_tDB72209F35D56F62A287633F9450978E90B90987*, const RuntimeMethod*))List_1_get_Count_mD2ED26ACAF3BAF386FFEA83893BA51DB9FD8BA30_gshared_inline)(__this, method);
}
inline bool List_1_Contains_m181F2DB6756B1ADDCEC909ADA27A8FDDBD18C002 (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* ___0_item, const RuntimeMethod* method)
{
	return ((  bool (*) (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*, Il2CppFullySharedGenericAny, const RuntimeMethod*))List_1_Contains_m8DA550B703DFB328B69C4712064C667D7CA33DF1_gshared)((List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*)__this, (Il2CppFullySharedGenericAny)___0_item, method);
}
inline void List_1_Add_m5B99D67CB378BFA8A1142343F9DB44D94322EAD3_inline (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* ___0_item, const RuntimeMethod* method)
{
	((  void (*) (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*, Il2CppFullySharedGenericAny, const RuntimeMethod*))List_1_Add_mD4F3498FBD3BDD3F03CBCFB38041CBAC9C28CAFC_gshared_inline)((List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*)__this, (Il2CppFullySharedGenericAny)___0_item, method);
}
inline bool List_1_Remove_m2F58C9F48DA11B2DF2D297626E97A25B1050D822 (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* ___0_item, const RuntimeMethod* method)
{
	return ((  bool (*) (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*, Il2CppFullySharedGenericAny, const RuntimeMethod*))List_1_Remove_m9BCE8CEF94E6F2BF8624D65214FF4F3CA686D60C_gshared)((List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*)__this, (Il2CppFullySharedGenericAny)___0_item, method);
}
inline Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, int32_t ___0_index, const RuntimeMethod* method)
{
	Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* il2cppRetVal;
	((  void (*) (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*, int32_t, Il2CppFullySharedGenericAny*, const RuntimeMethod*))List_1_get_Item_m6E4BA37C1FB558E4A62AE4324212E45D09C5C937_gshared)((List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*)__this, ___0_index, (Il2CppFullySharedGenericAny*)&il2cppRetVal, method);
	return il2cppRetVal;
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Action_Invoke_m7126A54DACA72B845424072887B5F3A51FC3808E_inline (Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* __this, const RuntimeMethod* method) ;
inline void List_1_Clear_m344AD90676A608EA37B9DF93050BA9F80C23D17E_inline (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, const RuntimeMethod* method)
{
	((  void (*) (List_1_tDB72209F35D56F62A287633F9450978E90B90987*, const RuntimeMethod*))List_1_Clear_mD615D1BCB2C9DD91DAD86A2F9E5CF1DFFCBF7925_gshared_inline)(__this, method);
}
inline void List_1__ctor_mEBBE8A30276CDE4C03E41569F6553229F093035E (List_1_tDB72209F35D56F62A287633F9450978E90B90987* __this, int32_t ___0_capacity, const RuntimeMethod* method)
{
	((  void (*) (List_1_tDB72209F35D56F62A287633F9450978E90B90987*, int32_t, const RuntimeMethod*))List_1__ctor_m3069CACB5775E013107F559C825422266A09F9E8_gshared)(__this, ___0_capacity, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void ScriptableObject__ctor_mD037FDB0B487295EA47F79A4DB1BF1846C9087FF (ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A* __this, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Vector3_Normalize_mC749B887A4C74BA0A2E13E6377F17CCAEB0AADA8_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_Internal_FromEulerRad_mD0C4C0EFE1D70EC0EA4A92B11F1A4D5B0A134E49 (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* ___0_euler, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Quaternion_Internal_ToEulerRad_mC5BD020889B5A4FB6894CFB69A5D4C07B321B919 (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974* ___0_rotation, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Vector3_op_Multiply_m87BA7C578F96C8E49BB07088DAAC4649F83B0353_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_a, float ___1_d, const RuntimeMethod* method) ;
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Quaternion_Internal_MakePositive_m73E2D01920CB0DFE661A55022C129E8617F0C9A8 (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_euler, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Clamp01_mA7E048DBDA832D399A581BE4D6DED9FA44CE0F14_inline (float ___0_value, const RuntimeMethod* method) ;
inline void List_1_AddWithResize_mA6DFDBC2B22D6318212C6989A34784BD8303AF33 (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method)
{
	((  void (*) (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*, Il2CppFullySharedGenericAny, const RuntimeMethod*))List_1_AddWithResize_mA6DFDBC2B22D6318212C6989A34784BD8303AF33_gshared)((List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A*)__this, ___0_item, method);
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Array_Clear_m50BAA3751899858B097D3FF2ED31F284703FE5CB (RuntimeArray* ___0_array, int32_t ___1_index, int32_t ___2_length, const RuntimeMethod* method) ;
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Vector3_get_magnitude_mF0D6017E90B345F1F52D1CC564C640F1A847AF2D_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, const RuntimeMethod* method) ;
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
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void EmbeddedAttribute__ctor_m948CE11E21D2F2F9F10C21443472040027B803D2 (EmbeddedAttribute_tA7D5468C6D3F39D2C974C36BC3E6721320294217* __this, const RuntimeMethod* method) 
{
	{
		Attribute__ctor_m79ED1BF1EE36D1E417BA89A0D9F91F8AAD8D19E2(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void NullableAttribute__ctor_m4D2D6E8600D73A52F9BA9547B2ECF3AA78A29B57 (NullableAttribute_t82D15F098529F06E211478717327DD391DCD9D9B* __this, uint8_t ___0_p, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Attribute__ctor_m79ED1BF1EE36D1E417BA89A0D9F91F8AAD8D19E2(__this, NULL);
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_0 = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)SZArrayNew(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var, (uint32_t)1);
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_1 = L_0;
		uint8_t L_2 = ___0_p;
		NullCheck(L_1);
		(L_1)->SetAt(static_cast<il2cpp_array_size_t>(0), (uint8_t)L_2);
		__this->___NullableFlags = L_1;
		Il2CppCodeGenWriteBarrier((void**)(&__this->___NullableFlags), (void*)L_1);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void NullableAttribute__ctor_m9EBDF2E1CEAD0B8100549117868E09C7735C2089 (NullableAttribute_t82D15F098529F06E211478717327DD391DCD9D9B* __this, ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* ___0_p, const RuntimeMethod* method) 
{
	{
		Attribute__ctor_m79ED1BF1EE36D1E417BA89A0D9F91F8AAD8D19E2(__this, NULL);
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_0 = ___0_p;
		__this->___NullableFlags = L_0;
		Il2CppCodeGenWriteBarrier((void**)(&__this->___NullableFlags), (void*)L_0);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void NullableContextAttribute__ctor_mA7592E8312DC1DDA1030E4073BED95DFB9E98E9C (NullableContextAttribute_t1A534AEEDCB6F8CE900B734C9A370AF7951399B0* __this, uint8_t ___0_p, const RuntimeMethod* method) 
{
	{
		Attribute__ctor_m79ED1BF1EE36D1E417BA89A0D9F91F8AAD8D19E2(__this, NULL);
		uint8_t L_0 = ___0_p;
		__this->___Flag = L_0;
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE UnitySourceGeneratedAssemblyMonoScriptTypes_v1_Get_m031399D7FF5D8AFEEBD51ED2B284134E797EDB98 (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____43391750B3DD3EB770B251CD65ACC059FEE2FB06EC7DDE49315C1CAEF4178376_FieldInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____957CE894FD2093C88F7ED5A6047325DC43F03D67652BC252AE0EED3A78FB8453_FieldInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE V_0;
	memset((&V_0), 0, sizeof(V_0));
	{
		il2cpp_codegen_initobj((&V_0), sizeof(MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE));
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_0 = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)SZArrayNew(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var, (uint32_t)((int32_t)802));
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_1 = L_0;
		RuntimeFieldHandle_t6E4C45B6D2EA12FC99185805A7E77527899B25C5 L_2 = { reinterpret_cast<intptr_t> (U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____957CE894FD2093C88F7ED5A6047325DC43F03D67652BC252AE0EED3A78FB8453_FieldInfo_var) };
		RuntimeHelpers_InitializeArray_m751372AA3F24FBF6DA9B9D687CBFA2DE436CAB9B((RuntimeArray*)L_1, L_2, NULL);
		(&V_0)->___FilePathsData = L_1;
		Il2CppCodeGenWriteBarrier((void**)(&(&V_0)->___FilePathsData), (void*)L_1);
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_3 = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)SZArrayNew(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031_il2cpp_TypeInfo_var, (uint32_t)((int32_t)588));
		ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031* L_4 = L_3;
		RuntimeFieldHandle_t6E4C45B6D2EA12FC99185805A7E77527899B25C5 L_5 = { reinterpret_cast<intptr_t> (U3CPrivateImplementationDetailsU3E_t20F83A06BCE56A9EBAF46B43ABDDFD235888121A____43391750B3DD3EB770B251CD65ACC059FEE2FB06EC7DDE49315C1CAEF4178376_FieldInfo_var) };
		RuntimeHelpers_InitializeArray_m751372AA3F24FBF6DA9B9D687CBFA2DE436CAB9B((RuntimeArray*)L_4, L_5, NULL);
		(&V_0)->___TypesData = L_4;
		Il2CppCodeGenWriteBarrier((void**)(&(&V_0)->___TypesData), (void*)L_4);
		(&V_0)->___TotalFiles = ((int32_t)14);
		(&V_0)->___TotalTypes = ((int32_t)15);
		(&V_0)->___IsEditorOnly = (bool)0;
		MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE L_6 = V_0;
		return L_6;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnitySourceGeneratedAssemblyMonoScriptTypes_v1__ctor_m73B19E1779165E816805495AD6A21E98887459F2 (UnitySourceGeneratedAssemblyMonoScriptTypes_v1_t235D228E4864CB3B2043FAF6ECC420F6D2F9C385* __this, const RuntimeMethod* method) 
{
	{
		Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_pinvoke(const MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE& unmarshaled, MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_pinvoke& marshaled)
{
	marshaled.___FilePathsData = il2cpp_codegen_com_marshal_safe_array(IL2CPP_VT_I1, unmarshaled.___FilePathsData);
	marshaled.___TypesData = il2cpp_codegen_com_marshal_safe_array(IL2CPP_VT_I1, unmarshaled.___TypesData);
	marshaled.___TotalTypes = unmarshaled.___TotalTypes;
	marshaled.___TotalFiles = unmarshaled.___TotalFiles;
	marshaled.___IsEditorOnly = static_cast<int32_t>(unmarshaled.___IsEditorOnly);
}
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_pinvoke_back(const MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_pinvoke& marshaled, MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE& unmarshaled)
{
	unmarshaled.___FilePathsData = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___FilePathsData);
	Il2CppCodeGenWriteBarrier((void**)(&unmarshaled.___FilePathsData), (void*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___FilePathsData));
	unmarshaled.___TypesData = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___TypesData);
	Il2CppCodeGenWriteBarrier((void**)(&unmarshaled.___TypesData), (void*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___TypesData));
	int32_t unmarshaledTotalTypes_temp_2 = 0;
	unmarshaledTotalTypes_temp_2 = marshaled.___TotalTypes;
	unmarshaled.___TotalTypes = unmarshaledTotalTypes_temp_2;
	int32_t unmarshaledTotalFiles_temp_3 = 0;
	unmarshaledTotalFiles_temp_3 = marshaled.___TotalFiles;
	unmarshaled.___TotalFiles = unmarshaledTotalFiles_temp_3;
	bool unmarshaledIsEditorOnly_temp_4 = false;
	unmarshaledIsEditorOnly_temp_4 = static_cast<bool>(marshaled.___IsEditorOnly);
	unmarshaled.___IsEditorOnly = unmarshaledIsEditorOnly_temp_4;
}
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_pinvoke_cleanup(MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_pinvoke& marshaled)
{
	il2cpp_codegen_com_destroy_safe_array(marshaled.___FilePathsData);
	marshaled.___FilePathsData = NULL;
	il2cpp_codegen_com_destroy_safe_array(marshaled.___TypesData);
	marshaled.___TypesData = NULL;
}
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_com(const MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE& unmarshaled, MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_com& marshaled)
{
	marshaled.___FilePathsData = il2cpp_codegen_com_marshal_safe_array(IL2CPP_VT_I1, unmarshaled.___FilePathsData);
	marshaled.___TypesData = il2cpp_codegen_com_marshal_safe_array(IL2CPP_VT_I1, unmarshaled.___TypesData);
	marshaled.___TotalTypes = unmarshaled.___TotalTypes;
	marshaled.___TotalFiles = unmarshaled.___TotalFiles;
	marshaled.___IsEditorOnly = static_cast<int32_t>(unmarshaled.___IsEditorOnly);
}
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_com_back(const MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_com& marshaled, MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE& unmarshaled)
{
	unmarshaled.___FilePathsData = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___FilePathsData);
	Il2CppCodeGenWriteBarrier((void**)(&unmarshaled.___FilePathsData), (void*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___FilePathsData));
	unmarshaled.___TypesData = (ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___TypesData);
	Il2CppCodeGenWriteBarrier((void**)(&unmarshaled.___TypesData), (void*)(ByteU5BU5D_tA6237BF417AE52AD70CFB4EF24A7A82613DF9031*)il2cpp_codegen_com_marshal_safe_array_result(IL2CPP_VT_I1, il2cpp_defaults.byte_class, marshaled.___TypesData));
	int32_t unmarshaledTotalTypes_temp_2 = 0;
	unmarshaledTotalTypes_temp_2 = marshaled.___TotalTypes;
	unmarshaled.___TotalTypes = unmarshaledTotalTypes_temp_2;
	int32_t unmarshaledTotalFiles_temp_3 = 0;
	unmarshaledTotalFiles_temp_3 = marshaled.___TotalFiles;
	unmarshaled.___TotalFiles = unmarshaledTotalFiles_temp_3;
	bool unmarshaledIsEditorOnly_temp_4 = false;
	unmarshaledIsEditorOnly_temp_4 = static_cast<bool>(marshaled.___IsEditorOnly);
	unmarshaled.___IsEditorOnly = unmarshaledIsEditorOnly_temp_4;
}
IL2CPP_EXTERN_C void MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshal_com_cleanup(MonoScriptData_tECBB22545B9E2DF4F23877AD5C209512306132BE_marshaled_com& marshaled)
{
	il2cpp_codegen_com_destroy_safe_array(marshaled.___FilePathsData);
	marshaled.___FilePathsData = NULL;
	il2cpp_codegen_com_destroy_safe_array(marshaled.___TypesData);
	marshaled.___TypesData = NULL;
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* VRStereoCameraRig_get_Instance_m8490700282DC8D7ABE9DC98E3014A86C81677C4F (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_0 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_GlobalIsVrMode_m58848EB9B12A8C4233CCD1A08CA5F4BB35BED018 (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		bool L_0 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___U3CGlobalIsVrModeU3Ek__BackingField;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_set_GlobalIsVrMode_m6109AA5B3EE40574B27EFE754C4C41397246BC97 (bool ___0_value, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		bool L_0 = ___0_value;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___U3CGlobalIsVrModeU3Ek__BackingField = L_0;
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_IsVrMode_m176D7C93802D3B136E1107067F93A83FC4DC2D70 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		bool L_0 = __this->____isVrMode;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* VRStereoCameraRig_get_LeftEyeCamera_mD8AA4E0F7C65A976528D9BD66C93C95EB194862F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_0 = __this->____leftEyeCamera;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* VRStereoCameraRig_get_RightEyeCamera_m0A31DEF2B3AD6886CFBB6EA618059DD961763F9A (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_0 = __this->____rightEyeCamera;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* VRStereoCameraRig_get_HeadTransform_m9433A3BE3D1CE5A23E5AD32DB6F08D20E9BAB7E3 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_IsVrActive_mA5D4665482ACB2371569C470D29D6703FD8D5A14 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		bool L_0 = __this->____isVrMode;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_EnableVrMode_m2F92AAA86479AD32C9480A3F71EFE1B2FEE1BDCD (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(__this, (bool)1, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_DisableVrMode_mCBE60A509F59B29BAC71A43F24017DD8B12EE8D9 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(__this, (bool)0, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RecalibrateOrientation_mE33DE46C3D83FE0F27090AA4B02B864224AFD6C9 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, float ___0_biasX, float ___1_biasZ, const RuntimeMethod* method) 
{
	{
		VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 VRStereoCameraRig_get_HeadPosition_mACC1BBDFA2CF3D5358A5143F8D4D2249A58902C6 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (L_1)
		{
			goto IL_001a;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_2;
		L_2 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_2);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_3;
		L_3 = Transform_get_position_m69CD5FA214FDAE7BB701552943674846C220FDE1(L_2, NULL);
		return L_3;
	}

IL_001a:
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_4 = __this->____headTransform;
		NullCheck(L_4);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_5;
		L_5 = Transform_get_position_m69CD5FA214FDAE7BB701552943674846C220FDE1(L_4, NULL);
		return L_5;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 VRStereoCameraRig_get_HeadRotation_m2549C8356F1B49ADD4F9073A746C0BFD3DB987C0 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (L_1)
		{
			goto IL_001a;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_2;
		L_2 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_2);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_3;
		L_3 = Transform_get_rotation_m32AF40CA0D50C797DA639A696F8EAEC7524C179C(L_2, NULL);
		return L_3;
	}

IL_001a:
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_4 = __this->____headTransform;
		NullCheck(L_4);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_5;
		L_5 = Transform_get_rotation_m32AF40CA0D50C797DA639A696F8EAEC7524C179C(L_4, NULL);
		return L_5;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00 VRStereoCameraRig_get_GazeRay_m4858FCF7C3B3CB020CDBB9E7767A083913210791 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (L_1)
		{
			goto IL_002a;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_2;
		L_2 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_2);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_3;
		L_3 = Transform_get_position_m69CD5FA214FDAE7BB701552943674846C220FDE1(L_2, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_4;
		L_4 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_4);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_5;
		L_5 = Transform_get_forward_mFCFACF7165FDAB21E80E384C494DF278386CEE2F(L_4, NULL);
		Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00 L_6;
		memset((&L_6), 0, sizeof(L_6));
		Ray__ctor_mE298992FD10A3894C38373198385F345C58BD64C_inline((&L_6), L_3, L_5, NULL);
		return L_6;
	}

IL_002a:
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_7 = __this->____headTransform;
		NullCheck(L_7);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_8;
		L_8 = Transform_get_position_m69CD5FA214FDAE7BB701552943674846C220FDE1(L_7, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_9 = __this->____headTransform;
		NullCheck(L_9);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_10;
		L_10 = Transform_get_forward_mFCFACF7165FDAB21E80E384C494DF278386CEE2F(L_9, NULL);
		Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00 L_11;
		memset((&L_11), 0, sizeof(L_11));
		Ray__ctor_mE298992FD10A3894C38373198385F345C58BD64C_inline((&L_11), L_8, L_10, NULL);
		return L_11;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_IsTriggerPressed_m356292282F30A4F540346A554196D5F2578E690C (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		bool L_0;
		L_0 = Input_GetMouseButtonDown_m8DFC792D15FFF15D311614D5CC6C5D055E5A1DE3(0, NULL);
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_Awake_mF7631FC0D2830C556E161FCC2EDD7CF6A9D1FD4C (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_0 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_0020;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance = __this;
		Il2CppCodeGenWriteBarrier((void**)(&((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance), (void*)__this);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_2;
		L_2 = Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B(__this, NULL);
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		Object_DontDestroyOnLoad_m4B70C3AEF886C176543D1295507B6455C9DCAEA7(L_2, NULL);
		goto IL_0039;
	}

IL_0020:
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_3 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_4;
		L_4 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_3, __this, NULL);
		if (!L_4)
		{
			goto IL_0039;
		}
	}
	{
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_5;
		L_5 = Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B(__this, NULL);
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		Object_Destroy_mE97D0A766419A81296E8D4E5C23D01D3FE91ACBB(L_5, NULL);
		return;
	}

IL_0039:
	{
		VRStereoCameraRig_InitializeHardwareAndMath_m269EA7577AD73EA661EDAA4D7CF61179EA3A84C2(__this, NULL);
		VRStereoCameraRig_AutoSetupRig_mB4E61BD00002D79D4CDF37BA86E3DECC26B28B2F(__this, NULL);
		VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_OnEnable_m94D6462337186702DD3890365F1A9A13D0706E88 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&SceneManager_tA0EF56A88ACA4A15731AF7FDC10A869FA4C698FA_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A* L_0 = (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A*)il2cpp_codegen_object_new(UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A_il2cpp_TypeInfo_var);
		UnityAction_2__ctor_m0E0C01B7056EB1CB1E6C6F4FC457EBCA3F6B0041(L_0, __this, (intptr_t)((void*)VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B_RuntimeMethod_var), NULL);
		il2cpp_codegen_runtime_class_init_inline(SceneManager_tA0EF56A88ACA4A15731AF7FDC10A869FA4C698FA_il2cpp_TypeInfo_var);
		SceneManager_add_sceneLoaded_m14BEBCC5E4A8DD2C806A48D79A4773315CB434C6(L_0, NULL);
		VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_OnDisable_m74444D7DC36B9064E18E96E529DC6513A33AFBEC (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&SceneManager_tA0EF56A88ACA4A15731AF7FDC10A869FA4C698FA_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A* L_0 = (UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A*)il2cpp_codegen_object_new(UnityAction_2_t1C08AEB5AA4F72FEFAB7F303E33C8CFFF80A8C3A_il2cpp_TypeInfo_var);
		UnityAction_2__ctor_m0E0C01B7056EB1CB1E6C6F4FC457EBCA3F6B0041(L_0, __this, (intptr_t)((void*)VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B_RuntimeMethod_var), NULL);
		il2cpp_codegen_runtime_class_init_inline(SceneManager_tA0EF56A88ACA4A15731AF7FDC10A869FA4C698FA_il2cpp_TypeInfo_var);
		SceneManager_remove_sceneLoaded_m72A7C2A1B8EF1C21A208A9A015375577768B3978(L_0, NULL);
		VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_Start_m7D440D191F2F329C09B0F6EC3DB0F942EC0BC1BA (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		bool L_0;
		L_0 = VRStereoCameraRig_get_GlobalIsVrMode_m58848EB9B12A8C4233CCD1A08CA5F4BB35BED018_inline(NULL);
		bool L_1 = __this->____isVrMode;
		if ((((int32_t)L_0) == ((int32_t)L_1)))
		{
			goto IL_0019;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		bool L_2;
		L_2 = VRStereoCameraRig_get_GlobalIsVrMode_m58848EB9B12A8C4233CCD1A08CA5F4BB35BED018_inline(NULL);
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(__this, L_2, NULL);
		return;
	}

IL_0019:
	{
		VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_InitializeHardwareAndMath_m269EA7577AD73EA661EDAA4D7CF61179EA3A84C2 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral7DA1E12011380B8307A333B91B409E670F7704F8);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralE1E18CE96394C50555C8148849B23AD9FC1CBBC5);
		s_Il2CppMethodInitialized = true;
	}
	float V_0 = 0.0f;
	{
		float L_0 = __this->____ipdMeters;
		V_0 = ((float)il2cpp_codegen_multiply(L_0, (0.5f)));
		float L_1 = V_0;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_2;
		memset((&L_2), 0, sizeof(L_2));
		Vector3__ctor_m376936E6B999EF1ECBE57D990A386303E2283DE0_inline((&L_2), ((-L_1)), (0.0f), (0.0f), NULL);
		__this->____leftEyeLocalPosStereo = L_2;
		float L_3 = V_0;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_4;
		memset((&L_4), 0, sizeof(L_4));
		Vector3__ctor_m376936E6B999EF1ECBE57D990A386303E2283DE0_inline((&L_4), L_3, (0.0f), (0.0f), NULL);
		__this->____rightEyeLocalPosStereo = L_4;
		bool L_5;
		L_5 = SystemInfo_get_supportsGyroscope_m98477EC99D88396F076A93EF5C28A6129DC4E211(NULL);
		__this->____hasGyro = L_5;
		bool L_6 = __this->____hasGyro;
		if (!L_6)
		{
			goto IL_0073;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_7;
		L_7 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_7);
		Gyroscope_set_enabled_m2B22BC93369BA61034A80350405FE1B493822DAB(L_7, (bool)1, NULL);
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_8;
		L_8 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_8);
		Gyroscope_set_updateInterval_m477CB8AF6D656813C14467CCB62EDC3BF1383925(L_8, (0.0166999996f), NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(_stringLiteralE1E18CE96394C50555C8148849B23AD9FC1CBBC5, NULL);
		goto IL_007d;
	}

IL_0073:
	{
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9(_stringLiteral7DA1E12011380B8307A333B91B409E670F7704F8, NULL);
	}

IL_007d:
	{
		__this->____isInitialized = (bool)1;
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_AutoSetupRig_mB4E61BD00002D79D4CDF37BA86E3DECC26B28B2F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Component_GetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m18720A555FC6A050CCD144559DC24C2DD39FDB0B_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GameObject_t76FEDD663AB33C991A9C9A23129337651094216F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral21368742647C64881FA2CF76FFA64DEECA581E78);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral8CCEF704EA3F7EE31DBE57B1D38B190FC62E7054);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralA6A37A7EF98C3D357B5014405CDFF9A1813578C9);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralA70D6CDC1F06B9FC50E6DAC070AEC4AE209ABA17);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralBB939A96D8BF5583810D5B0D326E59C194ED7AAD);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralE302AA9BECF9F1CB69CF2A3E5B33E0716BEA97F6);
		s_Il2CppMethodInitialized = true;
	}
	CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B* V_0 = NULL;
	Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* V_1 = NULL;
	GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* V_2 = NULL;
	Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* V_3 = NULL;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* V_4 = NULL;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* V_5 = NULL;
	GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* V_6 = NULL;
	Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* V_7 = NULL;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* V_8 = NULL;
	GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* V_9 = NULL;
	int32_t V_10 = 0;
	Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* V_11 = NULL;
	AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* V_12 = NULL;
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_007a;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_2;
		L_2 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_2);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_3;
		L_3 = Transform_Find_m3087032B0E1C5B96A2D2C27020BAEAE2DA08F932(L_2, _stringLiteral21368742647C64881FA2CF76FFA64DEECA581E78, NULL);
		V_1 = L_3;
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_4 = V_1;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_5;
		L_5 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_4, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_5)
		{
			goto IL_0031;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_6 = V_1;
		__this->____headTransform = L_6;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____headTransform), (void*)L_6);
		goto IL_007a;
	}

IL_0031:
	{
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_7 = (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F*)il2cpp_codegen_object_new(GameObject_t76FEDD663AB33C991A9C9A23129337651094216F_il2cpp_TypeInfo_var);
		GameObject__ctor_m37D512B05D292F954792225E6C6EEE95293A9B88(L_7, _stringLiteral21368742647C64881FA2CF76FFA64DEECA581E78, NULL);
		V_2 = L_7;
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_8 = V_2;
		NullCheck(L_8);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_9;
		L_9 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_8, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_10;
		L_10 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(__this, NULL);
		NullCheck(L_9);
		Transform_SetParent_m9BDD7B7476714B2D7919B10BDC22CE75C0A0A195(L_9, L_10, (bool)0, NULL);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_11 = V_2;
		NullCheck(L_11);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_12;
		L_12 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_11, NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_13;
		L_13 = Vector3_get_zero_m0C1249C3F25B1C70EAD3CC8B31259975A457AE39_inline(NULL);
		NullCheck(L_12);
		Transform_set_localPosition_mDE1C997F7D79C0885210B7732B4BA50EE7D73134(L_12, L_13, NULL);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_14 = V_2;
		NullCheck(L_14);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_15;
		L_15 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_14, NULL);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_16;
		L_16 = Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline(NULL);
		NullCheck(L_15);
		Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA(L_15, L_16, NULL);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_17 = V_2;
		NullCheck(L_17);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_18;
		L_18 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_17, NULL);
		__this->____headTransform = L_18;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____headTransform), (void*)L_18);
	}

IL_007a:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_19 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_20;
		L_20 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_19, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_20)
		{
			goto IL_0166;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_21 = __this->____headTransform;
		NullCheck(L_21);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_22;
		L_22 = Transform_Find_m3087032B0E1C5B96A2D2C27020BAEAE2DA08F932(L_21, _stringLiteral8CCEF704EA3F7EE31DBE57B1D38B190FC62E7054, NULL);
		V_3 = L_22;
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_23 = V_3;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_24;
		L_24 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_23, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_24)
		{
			goto IL_00bc;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_25 = V_3;
		NullCheck(L_25);
		bool L_26;
		L_26 = Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882(L_25, (&V_4), Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882_RuntimeMethod_var);
		if (!L_26)
		{
			goto IL_00bc;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_27 = V_4;
		__this->____leftEyeCamera = L_27;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____leftEyeCamera), (void*)L_27);
		goto IL_0166;
	}

IL_00bc:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_28;
		L_28 = Camera_get_main_m52C992F18E05355ABB9EEB64A4BF2215E12762DF(NULL);
		V_5 = L_28;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_29 = V_5;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_30;
		L_30 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_29, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_30)
		{
			goto IL_010a;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_31 = V_5;
		NullCheck(L_31);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_32;
		L_32 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(L_31, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_33 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_34;
		L_34 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_32, L_33, NULL);
		if (!L_34)
		{
			goto IL_010a;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_35 = V_5;
		NullCheck(L_35);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_36;
		L_36 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(L_35, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_37 = __this->____headTransform;
		NullCheck(L_36);
		Transform_SetParent_m9BDD7B7476714B2D7919B10BDC22CE75C0A0A195(L_36, L_37, (bool)0, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_38 = V_5;
		NullCheck(L_38);
		Object_set_name_mC79E6DC8FFD72479C90F0C4CC7F42A0FEAF5AE47(L_38, _stringLiteral8CCEF704EA3F7EE31DBE57B1D38B190FC62E7054, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_39 = V_5;
		__this->____leftEyeCamera = L_39;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____leftEyeCamera), (void*)L_39);
		goto IL_0166;
	}

IL_010a:
	{
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_40 = (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F*)il2cpp_codegen_object_new(GameObject_t76FEDD663AB33C991A9C9A23129337651094216F_il2cpp_TypeInfo_var);
		GameObject__ctor_m37D512B05D292F954792225E6C6EEE95293A9B88(L_40, _stringLiteral8CCEF704EA3F7EE31DBE57B1D38B190FC62E7054, NULL);
		V_6 = L_40;
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_41 = V_6;
		NullCheck(L_41);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_42;
		L_42 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_41, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_43 = __this->____headTransform;
		NullCheck(L_42);
		Transform_SetParent_m9BDD7B7476714B2D7919B10BDC22CE75C0A0A195(L_42, L_43, (bool)0, NULL);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_44 = V_6;
		NullCheck(L_44);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_45;
		L_45 = GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142(L_44, GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142_RuntimeMethod_var);
		__this->____leftEyeCamera = L_45;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____leftEyeCamera), (void*)L_45);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_46 = __this->____leftEyeCamera;
		NullCheck(L_46);
		Component_set_tag_mAF8B6EC052F8AA67088F1841B57EA37F13D0451E(L_46, _stringLiteralE302AA9BECF9F1CB69CF2A3E5B33E0716BEA97F6, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_47 = __this->____leftEyeCamera;
		NullCheck(L_47);
		Camera_set_nearClipPlane_m78482B5E4E0CE4C195D9CE0332AA75B2D9CCDDF6(L_47, (0.100000001f), NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_48 = __this->____leftEyeCamera;
		NullCheck(L_48);
		Camera_set_farClipPlane_m84EF39B09573168734613481FD979BFF31C60139(L_48, (1000.0f), NULL);
	}

IL_0166:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_49 = __this->____rightEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_50;
		L_50 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_49, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_50)
		{
			goto IL_01e3;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_51 = __this->____headTransform;
		NullCheck(L_51);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_52;
		L_52 = Transform_Find_m3087032B0E1C5B96A2D2C27020BAEAE2DA08F932(L_51, _stringLiteralA70D6CDC1F06B9FC50E6DAC070AEC4AE209ABA17, NULL);
		V_7 = L_52;
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_53 = V_7;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_54;
		L_54 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_53, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_54)
		{
			goto IL_01a5;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_55 = V_7;
		NullCheck(L_55);
		bool L_56;
		L_56 = Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882(L_55, (&V_8), Component_TryGetComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m1D22E7CA60B7DA94499EFF8D98588B2BD8950882_RuntimeMethod_var);
		if (!L_56)
		{
			goto IL_01a5;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_57 = V_8;
		__this->____rightEyeCamera = L_57;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____rightEyeCamera), (void*)L_57);
		goto IL_01e3;
	}

IL_01a5:
	{
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_58 = (GameObject_t76FEDD663AB33C991A9C9A23129337651094216F*)il2cpp_codegen_object_new(GameObject_t76FEDD663AB33C991A9C9A23129337651094216F_il2cpp_TypeInfo_var);
		GameObject__ctor_m37D512B05D292F954792225E6C6EEE95293A9B88(L_58, _stringLiteralA70D6CDC1F06B9FC50E6DAC070AEC4AE209ABA17, NULL);
		V_9 = L_58;
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_59 = V_9;
		NullCheck(L_59);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_60;
		L_60 = GameObject_get_transform_m0BC10ADFA1632166AE5544BDF9038A2650C2AE56(L_59, NULL);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_61 = __this->____headTransform;
		NullCheck(L_60);
		Transform_SetParent_m9BDD7B7476714B2D7919B10BDC22CE75C0A0A195(L_60, L_61, (bool)0, NULL);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_62 = V_9;
		NullCheck(L_62);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_63;
		L_63 = GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142(L_62, GameObject_AddComponent_TisCamera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184_m0933BC50E883CDEF6FA83FE190DA37CCB2802142_RuntimeMethod_var);
		__this->____rightEyeCamera = L_63;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____rightEyeCamera), (void*)L_63);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_64 = __this->____leftEyeCamera;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_65 = __this->____rightEyeCamera;
		VRStereoCameraRig_CopyCameraSettings_m9330BC1529F0DA8E737B1F3A3D5D40944FB7C63F(__this, L_64, L_65, NULL);
	}

IL_01e3:
	{
		VRStereoCameraRig_EnsureSingleAudioListener_m73DA48FDAA6C1556710392B7C831316AF5F16E5A(__this, NULL);
		VRStereoCameraRig_DisableConflictingPoseDrivers_mC0EFFF6591DA7104A001E7C857BA41DCD7A0DD1D(__this, NULL);
		CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B* L_66;
		L_66 = Camera_get_allCameras_m04BE279D34E474DEAF8237A5509CF2C0E6865571(NULL);
		V_0 = L_66;
		V_10 = 0;
		goto IL_0273;
	}

IL_01fa:
	{
		CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B* L_67 = V_0;
		int32_t L_68 = V_10;
		NullCheck(L_67);
		int32_t L_69 = L_68;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_70 = (L_67)->GetAt(static_cast<il2cpp_array_size_t>(L_69));
		V_11 = L_70;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_71 = V_11;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_72;
		L_72 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_71, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_72)
		{
			goto IL_026d;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_73 = V_11;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_74 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_75;
		L_75 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_73, L_74, NULL);
		if (!L_75)
		{
			goto IL_026d;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_76 = V_11;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_77 = __this->____rightEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_78;
		L_78 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_76, L_77, NULL);
		if (!L_78)
		{
			goto IL_026d;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_79 = V_11;
		NullCheck(L_79);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_79, (bool)0, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_80 = V_11;
		NullCheck(L_80);
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_81;
		L_81 = Component_GetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m18720A555FC6A050CCD144559DC24C2DD39FDB0B(L_80, Component_GetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m18720A555FC6A050CCD144559DC24C2DD39FDB0B_RuntimeMethod_var);
		V_12 = L_81;
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_82 = V_12;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_83;
		L_83 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_82, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_83)
		{
			goto IL_0252;
		}
	}
	{
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_84 = V_12;
		NullCheck(L_84);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_84, (bool)0, NULL);
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_85 = V_12;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		Object_Destroy_mE97D0A766419A81296E8D4E5C23D01D3FE91ACBB(L_85, NULL);
	}

IL_0252:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_86 = V_11;
		NullCheck(L_86);
		String_t* L_87;
		L_87 = Object_get_name_mAC2F6B897CF1303BA4249B4CB55271AFACBB6392(L_86, NULL);
		String_t* L_88;
		L_88 = String_Concat_m8855A6DE10F84DA7F4EC113CADDB59873A25573B(_stringLiteralA6A37A7EF98C3D357B5014405CDFF9A1813578C9, L_87, _stringLiteralBB939A96D8BF5583810D5B0D326E59C194ED7AAD, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_88, NULL);
	}

IL_026d:
	{
		int32_t L_89 = V_10;
		V_10 = ((int32_t)il2cpp_codegen_add(L_89, 1));
	}

IL_0273:
	{
		int32_t L_90 = V_10;
		CameraU5BU5D_t1506EBA524A07AD1066D6DD4D7DFC6721F1AC26B* L_91 = V_0;
		NullCheck(L_91);
		if ((((int32_t)L_90) < ((int32_t)((int32_t)(((RuntimeArray*)L_91)->max_length)))))
		{
			goto IL_01fa;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_EnsureSingleAudioListener_m73DA48FDAA6C1556710392B7C831316AF5F16E5A (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Component_TryGetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m6BA3859778F8DD9E3AB12FB8CDAD6EB9BA75CAA5_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GameObject_AddComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_mA30AC51FE6287A9D0057077D99F694600A3D844E_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_FindObjectsByType_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m41F4E631A15C9290412B4A4BC98BAC8FA83CD5C6_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralC7A7939E82BEFEF8DDB755713442AA62963F09F8);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralF1A9CD2C6466E3BBDCF6FDEB6ADD2509BAE430B6);
		s_Il2CppMethodInitialized = true;
	}
	AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* V_0 = NULL;
	int32_t V_1 = 0;
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_000f;
		}
	}
	{
		return;
	}

IL_000f:
	{
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_2 = __this->____headAudioListener;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_3;
		L_3 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_2, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_3)
		{
			goto IL_0046;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_4 = __this->____headTransform;
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35** L_5 = (AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35**)(&__this->____headAudioListener);
		NullCheck(L_4);
		bool L_6;
		L_6 = Component_TryGetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m6BA3859778F8DD9E3AB12FB8CDAD6EB9BA75CAA5(L_4, L_5, Component_TryGetComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m6BA3859778F8DD9E3AB12FB8CDAD6EB9BA75CAA5_RuntimeMethod_var);
		if (L_6)
		{
			goto IL_0046;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_7 = __this->____headTransform;
		NullCheck(L_7);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_8;
		L_8 = Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B(L_7, NULL);
		NullCheck(L_8);
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_9;
		L_9 = GameObject_AddComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_mA30AC51FE6287A9D0057077D99F694600A3D844E(L_8, GameObject_AddComponent_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_mA30AC51FE6287A9D0057077D99F694600A3D844E_RuntimeMethod_var);
		__this->____headAudioListener = L_9;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____headAudioListener), (void*)L_9);
	}

IL_0046:
	{
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_10 = __this->____headAudioListener;
		NullCheck(L_10);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_10, (bool)1, NULL);
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* L_11;
		L_11 = Object_FindObjectsByType_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m41F4E631A15C9290412B4A4BC98BAC8FA83CD5C6(0, Object_FindObjectsByType_TisAudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35_m41F4E631A15C9290412B4A4BC98BAC8FA83CD5C6_RuntimeMethod_var);
		V_0 = L_11;
		V_1 = 0;
		goto IL_009b;
	}

IL_005d:
	{
		AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* L_12 = V_0;
		int32_t L_13 = V_1;
		NullCheck(L_12);
		int32_t L_14 = L_13;
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_15 = (L_12)->GetAt(static_cast<il2cpp_array_size_t>(L_14));
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_16 = __this->____headAudioListener;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_17;
		L_17 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_15, L_16, NULL);
		if (!L_17)
		{
			goto IL_0097;
		}
	}
	{
		AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* L_18 = V_0;
		int32_t L_19 = V_1;
		NullCheck(L_18);
		int32_t L_20 = L_19;
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_21 = (L_18)->GetAt(static_cast<il2cpp_array_size_t>(L_20));
		NullCheck(L_21);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_21, (bool)0, NULL);
		AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* L_22 = V_0;
		int32_t L_23 = V_1;
		NullCheck(L_22);
		int32_t L_24 = L_23;
		AudioListener_t1D629CE9BC079C8ECDE8F822616E8A8E319EAE35* L_25 = (L_22)->GetAt(static_cast<il2cpp_array_size_t>(L_24));
		NullCheck(L_25);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_26;
		L_26 = Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B(L_25, NULL);
		NullCheck(L_26);
		String_t* L_27;
		L_27 = Object_get_name_mAC2F6B897CF1303BA4249B4CB55271AFACBB6392(L_26, NULL);
		String_t* L_28;
		L_28 = String_Concat_m8855A6DE10F84DA7F4EC113CADDB59873A25573B(_stringLiteralF1A9CD2C6466E3BBDCF6FDEB6ADD2509BAE430B6, L_27, _stringLiteralC7A7939E82BEFEF8DDB755713442AA62963F09F8, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_28, NULL);
	}

IL_0097:
	{
		int32_t L_29 = V_1;
		V_1 = ((int32_t)il2cpp_codegen_add(L_29, 1));
	}

IL_009b:
	{
		int32_t L_30 = V_1;
		AudioListenerU5BU5D_t2D06C54959B74670B6F43370FBB2436474558E4F* L_31 = V_0;
		NullCheck(L_31);
		if ((((int32_t)L_30) < ((int32_t)((int32_t)(((RuntimeArray*)L_31)->max_length)))))
		{
			goto IL_005d;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_DisableConflictingPoseDrivers_mC0EFFF6591DA7104A001E7C857BA41DCD7A0DD1D (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Component_GetComponentsInChildren_TisMonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71_m802D8975EFA14B49D71AFFBCCE19FBB480EE0C66_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral2678DF1F1EF33CB814D18B41F3EBC54C47C8B6EA);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral338604A89C31D04CCF99255B458AB629651157AB);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral60F65CC9C00585B68DA57ED71FF30B3BC3F80896);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralC7A7939E82BEFEF8DDB755713442AA62963F09F8);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralEF1CAE2AA83E021BE2F831D444881036EC9D3CCF);
		s_Il2CppMethodInitialized = true;
	}
	MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* V_0 = NULL;
	int32_t V_1 = 0;
	MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* V_2 = NULL;
	String_t* V_3 = NULL;
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_000f;
		}
	}
	{
		return;
	}

IL_000f:
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_2 = __this->____headTransform;
		NullCheck(L_2);
		MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* L_3;
		L_3 = Component_GetComponentsInChildren_TisMonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71_m802D8975EFA14B49D71AFFBCCE19FBB480EE0C66(L_2, (bool)1, Component_GetComponentsInChildren_TisMonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71_m802D8975EFA14B49D71AFFBCCE19FBB480EE0C66_RuntimeMethod_var);
		V_0 = L_3;
		V_1 = 0;
		goto IL_0098;
	}

IL_0020:
	{
		MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* L_4 = V_0;
		int32_t L_5 = V_1;
		NullCheck(L_4);
		int32_t L_6 = L_5;
		MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* L_7 = (L_4)->GetAt(static_cast<il2cpp_array_size_t>(L_6));
		V_2 = L_7;
		MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* L_8 = V_2;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_9;
		L_9 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_8, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (L_9)
		{
			goto IL_0094;
		}
	}
	{
		MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* L_10 = V_2;
		NullCheck(L_10);
		Type_t* L_11;
		L_11 = Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3(L_10, NULL);
		NullCheck(L_11);
		String_t* L_12;
		L_12 = VirtualFuncInvoker0< String_t* >::Invoke(8, L_11);
		V_3 = L_12;
		String_t* L_13 = V_3;
		NullCheck(L_13);
		bool L_14;
		L_14 = String_Contains_m6D77B121FADA7CA5F397C0FABB65DA62DF03B6C3(L_13, _stringLiteral338604A89C31D04CCF99255B458AB629651157AB, NULL);
		if (L_14)
		{
			goto IL_0053;
		}
	}
	{
		String_t* L_15 = V_3;
		NullCheck(L_15);
		bool L_16;
		L_16 = String_Contains_m6D77B121FADA7CA5F397C0FABB65DA62DF03B6C3(L_15, _stringLiteralEF1CAE2AA83E021BE2F831D444881036EC9D3CCF, NULL);
		if (!L_16)
		{
			goto IL_0094;
		}
	}

IL_0053:
	{
		MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* L_17 = V_2;
		NullCheck(L_17);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_17, (bool)0, NULL);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_18 = (StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248*)(StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248*)SZArrayNew(StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248_il2cpp_TypeInfo_var, (uint32_t)5);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_19 = L_18;
		NullCheck(L_19);
		(L_19)->SetAt(static_cast<il2cpp_array_size_t>(0), (String_t*)_stringLiteral2678DF1F1EF33CB814D18B41F3EBC54C47C8B6EA);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_20 = L_19;
		String_t* L_21 = V_3;
		NullCheck(L_20);
		(L_20)->SetAt(static_cast<il2cpp_array_size_t>(1), (String_t*)L_21);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_22 = L_20;
		NullCheck(L_22);
		(L_22)->SetAt(static_cast<il2cpp_array_size_t>(2), (String_t*)_stringLiteral60F65CC9C00585B68DA57ED71FF30B3BC3F80896);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_23 = L_22;
		MonoBehaviour_t532A11E69716D348D8AA7F854AFCBFCB8AD17F71* L_24 = V_2;
		NullCheck(L_24);
		GameObject_t76FEDD663AB33C991A9C9A23129337651094216F* L_25;
		L_25 = Component_get_gameObject_m57AEFBB14DB39EC476F740BA000E170355DE691B(L_24, NULL);
		NullCheck(L_25);
		String_t* L_26;
		L_26 = Object_get_name_mAC2F6B897CF1303BA4249B4CB55271AFACBB6392(L_25, NULL);
		NullCheck(L_23);
		(L_23)->SetAt(static_cast<il2cpp_array_size_t>(3), (String_t*)L_26);
		StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* L_27 = L_23;
		NullCheck(L_27);
		(L_27)->SetAt(static_cast<il2cpp_array_size_t>(4), (String_t*)_stringLiteralC7A7939E82BEFEF8DDB755713442AA62963F09F8);
		String_t* L_28;
		L_28 = String_Concat_m647EBF831F54B6DF7D5AFA5FD012CF4EE7571B6A(L_27, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_28, NULL);
	}

IL_0094:
	{
		int32_t L_29 = V_1;
		V_1 = ((int32_t)il2cpp_codegen_add(L_29, 1));
	}

IL_0098:
	{
		int32_t L_30 = V_1;
		MonoBehaviourU5BU5D_tEB91860B3CEE2D63A7833A2842EB9CE4547DDBD7* L_31 = V_0;
		NullCheck(L_31);
		if ((((int32_t)L_30) < ((int32_t)((int32_t)(((RuntimeArray*)L_31)->max_length)))))
		{
			goto IL_0020;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_CopyCameraSettings_m9330BC1529F0DA8E737B1F3A3D5D40944FB7C63F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ___0_source, Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* ___1_destination, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_0 = ___0_source;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (L_1)
		{
			goto IL_0012;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_2 = ___1_destination;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_3;
		L_3 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_2, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_3)
		{
			goto IL_0013;
		}
	}

IL_0012:
	{
		return;
	}

IL_0013:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_4 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_5 = ___0_source;
		NullCheck(L_5);
		int32_t L_6;
		L_6 = Camera_get_clearFlags_mA74F538C124B391EF03C46A50CA7FF7B505B7602(L_5, NULL);
		NullCheck(L_4);
		Camera_set_clearFlags_m66541D9CC43CBAA5FE7364A50D43CA5569FD4D93(L_4, L_6, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_7 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_8 = ___0_source;
		NullCheck(L_8);
		Color_tD001788D726C3A7F1379BEED0260B9591F440C1F L_9;
		L_9 = Camera_get_backgroundColor_m1577A81D1E6A91D7934CECB8A284AA2D4704D96F(L_8, NULL);
		NullCheck(L_7);
		Camera_set_backgroundColor_m036FD8C316A93A0B168ACC89AFF16D396B872138(L_7, L_9, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_10 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_11 = ___0_source;
		NullCheck(L_11);
		int32_t L_12;
		L_12 = Camera_get_cullingMask_m6F5AFF8FB522F876D99E839BF77D8F27F26A1EF8(L_11, NULL);
		NullCheck(L_10);
		Camera_set_cullingMask_m14F426710530BA8FA53AEC02F79C418AA558CB32(L_10, L_12, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_13 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_14 = ___0_source;
		NullCheck(L_14);
		bool L_15;
		L_15 = Camera_get_orthographic_m904DEFC76C54DA4E30C20A62A86D5D87B7D4DD8F(L_14, NULL);
		NullCheck(L_13);
		Camera_set_orthographic_m64915C0840A68E526830A69F1C40257206185020(L_13, L_15, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_16 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_17 = ___0_source;
		NullCheck(L_17);
		float L_18;
		L_18 = Camera_get_fieldOfView_m9A93F17BBF89F496AE231C21817AFD1C1E833FBB(L_17, NULL);
		NullCheck(L_16);
		Camera_set_fieldOfView_m5AA9EED4D1603A1DEDBF883D9C42814B2BDEB777(L_16, L_18, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_19 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_20 = ___0_source;
		NullCheck(L_20);
		float L_21;
		L_21 = Camera_get_nearClipPlane_m5E8FAF84326E3192CB036BD29DCCDAF6A9861013(L_20, NULL);
		NullCheck(L_19);
		Camera_set_nearClipPlane_m78482B5E4E0CE4C195D9CE0332AA75B2D9CCDDF6(L_19, L_21, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_22 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_23 = ___0_source;
		NullCheck(L_23);
		float L_24;
		L_24 = Camera_get_farClipPlane_m1D7128B85B5DB866F75FBE8CEBA48335716B67BD(L_23, NULL);
		NullCheck(L_22);
		Camera_set_farClipPlane_m84EF39B09573168734613481FD979BFF31C60139(L_22, L_24, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_25 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_26 = ___0_source;
		NullCheck(L_26);
		float L_27;
		L_27 = Camera_get_depth_mDF67FFF8ED61750467DFC4C6D8F236850AD1BB1D(L_26, NULL);
		NullCheck(L_25);
		Camera_set_depth_m595FA2A4FEBC90E730810BBFB55E4A2C2134066F(L_25, L_27, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_28 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_29 = ___0_source;
		NullCheck(L_29);
		int32_t L_30;
		L_30 = Camera_get_renderingPath_m4011069F4C73EFF95BCB322E354C7E01C2D38CCF(L_29, NULL);
		NullCheck(L_28);
		Camera_set_renderingPath_m5BD8E4230DE3DD68F722AED5D85271E2A2B026B3(L_28, L_30, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_31 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_32 = ___0_source;
		NullCheck(L_32);
		bool L_33;
		L_33 = Camera_get_useOcclusionCulling_m7A138C52EB27EB62A0D1197D5557B075F9ED53B1(L_32, NULL);
		NullCheck(L_31);
		Camera_set_useOcclusionCulling_mD3036B0CBB5E6A1BF33810AB8FDEE3CD1A4D7C04(L_31, L_33, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_34 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_35 = ___0_source;
		NullCheck(L_35);
		bool L_36;
		L_36 = Camera_get_allowHDR_m3187E9118CB52D5D7F0658D7ECF5E2B00E296A67(L_35, NULL);
		NullCheck(L_34);
		Camera_set_allowHDR_m44211153DAF6DF9A51142EC7760A53777C1F3315(L_34, L_36, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_37 = ___1_destination;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_38 = ___0_source;
		NullCheck(L_38);
		bool L_39;
		L_39 = Camera_get_allowMSAA_mC316155B22B679709F85BA9AE3F7931C30EE7AF4(L_38, NULL);
		NullCheck(L_37);
		Camera_set_allowMSAA_m7BE26D3FAAA64202C49DE6CA95C02A85770F8268(L_37, L_39, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral03A4D076B6CD9A4B5F0A0F97119D1F56E9DC4029);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral24301BAB550EA3EDCE733629ED5B2C4EAC51D777);
		s_Il2CppMethodInitialized = true;
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_0 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_0023;
		}
	}
	{
		VRStereoCameraRig_AutoSetupRig_mB4E61BD00002D79D4CDF37BA86E3DECC26B28B2F(__this, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_2 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_3;
		L_3 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_2, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_3)
		{
			goto IL_0023;
		}
	}
	{
		return;
	}

IL_0023:
	{
		bool L_4 = __this->____isVrMode;
		if (!L_4)
		{
			goto IL_0100;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_5 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_6 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoLeft;
		NullCheck(L_5);
		Camera_set_rect_mA81158BC169AF8674DE240AE9460FC5A0EADBB19(L_5, L_6, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_7 = __this->____leftEyeCamera;
		NullCheck(L_7);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_8;
		L_8 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(L_7, NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_9 = __this->____leftEyeLocalPosStereo;
		NullCheck(L_8);
		Transform_set_localPosition_mDE1C997F7D79C0885210B7732B4BA50EE7D73134(L_8, L_9, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_10 = __this->____leftEyeCamera;
		NullCheck(L_10);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_10, (bool)1, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_11 = __this->____rightEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_12;
		L_12 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_11, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_12)
		{
			goto IL_00b2;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_13 = __this->____leftEyeCamera;
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_14 = __this->____rightEyeCamera;
		VRStereoCameraRig_CopyCameraSettings_m9330BC1529F0DA8E737B1F3A3D5D40944FB7C63F(__this, L_13, L_14, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_15 = __this->____rightEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_16 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoRight;
		NullCheck(L_15);
		Camera_set_rect_mA81158BC169AF8674DE240AE9460FC5A0EADBB19(L_15, L_16, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_17 = __this->____rightEyeCamera;
		NullCheck(L_17);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_18;
		L_18 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(L_17, NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_19 = __this->____rightEyeLocalPosStereo;
		NullCheck(L_18);
		Transform_set_localPosition_mDE1C997F7D79C0885210B7732B4BA50EE7D73134(L_18, L_19, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_20 = __this->____rightEyeCamera;
		NullCheck(L_20);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_20, (bool)1, NULL);
	}

IL_00b2:
	{
		bool L_21 = __this->____hasGyro;
		if (!L_21)
		{
			goto IL_00d1;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_22;
		L_22 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_22);
		bool L_23;
		L_23 = Gyroscope_get_enabled_m10F5B3F646AB1A6EEE2831010642E9E1E0BCBDB9(L_22, NULL);
		if (L_23)
		{
			goto IL_00d1;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_24;
		L_24 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_24);
		Gyroscope_set_enabled_m2B22BC93369BA61034A80350405FE1B493822DAB(L_24, (bool)1, NULL);
	}

IL_00d1:
	{
		float L_25 = __this->____ipdMeters;
		float L_26 = L_25;
		RuntimeObject* L_27 = Box(il2cpp_defaults.single_class, &L_26);
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_28 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoLeft;
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_29 = L_28;
		RuntimeObject* L_30 = Box(Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D_il2cpp_TypeInfo_var, &L_29);
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_31 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoRight;
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_32 = L_31;
		RuntimeObject* L_33 = Box(Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D_il2cpp_TypeInfo_var, &L_32);
		String_t* L_34;
		L_34 = String_Format_mA0534D6E2AE4D67A6BD8D45B3321323930EB930C(_stringLiteral03A4D076B6CD9A4B5F0A0F97119D1F56E9DC4029, L_27, L_30, L_33, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_34, NULL);
		return;
	}

IL_0100:
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_35 = __this->____leftEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_36 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectMonoFullScreen;
		NullCheck(L_35);
		Camera_set_rect_mA81158BC169AF8674DE240AE9460FC5A0EADBB19(L_35, L_36, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_37 = __this->____leftEyeCamera;
		NullCheck(L_37);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_38;
		L_38 = Component_get_transform_m2919A1D81931E6932C7F06D4C2F0AB8DDA9A5371(L_37, NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_39 = __this->____eyeLocalPosMono;
		NullCheck(L_38);
		Transform_set_localPosition_mDE1C997F7D79C0885210B7732B4BA50EE7D73134(L_38, L_39, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_40 = __this->____leftEyeCamera;
		NullCheck(L_40);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_40, (bool)1, NULL);
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_41 = __this->____rightEyeCamera;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_42;
		L_42 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_41, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_42)
		{
			goto IL_014c;
		}
	}
	{
		Camera_tA92CC927D7439999BC82DBEDC0AA45B470F9E184* L_43 = __this->____rightEyeCamera;
		NullCheck(L_43);
		Behaviour_set_enabled_mF1DCFE60EB09E0529FE9476CA804A3AA2D72B16A(L_43, (bool)0, NULL);
	}

IL_014c:
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_44 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_45;
		L_45 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_44, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_45)
		{
			goto IL_017b;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_46 = __this->____headTransform;
		float L_47 = __this->____currentPitch;
		float L_48 = __this->____currentYaw;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_49;
		L_49 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline(L_47, L_48, (0.0f), NULL);
		NullCheck(L_46);
		Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA(L_46, L_49, NULL);
	}

IL_017b:
	{
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(_stringLiteral24301BAB550EA3EDCE733629ED5B2C4EAC51D777, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RotateCamera_m2EF3E3A2F7E473642F2DA795256A4AF03152F82E (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, float ___0_dx, float ___1_dy, const RuntimeMethod* method) 
{
	{
		bool L_0 = __this->____isVrMode;
		if (!L_0)
		{
			goto IL_0009;
		}
	}
	{
		return;
	}

IL_0009:
	{
		float L_1 = __this->____targetYaw;
		float L_2 = ___0_dx;
		float L_3 = __this->____touchSensitivity;
		__this->____targetYaw = ((float)il2cpp_codegen_add(L_1, ((float)il2cpp_codegen_multiply(L_2, L_3))));
		float L_4 = __this->____targetYaw;
		float L_5;
		L_5 = Mathf_Repeat_m6F1560A163481BB311D685294E1B463C3E4EB3BA_inline(L_4, (360.0f), NULL);
		__this->____targetYaw = L_5;
		float L_6 = __this->____targetPitch;
		float L_7 = ___1_dy;
		float L_8 = __this->____touchSensitivity;
		float L_9 = __this->____minPitch;
		float L_10 = __this->____maxPitch;
		float L_11;
		L_11 = Mathf_Clamp_mEB9AEA827D27D20FCC787F7375156AF46BB12BBF_inline(((float)il2cpp_codegen_subtract(L_6, ((float)il2cpp_codegen_multiply(L_7, L_8)))), L_9, L_10, NULL);
		__this->____targetPitch = L_11;
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RotateCameraFromMessage_mDEB964259C347E05DF224008719468B403D21AF3 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, String_t* ___0_json, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&JsonUtility_FromJson_TisRotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA_m0DC882EF0486A2C8429FE72EF58E917FFF8203C3_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* V_0 = NULL;
	Exception_t* V_1 = NULL;
	il2cpp::utils::ExceptionSupportStack<RuntimeObject*, 1> __active_exceptions;
	{
		String_t* L_0 = ___0_json;
		bool L_1;
		L_1 = String_IsNullOrEmpty_mEA9E3FB005AC28FE02E69FCF95A7B8456192B478(L_0, NULL);
		if (!L_1)
		{
			goto IL_0009;
		}
	}
	{
		return;
	}

IL_0009:
	{
	}
	try
	{
		{
			String_t* L_2 = ___0_json;
			RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* L_3;
			L_3 = JsonUtility_FromJson_TisRotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA_m0DC882EF0486A2C8429FE72EF58E917FFF8203C3(L_2, JsonUtility_FromJson_TisRotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA_m0DC882EF0486A2C8429FE72EF58E917FFF8203C3_RuntimeMethod_var);
			V_0 = L_3;
			RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* L_4 = V_0;
			if (!L_4)
			{
				goto IL_0026_1;
			}
		}
		{
			RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* L_5 = V_0;
			NullCheck(L_5);
			float L_6 = L_5->___dx;
			RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* L_7 = V_0;
			NullCheck(L_7);
			float L_8 = L_7->___dy;
			VRStereoCameraRig_RotateCamera_m2EF3E3A2F7E473642F2DA795256A4AF03152F82E(__this, L_6, L_8, NULL);
		}

IL_0026_1:
		{
			goto IL_0046;
		}
	}
	catch(Il2CppExceptionWrapper& e)
	{
		if(il2cpp_codegen_class_is_assignable_from (((RuntimeClass*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&Exception_t_il2cpp_TypeInfo_var)), il2cpp_codegen_object_class(e.ex)))
		{
			IL2CPP_PUSH_ACTIVE_EXCEPTION(e.ex);
			goto CATCH_0028;
		}
		throw e;
	}

CATCH_0028:
	{
		Exception_t* L_9 = ((Exception_t*)IL2CPP_GET_ACTIVE_EXCEPTION(Exception_t*));;
		V_1 = L_9;
		String_t* L_10 = ___0_json;
		Exception_t* L_11 = V_1;
		NullCheck(L_11);
		String_t* L_12;
		L_12 = VirtualFuncInvoker0< String_t* >::Invoke(5, L_11);
		String_t* L_13;
		L_13 = String_Concat_m093934F71A9B351911EE46311674ED463B180006(((String_t*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&_stringLiteral85BC080D94161C99BB2439899C225C54D81C4E15)), L_10, ((String_t*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&_stringLiteral9816E74B93E1C26A72AD4D2196C8A3C7A3C28924)), L_12, NULL);
		il2cpp_codegen_runtime_class_init_inline(((RuntimeClass*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var)));
		Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9(L_13, NULL);
		IL2CPP_POP_ACTIVE_EXCEPTION(Exception_t*);
		goto IL_0046;
	}

IL_0046:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_Reset2DPan_m9D26E95749F7C2B78303AFDB6582096016905A78 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		__this->____targetYaw = (0.0f);
		__this->____targetPitch = (0.0f);
		__this->____currentYaw = (0.0f);
		__this->____currentPitch = (0.0f);
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_0052;
		}
	}
	{
		bool L_2 = __this->____isVrMode;
		if (L_2)
		{
			goto IL_0052;
		}
	}
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_3 = __this->____headTransform;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_4;
		L_4 = Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline(NULL);
		NullCheck(L_3);
		Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA(L_3, L_4, NULL);
	}

IL_0052:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, bool ___0_enableVr, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		bool L_0 = ___0_enableVr;
		__this->____isVrMode = L_0;
		bool L_1 = ___0_enableVr;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_set_GlobalIsVrMode_m6109AA5B3EE40574B27EFE754C4C41397246BC97_inline(L_1, NULL);
		bool L_2 = __this->____isInitialized;
		if (!L_2)
		{
			goto IL_001b;
		}
	}
	{
		VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A(__this, NULL);
	}

IL_001b:
	{
		bool L_3 = ___0_enableVr;
		if (!L_3)
		{
			goto IL_0024;
		}
	}
	{
		VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242(__this, NULL);
	}

IL_0024:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_SetVrModeFromMessage_m5F6D9A8F3D0B6FCC7E80D4057F807DEC9EADE203 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, String_t* ___0_modeStr, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralB7C45DD316C68ABF3429C20058C2981C652192F2);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralE91FE173F59B063D620A934CE1A010F2B114C1F3);
		s_Il2CppMethodInitialized = true;
	}
	bool V_0 = false;
	int32_t G_B3_0 = 0;
	{
		String_t* L_0 = ___0_modeStr;
		bool L_1;
		L_1 = String_op_Equality_m030E1B219352228970A076136E455C4E568C02C1(L_0, _stringLiteralE91FE173F59B063D620A934CE1A010F2B114C1F3, NULL);
		if (L_1)
		{
			goto IL_001b;
		}
	}
	{
		String_t* L_2 = ___0_modeStr;
		bool L_3;
		L_3 = String_Equals_mCC34895D0DB2AD440C9D8767032215BC86B5C48B(L_2, _stringLiteralB7C45DD316C68ABF3429C20058C2981C652192F2, 5, NULL);
		G_B3_0 = ((int32_t)(L_3));
		goto IL_001c;
	}

IL_001b:
	{
		G_B3_0 = 1;
	}

IL_001c:
	{
		V_0 = (bool)G_B3_0;
		bool L_4 = V_0;
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(__this, L_4, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral98CEDCF77F67B56E17FDDC62623475CE278853E6);
		s_Il2CppMethodInitialized = true;
	}
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_0;
	memset((&V_0), 0, sizeof(V_0));
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_1;
	memset((&V_1), 0, sizeof(V_1));
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_2;
	memset((&V_2), 0, sizeof(V_2));
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_3;
	memset((&V_3), 0, sizeof(V_3));
	float V_4 = 0.0f;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 G_B6_0;
	memset((&G_B6_0), 0, sizeof(G_B6_0));
	{
		bool L_0 = __this->____hasGyro;
		if (!L_0)
		{
			goto IL_0014;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_1;
		L_1 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_1);
		bool L_2;
		L_2 = Gyroscope_get_enabled_m10F5B3F646AB1A6EEE2831010642E9E1E0BCBDB9(L_1, NULL);
		if (L_2)
		{
			goto IL_0020;
		}
	}

IL_0014:
	{
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_3;
		L_3 = Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline(NULL);
		__this->____recalibrationOffset = L_3;
		return;
	}

IL_0020:
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_4;
		L_4 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_4);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_5;
		L_5 = Gyroscope_get_attitude_mF6D8131ED2D0E5BF979C7FC4AAC99E87A01CBE85(L_4, NULL);
		V_0 = L_5;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_6 = V_0;
		float L_7 = L_6.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_8 = V_0;
		float L_9 = L_8.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_10 = V_0;
		float L_11 = L_10.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_12 = V_0;
		float L_13 = L_12.___w;
		Quaternion__ctor_m868FD60AA65DD5A8AC0C5DEB0608381A8D85FCD8_inline((&V_1), L_7, L_9, ((-L_11)), ((-L_13)), NULL);
		int32_t L_14;
		L_14 = Screen_get_orientation_mA6B22A441187D50831B2B18CA48A8F64BD1BD89E(NULL);
		if ((((int32_t)L_14) == ((int32_t)4)))
		{
			goto IL_005b;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_15 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeLeftCompensation;
		G_B6_0 = L_15;
		goto IL_0060;
	}

IL_005b:
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_16 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeRightCompensation;
		G_B6_0 = L_16;
	}

IL_0060:
	{
		V_2 = G_B6_0;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_17 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___BaseOrientation;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_18 = V_1;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_19;
		L_19 = Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline(L_17, L_18, NULL);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_20 = V_2;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_21;
		L_21 = Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline(L_19, L_20, NULL);
		V_3 = L_21;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_22;
		L_22 = Quaternion_get_eulerAngles_m2DB5158B5C3A71FD60FC8A6EE43D3AAA1CFED122_inline((&V_3), NULL);
		float L_23 = L_22.___y;
		V_4 = L_23;
		float L_24 = V_4;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_25;
		L_25 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline((0.0f), ((-L_24)), (0.0f), NULL);
		__this->____recalibrationOffset = L_25;
		float L_26 = V_4;
		float L_27 = ((-L_26));
		RuntimeObject* L_28 = Box(il2cpp_defaults.single_class, &L_27);
		String_t* L_29;
		L_29 = String_Format_mA8DBB4C2516B9723C5A41E6CB1E2FAF4BBE96DD8(_stringLiteral98CEDCF77F67B56E17FDDC62623475CE278853E6, L_28, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_29, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RecalibrateFromMessage_m43C673C71A4DE2391A3EB1BB9E71B63DB486E41E (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, String_t* ___0__, const RuntimeMethod* method) 
{
	{
		VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_SetVrModeGlobal_mCE6F4FB91D20AE227494B2AFBF1D8FFC03F6CE1E (bool ___0_isVr, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		bool L_0 = ___0_isVr;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_set_GlobalIsVrMode_m6109AA5B3EE40574B27EFE754C4C41397246BC97_inline(L_0, NULL);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_1 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_2;
		L_2 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_1, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_2)
		{
			goto IL_001e;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_3 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		bool L_4 = ___0_isVr;
		NullCheck(L_3);
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(L_3, L_4, NULL);
	}

IL_001e:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_RecalibrateGlobal_mF5A58F35894332E208338063C98E781F354F554F (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_0 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Inequality_mD0BE578448EAA61948F25C32F8DD55AB1F778602(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_0017;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* L_2 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->____instance;
		NullCheck(L_2);
		VRStereoCameraRig_Recalibrate_m0076C8074D6F8C654692CA14BC0D2FC249E24242(L_2, NULL);
	}

IL_0017:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_LateUpdate_m48E16C926FB10EFDF1108A8DDB38CBF1AB22C8F8 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	float V_0 = 0.0f;
	Touch_t03E51455ED508492B3F278903A0114FA0E87B417 V_1;
	memset((&V_1), 0, sizeof(V_1));
	float V_2 = 0.0f;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_3;
	memset((&V_3), 0, sizeof(V_3));
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_4;
	memset((&V_4), 0, sizeof(V_4));
	int32_t V_5 = 0;
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_6;
	memset((&V_6), 0, sizeof(V_6));
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_7;
	memset((&V_7), 0, sizeof(V_7));
	{
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_0 = __this->____headTransform;
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_000f;
		}
	}
	{
		return;
	}

IL_000f:
	{
		bool L_2 = __this->____isVrMode;
		if (L_2)
		{
			goto IL_010a;
		}
	}
	{
		int32_t L_3;
		L_3 = Input_get_touchCount_m057388BFC67A0F4CA53764B1022867ED81D01E39(NULL);
		if ((!(((uint32_t)L_3) == ((uint32_t)1))))
		{
			goto IL_0051;
		}
	}
	{
		Touch_t03E51455ED508492B3F278903A0114FA0E87B417 L_4;
		L_4 = Input_GetTouch_m75D99FE801A94279874FA8DC6B6ADAD35F5123B1(0, NULL);
		V_1 = L_4;
		int32_t L_5;
		L_5 = Touch_get_phase_mB82409FB2BE1C32ABDBA6A72E52A099D28AB70B0_inline((&V_1), NULL);
		if ((!(((uint32_t)L_5) == ((uint32_t)1))))
		{
			goto IL_0051;
		}
	}
	{
		Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 L_6;
		L_6 = Touch_get_deltaPosition_m2D51F960B74C94821ED0F6A09E44C80FD796D299_inline((&V_1), NULL);
		float L_7 = L_6.___x;
		Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 L_8;
		L_8 = Touch_get_deltaPosition_m2D51F960B74C94821ED0F6A09E44C80FD796D299_inline((&V_1), NULL);
		float L_9 = L_8.___y;
		VRStereoCameraRig_RotateCamera_m2EF3E3A2F7E473642F2DA795256A4AF03152F82E(__this, L_7, L_9, NULL);
	}

IL_0051:
	{
		float L_10;
		L_10 = Time_get_unscaledDeltaTime_mF057EECA857E5C0F90A3F910D26D3EE59F27C4B5(NULL);
		V_0 = L_10;
		float L_11 = __this->____panSmoothing;
		if ((!(((float)L_11) > ((float)(0.0f)))))
		{
			goto IL_00b3;
		}
	}
	{
		float L_12 = V_0;
		if ((!(((float)L_12) > ((float)(0.0f)))))
		{
			goto IL_00b3;
		}
	}
	{
		float L_13 = __this->____panSmoothing;
		float L_14 = V_0;
		float L_15;
		L_15 = expf(((float)il2cpp_codegen_multiply(((-L_13)), L_14)));
		V_2 = ((float)il2cpp_codegen_subtract((1.0f), L_15));
		float L_16 = __this->____currentYaw;
		float L_17 = __this->____targetYaw;
		float L_18 = V_2;
		float L_19;
		L_19 = Mathf_LerpAngle_m0653422E15193C2E4A4E5AF05236B6315C789C23_inline(L_16, L_17, L_18, NULL);
		__this->____currentYaw = L_19;
		float L_20 = __this->____currentPitch;
		float L_21 = __this->____targetPitch;
		float L_22 = V_2;
		float L_23;
		L_23 = Mathf_Lerp_m47EF2FFB7647BD0A1FDC26DC03E28B19812139B5_inline(L_20, L_21, L_22, NULL);
		__this->____currentPitch = L_23;
		goto IL_00cb;
	}

IL_00b3:
	{
		float L_24 = __this->____targetYaw;
		__this->____currentYaw = L_24;
		float L_25 = __this->____targetPitch;
		__this->____currentPitch = L_25;
	}

IL_00cb:
	{
		float L_26 = __this->____currentPitch;
		float L_27 = __this->____minPitch;
		float L_28 = __this->____maxPitch;
		float L_29;
		L_29 = Mathf_Clamp_mEB9AEA827D27D20FCC787F7375156AF46BB12BBF_inline(L_26, L_27, L_28, NULL);
		__this->____currentPitch = L_29;
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_30 = __this->____headTransform;
		float L_31 = __this->____currentPitch;
		float L_32 = __this->____currentYaw;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_33;
		L_33 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline(L_31, L_32, (0.0f), NULL);
		NullCheck(L_30);
		Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA(L_30, L_33, NULL);
		return;
	}

IL_010a:
	{
		bool L_34 = __this->____enableGyroTracking;
		if (L_34)
		{
			goto IL_0113;
		}
	}
	{
		return;
	}

IL_0113:
	{
		bool L_35 = __this->____hasGyro;
		if (!L_35)
		{
			goto IL_01b0;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_36;
		L_36 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_36);
		bool L_37;
		L_37 = Gyroscope_get_enabled_m10F5B3F646AB1A6EEE2831010642E9E1E0BCBDB9(L_36, NULL);
		if (!L_37)
		{
			goto IL_01b0;
		}
	}
	{
		Gyroscope_tA4CEC0F47FFB4CEB90410CC6B860D052BB35BE9E* L_38;
		L_38 = Input_get_gyro_m895498B803FE9A3124FBFE3C05966431F8840548(NULL);
		NullCheck(L_38);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_39;
		L_39 = Gyroscope_get_attitude_mF6D8131ED2D0E5BF979C7FC4AAC99E87A01CBE85(L_38, NULL);
		V_3 = L_39;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_40 = V_3;
		float L_41 = L_40.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_42 = V_3;
		float L_43 = L_42.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_44 = V_3;
		float L_45 = L_44.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_46 = V_3;
		float L_47 = L_46.___w;
		Quaternion__ctor_m868FD60AA65DD5A8AC0C5DEB0608381A8D85FCD8_inline((&V_4), L_41, L_43, ((-L_45)), ((-L_47)), NULL);
		int32_t L_48;
		L_48 = Screen_get_orientation_mA6B22A441187D50831B2B18CA48A8F64BD1BD89E(NULL);
		V_5 = L_48;
		int32_t L_49 = V_5;
		if ((!(((uint32_t)L_49) == ((uint32_t)4))))
		{
			goto IL_016e;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_50 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeRightCompensation;
		V_6 = L_50;
		goto IL_0183;
	}

IL_016e:
	{
		int32_t L_51 = V_5;
		if ((!(((uint32_t)L_51) == ((uint32_t)1))))
		{
			goto IL_017c;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_52 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___PortraitCompensation;
		V_6 = L_52;
		goto IL_0183;
	}

IL_017c:
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_53 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeLeftCompensation;
		V_6 = L_53;
	}

IL_0183:
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_54 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___BaseOrientation;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_55 = V_4;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_56;
		L_56 = Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline(L_54, L_55, NULL);
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_57 = V_6;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_58;
		L_58 = Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline(L_56, L_57, NULL);
		V_7 = L_58;
		Transform_tB27202C6F4E36D225EE28A13E4D662BF99785DB1* L_59 = __this->____headTransform;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_60 = __this->____recalibrationOffset;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_61 = V_7;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_62;
		L_62 = Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline(L_60, L_61, NULL);
		NullCheck(L_59);
		Transform_set_localRotation_mAB4A011D134BA58AB780BECC0025CA65F16185FA(L_59, L_62, NULL);
	}

IL_01b0:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_OnSceneLoaded_mB6D505BE7BAF4D1EF3071376D5D5D2E1972F461B (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, Scene_tA1DC762B79745EB5140F054C884855B922318356 ___0_scene, int32_t ___1_mode, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GC_t920F9CF6EBB7C787E5010A4352E1B587F356DC58_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&LoadSceneMode_t3E17ADA25A3C4F14ECF6026741219437DA054963_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral3144D3F473EBCC1B9BC49D9037872EC6D4FE15DC);
		s_Il2CppMethodInitialized = true;
	}
	{
		String_t* L_0;
		L_0 = Scene_get_name_m3C818DFA663E159274DAD823B780C7616C5E2A8C((&___0_scene), NULL);
		int32_t L_1 = ___1_mode;
		int32_t L_2 = L_1;
		RuntimeObject* L_3 = Box(LoadSceneMode_t3E17ADA25A3C4F14ECF6026741219437DA054963_il2cpp_TypeInfo_var, &L_2);
		bool L_4 = __this->____isVrMode;
		bool L_5 = L_4;
		RuntimeObject* L_6 = Box(il2cpp_defaults.boolean_class, &L_5);
		String_t* L_7;
		L_7 = String_Format_mA0534D6E2AE4D67A6BD8D45B3321323930EB930C(_stringLiteral3144D3F473EBCC1B9BC49D9037872EC6D4FE15DC, L_0, L_3, L_6, NULL);
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_7, NULL);
		VRStereoCameraRig_AutoSetupRig_mB4E61BD00002D79D4CDF37BA86E3DECC26B28B2F(__this, NULL);
		VRStereoCameraRig_ApplyModeSettings_mEE838BEFC386BE6E651B0553EF3A8872C467CE9A(__this, NULL);
		AsyncOperation_tD2789250E4B098DEDA92B366A577E500A92D2D3C* L_8;
		L_8 = Resources_UnloadUnusedAssets_m4003CD3EBC3AC2738DE9F2960D5BC45818C1F12B(NULL);
		il2cpp_codegen_runtime_class_init_inline(GC_t920F9CF6EBB7C787E5010A4352E1B587F356DC58_il2cpp_TypeInfo_var);
		GC_Collect_m43D435501E4B72E382DB08A0431DE01D550F76A7(NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral4110DFC6A27616FFCA93EC70E7DCD20FEE985F91);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral58BB01568EA9632856160FC015FD7B06EDD1F667);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral82D9834C0789DEA27A1C0AABE4EB99B77AEA3659);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralB11483976AA9882F71817EA7C833D646C34C0D86);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralBCB8EA8CE44BF70D2BDF275460B04C40B746F52E);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralEA2D7547088757F5477C2A061305F2DAD5939558);
		s_Il2CppMethodInitialized = true;
	}
	Type_t* V_0 = NULL;
	EventInfo_t* V_1 = NULL;
	EventInfo_t* V_2 = NULL;
	Delegate_t* V_3 = NULL;
	Delegate_t* V_4 = NULL;
	Exception_t* V_5 = NULL;
	il2cpp::utils::ExceptionSupportStack<RuntimeObject*, 1> __active_exceptions;
	Type_t* G_B2_0 = NULL;
	Type_t* G_B1_0 = NULL;
	try
	{
		{
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			Type_t* L_0;
			L_0 = il2cpp_codegen_get_type(_stringLiteral58BB01568EA9632856160FC015FD7B06EDD1F667, Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var, VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D_RuntimeMethod_var);
			Type_t* L_1 = L_0;
			if (L_1)
			{
				G_B2_0 = L_1;
				goto IL_0018_1;
			}
			G_B1_0 = L_1;
		}
		{
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			Type_t* L_2;
			L_2 = il2cpp_codegen_get_type(_stringLiteralEA2D7547088757F5477C2A061305F2DAD5939558, Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var, VRStereoCameraRig_HookFlutterBridgeEvents_m7CF3BAE960BAEECB8547297BF45CEBB8AF44B02D_RuntimeMethod_var);
			G_B2_0 = L_2;
		}

IL_0018_1:
		{
			V_0 = G_B2_0;
			Type_t* L_3 = V_0;
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			bool L_4;
			L_4 = Type_op_Inequality_m83209C7BB3C05DFBEA3B6199B0BEFE8037301172(L_3, (Type_t*)NULL, NULL);
			if (!L_4)
			{
				goto IL_0098_1;
			}
		}
		{
			Type_t* L_5 = V_0;
			NullCheck(L_5);
			EventInfo_t* L_6;
			L_6 = Type_GetEvent_mB4D71EF747D967D102846CB4FADA5DA0291E6A83(L_5, _stringLiteralB11483976AA9882F71817EA7C833D646C34C0D86, NULL);
			V_1 = L_6;
			EventInfo_t* L_7 = V_1;
			bool L_8;
			L_8 = EventInfo_op_Inequality_m4B5352D516359B10994084CAE273A1EF64E50B40(L_7, (EventInfo_t*)NULL, NULL);
			if (!L_8)
			{
				goto IL_005c_1;
			}
		}
		{
			EventInfo_t* L_9 = V_1;
			NullCheck(L_9);
			Type_t* L_10;
			L_10 = VirtualFuncInvoker0< Type_t* >::Invoke(22, L_9);
			Type_t* L_11;
			L_11 = Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3(__this, NULL);
			NullCheck(L_11);
			MethodInfo_t* L_12;
			L_12 = Type_GetMethod_m66AD062187F19497DBCA900823B0C268322DC231(L_11, _stringLiteralBCB8EA8CE44BF70D2BDF275460B04C40B746F52E, NULL);
			Delegate_t* L_13;
			L_13 = Delegate_CreateDelegate_mE2117ED279628E4E63D357AFAB3653DD909CB2D7(L_10, __this, L_12, NULL);
			V_3 = L_13;
			EventInfo_t* L_14 = V_1;
			Delegate_t* L_15 = V_3;
			NullCheck(L_14);
			VirtualActionInvoker2< RuntimeObject*, Delegate_t* >::Invoke(24, L_14, NULL, L_15);
		}

IL_005c_1:
		{
			Type_t* L_16 = V_0;
			NullCheck(L_16);
			EventInfo_t* L_17;
			L_17 = Type_GetEvent_mB4D71EF747D967D102846CB4FADA5DA0291E6A83(L_16, _stringLiteral4110DFC6A27616FFCA93EC70E7DCD20FEE985F91, NULL);
			V_2 = L_17;
			EventInfo_t* L_18 = V_2;
			bool L_19;
			L_19 = EventInfo_op_Inequality_m4B5352D516359B10994084CAE273A1EF64E50B40(L_18, (EventInfo_t*)NULL, NULL);
			if (!L_19)
			{
				goto IL_0098_1;
			}
		}
		{
			EventInfo_t* L_20 = V_2;
			NullCheck(L_20);
			Type_t* L_21;
			L_21 = VirtualFuncInvoker0< Type_t* >::Invoke(22, L_20);
			Type_t* L_22;
			L_22 = Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3(__this, NULL);
			NullCheck(L_22);
			MethodInfo_t* L_23;
			L_23 = Type_GetMethod_m66AD062187F19497DBCA900823B0C268322DC231(L_22, _stringLiteral82D9834C0789DEA27A1C0AABE4EB99B77AEA3659, NULL);
			Delegate_t* L_24;
			L_24 = Delegate_CreateDelegate_mE2117ED279628E4E63D357AFAB3653DD909CB2D7(L_21, __this, L_23, NULL);
			V_4 = L_24;
			EventInfo_t* L_25 = V_2;
			Delegate_t* L_26 = V_4;
			NullCheck(L_25);
			VirtualActionInvoker2< RuntimeObject*, Delegate_t* >::Invoke(24, L_25, NULL, L_26);
		}

IL_0098_1:
		{
			goto IL_00b4;
		}
	}
	catch(Il2CppExceptionWrapper& e)
	{
		if(il2cpp_codegen_class_is_assignable_from (((RuntimeClass*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&Exception_t_il2cpp_TypeInfo_var)), il2cpp_codegen_object_class(e.ex)))
		{
			IL2CPP_PUSH_ACTIVE_EXCEPTION(e.ex);
			goto CATCH_009a;
		}
		throw e;
	}

CATCH_009a:
	{
		Exception_t* L_27 = ((Exception_t*)IL2CPP_GET_ACTIVE_EXCEPTION(Exception_t*));;
		V_5 = L_27;
		Exception_t* L_28 = V_5;
		NullCheck(L_28);
		String_t* L_29;
		L_29 = VirtualFuncInvoker0< String_t* >::Invoke(5, L_28);
		String_t* L_30;
		L_30 = String_Concat_m9E3155FB84015C823606188F53B47CB44C444991(((String_t*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&_stringLiteral753F7D6BB673707350C1F4C6F341972B7F8D5CEA)), L_29, NULL);
		il2cpp_codegen_runtime_class_init_inline(((RuntimeClass*)il2cpp_codegen_initialize_runtime_metadata_inline((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var)));
		Debug_Log_m87A9A3C761FF5C43ED8A53B16190A53D08F818BB(L_30, NULL);
		IL2CPP_POP_ACTIVE_EXCEPTION(Exception_t*);
		goto IL_00b4;
	}

IL_00b4:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876 (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral4110DFC6A27616FFCA93EC70E7DCD20FEE985F91);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral58BB01568EA9632856160FC015FD7B06EDD1F667);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral82D9834C0789DEA27A1C0AABE4EB99B77AEA3659);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralB11483976AA9882F71817EA7C833D646C34C0D86);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralBCB8EA8CE44BF70D2BDF275460B04C40B746F52E);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteralEA2D7547088757F5477C2A061305F2DAD5939558);
		s_Il2CppMethodInitialized = true;
	}
	Type_t* V_0 = NULL;
	EventInfo_t* V_1 = NULL;
	EventInfo_t* V_2 = NULL;
	Delegate_t* V_3 = NULL;
	Delegate_t* V_4 = NULL;
	il2cpp::utils::ExceptionSupportStack<RuntimeObject*, 1> __active_exceptions;
	Type_t* G_B2_0 = NULL;
	Type_t* G_B1_0 = NULL;
	try
	{
		{
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			Type_t* L_0;
			L_0 = il2cpp_codegen_get_type(_stringLiteral58BB01568EA9632856160FC015FD7B06EDD1F667, Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var, VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876_RuntimeMethod_var);
			Type_t* L_1 = L_0;
			if (L_1)
			{
				G_B2_0 = L_1;
				goto IL_0018_1;
			}
			G_B1_0 = L_1;
		}
		{
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			Type_t* L_2;
			L_2 = il2cpp_codegen_get_type(_stringLiteralEA2D7547088757F5477C2A061305F2DAD5939558, Type_GetType_m71A077E0B5DA3BD1DC0AB9AE387056CFCF56F93F_RuntimeMethod_var, VRStereoCameraRig_UnhookFlutterBridgeEvents_m11D8374CBDDE277E3D4BA6D44997F132E6C85876_RuntimeMethod_var);
			G_B2_0 = L_2;
		}

IL_0018_1:
		{
			V_0 = G_B2_0;
			Type_t* L_3 = V_0;
			il2cpp_codegen_runtime_class_init_inline(il2cpp_defaults.systemtype_class);
			bool L_4;
			L_4 = Type_op_Inequality_m83209C7BB3C05DFBEA3B6199B0BEFE8037301172(L_3, (Type_t*)NULL, NULL);
			if (!L_4)
			{
				goto IL_0098_1;
			}
		}
		{
			Type_t* L_5 = V_0;
			NullCheck(L_5);
			EventInfo_t* L_6;
			L_6 = Type_GetEvent_mB4D71EF747D967D102846CB4FADA5DA0291E6A83(L_5, _stringLiteralB11483976AA9882F71817EA7C833D646C34C0D86, NULL);
			V_1 = L_6;
			EventInfo_t* L_7 = V_1;
			bool L_8;
			L_8 = EventInfo_op_Inequality_m4B5352D516359B10994084CAE273A1EF64E50B40(L_7, (EventInfo_t*)NULL, NULL);
			if (!L_8)
			{
				goto IL_005c_1;
			}
		}
		{
			EventInfo_t* L_9 = V_1;
			NullCheck(L_9);
			Type_t* L_10;
			L_10 = VirtualFuncInvoker0< Type_t* >::Invoke(22, L_9);
			Type_t* L_11;
			L_11 = Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3(__this, NULL);
			NullCheck(L_11);
			MethodInfo_t* L_12;
			L_12 = Type_GetMethod_m66AD062187F19497DBCA900823B0C268322DC231(L_11, _stringLiteralBCB8EA8CE44BF70D2BDF275460B04C40B746F52E, NULL);
			Delegate_t* L_13;
			L_13 = Delegate_CreateDelegate_mE2117ED279628E4E63D357AFAB3653DD909CB2D7(L_10, __this, L_12, NULL);
			V_3 = L_13;
			EventInfo_t* L_14 = V_1;
			Delegate_t* L_15 = V_3;
			NullCheck(L_14);
			VirtualActionInvoker2< RuntimeObject*, Delegate_t* >::Invoke(23, L_14, NULL, L_15);
		}

IL_005c_1:
		{
			Type_t* L_16 = V_0;
			NullCheck(L_16);
			EventInfo_t* L_17;
			L_17 = Type_GetEvent_mB4D71EF747D967D102846CB4FADA5DA0291E6A83(L_16, _stringLiteral4110DFC6A27616FFCA93EC70E7DCD20FEE985F91, NULL);
			V_2 = L_17;
			EventInfo_t* L_18 = V_2;
			bool L_19;
			L_19 = EventInfo_op_Inequality_m4B5352D516359B10994084CAE273A1EF64E50B40(L_18, (EventInfo_t*)NULL, NULL);
			if (!L_19)
			{
				goto IL_0098_1;
			}
		}
		{
			EventInfo_t* L_20 = V_2;
			NullCheck(L_20);
			Type_t* L_21;
			L_21 = VirtualFuncInvoker0< Type_t* >::Invoke(22, L_20);
			Type_t* L_22;
			L_22 = Object_GetType_mE10A8FC1E57F3DF29972CCBC026C2DC3942263B3(__this, NULL);
			NullCheck(L_22);
			MethodInfo_t* L_23;
			L_23 = Type_GetMethod_m66AD062187F19497DBCA900823B0C268322DC231(L_22, _stringLiteral82D9834C0789DEA27A1C0AABE4EB99B77AEA3659, NULL);
			Delegate_t* L_24;
			L_24 = Delegate_CreateDelegate_mE2117ED279628E4E63D357AFAB3653DD909CB2D7(L_21, __this, L_23, NULL);
			V_4 = L_24;
			EventInfo_t* L_25 = V_2;
			Delegate_t* L_26 = V_4;
			NullCheck(L_25);
			VirtualActionInvoker2< RuntimeObject*, Delegate_t* >::Invoke(23, L_25, NULL, L_26);
		}

IL_0098_1:
		{
			goto IL_009d;
		}
	}
	catch(Il2CppExceptionWrapper& e)
	{
		if(il2cpp_codegen_class_is_assignable_from (il2cpp_defaults.object_class, il2cpp_codegen_object_class(e.ex)))
		{
			IL2CPP_PUSH_ACTIVE_EXCEPTION(e.ex);
			goto CATCH_009a;
		}
		throw e;
	}

CATCH_009a:
	{
		RuntimeObject* L_27 = ((RuntimeObject*)IL2CPP_GET_ACTIVE_EXCEPTION(RuntimeObject*));;
		IL2CPP_POP_ACTIVE_EXCEPTION(Exception_t*);
		goto IL_009d;
	}

IL_009d:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig_OnBridgeVrModeChanged_m4AEF48AF8B29A6B8990D8D638DFFF152A83E38EE (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, bool ___0_isVr, const RuntimeMethod* method) 
{
	{
		bool L_0 = ___0_isVr;
		VRStereoCameraRig_SetVrMode_mE7B5A8ACB4DC222E46C45AA502FBC29369F9CF47(__this, L_0, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig__ctor_m61A50F84D53B0C78A857B3FBBE01CC9CF282B42F (VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02* __this, const RuntimeMethod* method) 
{
	{
		__this->____ipdMeters = (0.064000003f);
		__this->____enableGyroTracking = (bool)1;
		__this->____touchSensitivity = (0.150000006f);
		__this->____panSmoothing = (20.0f);
		__this->____minPitch = (-75.0f);
		__this->____maxPitch = (75.0f);
		__this->____enableEditorMouseLook = (bool)1;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_0;
		L_0 = Vector3_get_zero_m0C1249C3F25B1C70EAD3CC8B31259975A457AE39_inline(NULL);
		__this->____eyeLocalPosMono = L_0;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_1;
		L_1 = Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline(NULL);
		__this->____recalibrationOffset = L_1;
		MonoBehaviour__ctor_m592DB0105CA0BC97AA1C5F4AD27B12D68A3B7C1E(__this, NULL);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VRStereoCameraRig__cctor_m63695D6D439060846D04366C821BD5D5F373BC77 (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___U3CGlobalIsVrModeU3Ek__BackingField = (bool)0;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_0;
		L_0 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline((90.0f), (0.0f), (0.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___BaseOrientation = L_0;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_1;
		L_1 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline((0.0f), (0.0f), (-90.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeLeftCompensation = L_1;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_2;
		L_2 = Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline((0.0f), (0.0f), (90.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___LandscapeRightCompensation = L_2;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_3;
		L_3 = Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline(NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___PortraitCompensation = L_3;
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_4;
		memset((&L_4), 0, sizeof(L_4));
		Rect__ctor_m18C3033D135097BEE424AAA68D91C706D2647F23_inline((&L_4), (0.0f), (0.0f), (0.5f), (1.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoLeft = L_4;
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_5;
		memset((&L_5), 0, sizeof(L_5));
		Rect__ctor_m18C3033D135097BEE424AAA68D91C706D2647F23_inline((&L_5), (0.5f), (0.0f), (0.5f), (1.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectStereoRight = L_5;
		Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D L_6;
		memset((&L_6), 0, sizeof(L_6));
		Rect__ctor_m18C3033D135097BEE424AAA68D91C706D2647F23_inline((&L_6), (0.0f), (0.0f), (1.0f), (1.0f), NULL);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___RectMonoFullScreen = L_6;
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void RotateCameraDto__ctor_m0DBBF4BE8BFA575EB1C9B6A38919CBD11B03DF5B (RotateCameraDto_tA467389AB39961936C5A5D9F30E5180CF82E79FA* __this, const RuntimeMethod* method) 
{
	{
		Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR RuntimeObject* StateMachine_get_CurrentState_m4200000446B203895C3480D0851E2045139954F0 (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, const RuntimeMethod* method) 
{
	{
		RuntimeObject* L_0 = __this->____currentState;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR RuntimeObject* StateMachine_get_PreviousState_m55DD5C98D4016D4E0A236AA75D2C9D77862124B1 (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, const RuntimeMethod* method) 
{
	{
		RuntimeObject* L_0 = __this->____previousState;
		return L_0;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StateMachine_add_OnStateChanged_m678EAD93E7CE0B8B11583838363B39938E6144AE (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* ___0_value, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Action_2_t0573B13685F7D1632AFBF12A72947EC189082208_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_0 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_1 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_2 = NULL;
	{
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_0 = __this->___OnStateChanged;
		V_0 = L_0;
	}

IL_0007:
	{
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_1 = V_0;
		V_1 = L_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_2 = V_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_3 = ___0_value;
		Delegate_t* L_4;
		L_4 = Delegate_Combine_m1F725AEF318BE6F0426863490691A6F4606E7D00(L_2, L_3, NULL);
		V_2 = ((Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)Castclass((RuntimeObject*)L_4, Action_2_t0573B13685F7D1632AFBF12A72947EC189082208_il2cpp_TypeInfo_var));
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208** L_5 = (Action_2_t0573B13685F7D1632AFBF12A72947EC189082208**)(&__this->___OnStateChanged);
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_6 = V_2;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_7 = V_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_8;
		L_8 = InterlockedCompareExchangeImpl<Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*>(L_5, L_6, L_7);
		V_0 = L_8;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_9 = V_0;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_10 = V_1;
		if ((!(((RuntimeObject*)(Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)L_9) == ((RuntimeObject*)(Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)L_10))))
		{
			goto IL_0007;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StateMachine_remove_OnStateChanged_m9C754555424C6A2C320DE41F224BE0CF14284F2F (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* ___0_value, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Action_2_t0573B13685F7D1632AFBF12A72947EC189082208_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_0 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_1 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* V_2 = NULL;
	{
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_0 = __this->___OnStateChanged;
		V_0 = L_0;
	}

IL_0007:
	{
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_1 = V_0;
		V_1 = L_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_2 = V_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_3 = ___0_value;
		Delegate_t* L_4;
		L_4 = Delegate_Remove_m8B7DD5661308FA972E23CA1CC3FC9CEB355504E3(L_2, L_3, NULL);
		V_2 = ((Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)Castclass((RuntimeObject*)L_4, Action_2_t0573B13685F7D1632AFBF12A72947EC189082208_il2cpp_TypeInfo_var));
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208** L_5 = (Action_2_t0573B13685F7D1632AFBF12A72947EC189082208**)(&__this->___OnStateChanged);
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_6 = V_2;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_7 = V_1;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_8;
		L_8 = InterlockedCompareExchangeImpl<Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*>(L_5, L_6, L_7);
		V_0 = L_8;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_9 = V_0;
		Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_10 = V_1;
		if ((!(((RuntimeObject*)(Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)L_9) == ((RuntimeObject*)(Action_2_t0573B13685F7D1632AFBF12A72947EC189082208*)L_10))))
		{
			goto IL_0007;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StateMachine_ChangeState_m59794D73F406A74DA593ECCA1175E7777D73C7E2 (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, RuntimeObject* ___0_newState, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral35A0B4FD90759A33EA223EBB8BEA69368E955F11);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral75F619534A93FA16E3265FD238517C8064975836);
		s_Il2CppMethodInitialized = true;
	}
	RuntimeObject* G_B9_0 = NULL;
	RuntimeObject* G_B8_0 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* G_B12_0 = NULL;
	Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* G_B11_0 = NULL;
	{
		RuntimeObject* L_0 = ___0_newState;
		if (L_0)
		{
			goto IL_000e;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9(_stringLiteral35A0B4FD90759A33EA223EBB8BEA69368E955F11, NULL);
		return;
	}

IL_000e:
	{
		RuntimeObject* L_1 = __this->____currentState;
		RuntimeObject* L_2 = ___0_newState;
		if ((!(((RuntimeObject*)(RuntimeObject*)L_1) == ((RuntimeObject*)(RuntimeObject*)L_2))))
		{
			goto IL_0018;
		}
	}
	{
		return;
	}

IL_0018:
	{
		bool L_3 = __this->____isTransitioning;
		if (!L_3)
		{
			goto IL_002b;
		}
	}
	{
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_LogError_mB00B2B4468EF3CAF041B038D840820FB84C924B2(_stringLiteral75F619534A93FA16E3265FD238517C8064975836, NULL);
		return;
	}

IL_002b:
	{
		__this->____isTransitioning = (bool)1;
	}
	{
		auto __finallyBlock = il2cpp::utils::Finally([&]
		{

FINALLY_0080:
			{
				__this->____isTransitioning = (bool)0;
				return;
			}
		});
		try
		{
			{
				RuntimeObject* L_4 = __this->____currentState;
				__this->____previousState = L_4;
				Il2CppCodeGenWriteBarrier((void**)(&__this->____previousState), (void*)L_4);
				RuntimeObject* L_5 = __this->____currentState;
				RuntimeObject* L_6 = L_5;
				if (L_6)
				{
					G_B9_0 = L_6;
					goto IL_004a_1;
				}
				G_B8_0 = L_6;
			}
			{
				goto IL_004f_1;
			}

IL_004a_1:
			{
				NullCheck(G_B9_0);
				InterfaceActionInvoker0::Invoke(2, IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var, G_B9_0);
			}

IL_004f_1:
			{
				RuntimeObject* L_7 = ___0_newState;
				__this->____currentState = L_7;
				Il2CppCodeGenWriteBarrier((void**)(&__this->____currentState), (void*)L_7);
				RuntimeObject* L_8 = __this->____currentState;
				NullCheck(L_8);
				InterfaceActionInvoker0::Invoke(0, IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var, L_8);
				Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_9 = __this->___OnStateChanged;
				Action_2_t0573B13685F7D1632AFBF12A72947EC189082208* L_10 = L_9;
				if (L_10)
				{
					G_B12_0 = L_10;
					goto IL_006d_1;
				}
				G_B11_0 = L_10;
			}
			{
				goto IL_0088;
			}

IL_006d_1:
			{
				RuntimeObject* L_11 = __this->____previousState;
				RuntimeObject* L_12 = __this->____currentState;
				NullCheck(G_B12_0);
				Action_2_Invoke_mA60F6B56FCF50002888F967B8D4EF9D27DA99CFF_inline(G_B12_0, L_11, L_12, NULL);
				goto IL_0088;
			}
		}
		catch(Il2CppExceptionWrapper& e)
		{
			__finallyBlock.StoreException(e.ex);
		}
	}

IL_0088:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StateMachine_Update_mE9949FF6B4ABF29B8D18B34F74545418C547EB72 (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, float ___0_deltaTime, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		RuntimeObject* L_0 = __this->____currentState;
		if (!L_0)
		{
			goto IL_001c;
		}
	}
	{
		bool L_1 = __this->____isTransitioning;
		if (L_1)
		{
			goto IL_001c;
		}
	}
	{
		RuntimeObject* L_2 = __this->____currentState;
		float L_3 = ___0_deltaTime;
		NullCheck(L_2);
		InterfaceActionInvoker1< float >::Invoke(1, IState_t8FFE0D213FD5FAF9261C2F7577DD11061C3FC9C8_il2cpp_TypeInfo_var, L_2, L_3);
	}

IL_001c:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StateMachine__ctor_mBCA8B7700BA20470D4EF83748C5EE87D717D73BA (StateMachine_tD8F8AEE64F67A952FCC058B90B23B4F763432E96* __this, const RuntimeMethod* method) 
{
	{
		Object__ctor_mE837C6B9FA8C6D5D109F4B2EC885D79919AC0EA2(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void BoolEventChannelSO__ctor_m15774D80DC8ABDC96CC6BDCE1B9458D582CEFEDC (BoolEventChannelSO_t9A16108D782FA74ABE10D2C07CECBE863E7CDF32* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GenericEventChannelSO_1__ctor_mA74BA91BA6D1979DAC4F47F402DFC007C2C45E2F_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		GenericEventChannelSO_1__ctor_mA74BA91BA6D1979DAC4F47F402DFC007C2C45E2F(__this, GenericEventChannelSO_1__ctor_mA74BA91BA6D1979DAC4F47F402DFC007C2C45E2F_RuntimeMethod_var);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void FloatEventChannelSO__ctor_m211AB95B885D809AA50723E58B7D7E002A802D74 (FloatEventChannelSO_t3024DD408E0E10E9D724C0752D12BD4E01AF7BAC* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GenericEventChannelSO_1__ctor_mA81A109554A78181BB23114752E3B9BEDB8CF01A_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		GenericEventChannelSO_1__ctor_mA81A109554A78181BB23114752E3B9BEDB8CF01A(__this, GenericEventChannelSO_1__ctor_mA81A109554A78181BB23114752E3B9BEDB8CF01A_RuntimeMethod_var);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void IntEventChannelSO__ctor_m04B7C7AAF0956605405AEE4DC01EC14E2085075B (IntEventChannelSO_t70D68D92C915B0A21096F763ADB17BC18E5F2B0D* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GenericEventChannelSO_1__ctor_mC2FDABB71598996FE8DB22F384677A6ED000DE46_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		GenericEventChannelSO_1__ctor_mC2FDABB71598996FE8DB22F384677A6ED000DE46(__this, GenericEventChannelSO_1__ctor_mC2FDABB71598996FE8DB22F384677A6ED000DE46_RuntimeMethod_var);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void QualityPresetEventChannelSO__ctor_mB44BFC4B19B0ED03CE2817D9300B9FF498FF28F6 (QualityPresetEventChannelSO_tE1C99F5541B59D973E5C3BDEDA3F7D96C0C58CE1* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GenericEventChannelSO_1__ctor_mCC1C0EE91DA2D5F6DD88E51F10405EC6D88AF9BF_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		GenericEventChannelSO_1__ctor_mCC1C0EE91DA2D5F6DD88E51F10405EC6D88AF9BF(__this, GenericEventChannelSO_1__ctor_mCC1C0EE91DA2D5F6DD88E51F10405EC6D88AF9BF_RuntimeMethod_var);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void StringEventChannelSO__ctor_m7BFBD6B4EFDE917BD4B016AFE8EAED91CBCAA41D (StringEventChannelSO_t1B8C059DCA2CBC16BC4FB5F811A657EB888AB994* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&GenericEventChannelSO_1__ctor_mF75F9F4F07B28C70BAC3EF57E4F63759F2C3B3A5_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		GenericEventChannelSO_1__ctor_mF75F9F4F07B28C70BAC3EF57E4F63759F2C3B3A5(__this, GenericEventChannelSO_1__ctor_mF75F9F4F07B28C70BAC3EF57E4F63759F2C3B3A5_RuntimeMethod_var);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t VoidEventChannelSO_get_ListenerCount_mD59212F3DAA6CEE94884788416C0776D23AE41E3 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_0 = __this->____listeners;
		NullCheck(L_0);
		int32_t L_1;
		L_1 = List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_inline(L_0, List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var);
		return L_1;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VoidEventChannelSO_RegisterListener_m458F443B8DA69192DA43FD6181C42142BD942145 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* ___0_listener, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_Add_m5B99D67CB378BFA8A1142343F9DB44D94322EAD3_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_Contains_m181F2DB6756B1ADDCEC909ADA27A8FDDBD18C002_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_0 = ___0_listener;
		if (L_0)
		{
			goto IL_0004;
		}
	}
	{
		return;
	}

IL_0004:
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_1 = __this->____listeners;
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_2 = ___0_listener;
		NullCheck(L_1);
		bool L_3;
		L_3 = List_1_Contains_m181F2DB6756B1ADDCEC909ADA27A8FDDBD18C002(L_1, L_2, List_1_Contains_m181F2DB6756B1ADDCEC909ADA27A8FDDBD18C002_RuntimeMethod_var);
		if (L_3)
		{
			goto IL_001e;
		}
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_4 = __this->____listeners;
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_5 = ___0_listener;
		NullCheck(L_4);
		List_1_Add_m5B99D67CB378BFA8A1142343F9DB44D94322EAD3_inline(L_4, L_5, List_1_Add_m5B99D67CB378BFA8A1142343F9DB44D94322EAD3_RuntimeMethod_var);
	}

IL_001e:
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VoidEventChannelSO_UnregisterListener_m3BAF563A57DD38096E5EDAFBECB42153074A72F4 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* ___0_listener, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_Remove_m2F58C9F48DA11B2DF2D297626E97A25B1050D822_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_0 = ___0_listener;
		if (L_0)
		{
			goto IL_0004;
		}
	}
	{
		return;
	}

IL_0004:
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_1 = __this->____listeners;
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_2 = ___0_listener;
		NullCheck(L_1);
		bool L_3;
		L_3 = List_1_Remove_m2F58C9F48DA11B2DF2D297626E97A25B1050D822(L_1, L_2, List_1_Remove_m2F58C9F48DA11B2DF2D297626E97A25B1050D822_RuntimeMethod_var);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VoidEventChannelSO_Raise_mDD64B346C922626E69A9826E0D33D75804DA3531 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	int32_t V_0 = 0;
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_0 = __this->____listeners;
		NullCheck(L_0);
		int32_t L_1;
		L_1 = List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_inline(L_0, List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var);
		V_0 = ((int32_t)il2cpp_codegen_subtract(L_1, 1));
		goto IL_0041;
	}

IL_0010:
	{
		int32_t L_2 = V_0;
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_3 = __this->____listeners;
		NullCheck(L_3);
		int32_t L_4;
		L_4 = List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_inline(L_3, List_1_get_Count_m5E7FCE3DF7B23B6D88C14A04177C1DCD15063858_RuntimeMethod_var);
		if ((((int32_t)L_2) >= ((int32_t)L_4)))
		{
			goto IL_003d;
		}
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_5 = __this->____listeners;
		int32_t L_6 = V_0;
		NullCheck(L_5);
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_7;
		L_7 = List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D(L_5, L_6, List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D_RuntimeMethod_var);
		if (!L_7)
		{
			goto IL_003d;
		}
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_8 = __this->____listeners;
		int32_t L_9 = V_0;
		NullCheck(L_8);
		Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* L_10;
		L_10 = List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D(L_8, L_9, List_1_get_Item_m8A119323481338039197B73D82916BB46DEE3C2D_RuntimeMethod_var);
		NullCheck(L_10);
		Action_Invoke_m7126A54DACA72B845424072887B5F3A51FC3808E_inline(L_10, NULL);
	}

IL_003d:
	{
		int32_t L_11 = V_0;
		V_0 = ((int32_t)il2cpp_codegen_subtract(L_11, 1));
	}

IL_0041:
	{
		int32_t L_12 = V_0;
		if ((((int32_t)L_12) >= ((int32_t)0)))
		{
			goto IL_0010;
		}
	}
	{
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VoidEventChannelSO_OnDisable_mF5B448D3E76BD9C22A3F966E19A07750C305BCD8 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_Clear_m344AD90676A608EA37B9DF93050BA9F80C23D17E_RuntimeMethod_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_0 = __this->____listeners;
		NullCheck(L_0);
		List_1_Clear_m344AD90676A608EA37B9DF93050BA9F80C23D17E_inline(L_0, List_1_Clear_m344AD90676A608EA37B9DF93050BA9F80C23D17E_RuntimeMethod_var);
		return;
	}
}
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void VoidEventChannelSO__ctor_mBD01BC358115EFDB0DC53D3CB464E9384929E939 (VoidEventChannelSO_t7B8C8B745B4CECD72ED207873592D98E07BE5347* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1__ctor_mEBBE8A30276CDE4C03E41569F6553229F093035E_RuntimeMethod_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&List_1_tDB72209F35D56F62A287633F9450978E90B90987_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		List_1_tDB72209F35D56F62A287633F9450978E90B90987* L_0 = (List_1_tDB72209F35D56F62A287633F9450978E90B90987*)il2cpp_codegen_object_new(List_1_tDB72209F35D56F62A287633F9450978E90B90987_il2cpp_TypeInfo_var);
		List_1__ctor_mEBBE8A30276CDE4C03E41569F6553229F093035E(L_0, 8, List_1__ctor_mEBBE8A30276CDE4C03E41569F6553229F093035E_RuntimeMethod_var);
		__this->____listeners = L_0;
		Il2CppCodeGenWriteBarrier((void**)(&__this->____listeners), (void*)L_0);
		ScriptableObject__ctor_mD037FDB0B487295EA47F79A4DB1BF1846C9087FF(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
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
#ifdef __clang__
#pragma clang diagnostic pop
#endif
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
#ifdef __clang__
#pragma clang diagnostic pop
#endif
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
#ifdef __clang__
#pragma clang diagnostic pop
#endif
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Ray__ctor_mE298992FD10A3894C38373198385F345C58BD64C_inline (Ray_t2B1742D7958DC05BDC3EFC7461D3593E1430DC00* __this, Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_origin, Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___1_direction, const RuntimeMethod* method) 
{
	{
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_0 = ___0_origin;
		__this->___m_Origin = L_0;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_1 = ___1_direction;
		__this->___m_Direction = L_1;
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* L_2 = (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2*)(&__this->___m_Direction);
		Vector3_Normalize_mC749B887A4C74BA0A2E13E6377F17CCAEB0AADA8_inline(L_2, NULL);
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR bool VRStereoCameraRig_get_GlobalIsVrMode_m58848EB9B12A8C4233CCD1A08CA5F4BB35BED018_inline (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		bool L_0 = ((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___U3CGlobalIsVrModeU3Ek__BackingField;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Vector3__ctor_m376936E6B999EF1ECBE57D990A386303E2283DE0_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, float ___0_x, float ___1_y, float ___2_z, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_x;
		__this->___x = L_0;
		float L_1 = ___1_y;
		__this->___y = L_1;
		float L_2 = ___2_z;
		__this->___z = L_2;
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Vector3_get_zero_m0C1249C3F25B1C70EAD3CC8B31259975A457AE39_inline (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_0 = ((Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2_StaticFields*)il2cpp_codegen_static_fields_for(Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2_il2cpp_TypeInfo_var))->___zeroVector;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_get_identity_m7E701AE095ED10FD5EA0B50ABCFDE2EEFF2173A5_inline (const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_0 = ((Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974_StaticFields*)il2cpp_codegen_static_fields_for(Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974_il2cpp_TypeInfo_var))->___identityQuaternion;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_Euler_m9262AB29E3E9CE94EF71051F38A28E82AEC73F90_inline (float ___0_x, float ___1_y, float ___2_z, const RuntimeMethod* method) 
{
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 V_0;
	memset((&V_0), 0, sizeof(V_0));
	{
		il2cpp_codegen_initobj((&V_0), sizeof(Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2));
		float L_0 = ___0_x;
		(&V_0)->___x = ((float)il2cpp_codegen_multiply(L_0, (0.0174532924f)));
		float L_1 = ___1_y;
		(&V_0)->___y = ((float)il2cpp_codegen_multiply(L_1, (0.0174532924f)));
		float L_2 = ___2_z;
		(&V_0)->___z = ((float)il2cpp_codegen_multiply(L_2, (0.0174532924f)));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_3;
		L_3 = Quaternion_Internal_FromEulerRad_mD0C4C0EFE1D70EC0EA4A92B11F1A4D5B0A134E49((&V_0), NULL);
		return L_3;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Repeat_m6F1560A163481BB311D685294E1B463C3E4EB3BA_inline (float ___0_t, float ___1_length, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_t;
		float L_1 = ___0_t;
		float L_2 = ___1_length;
		float L_3;
		L_3 = floorf(((float)(L_1/L_2)));
		float L_4 = ___1_length;
		float L_5 = ___1_length;
		float L_6;
		L_6 = Mathf_Clamp_mEB9AEA827D27D20FCC787F7375156AF46BB12BBF_inline(((float)il2cpp_codegen_subtract(L_0, ((float)il2cpp_codegen_multiply(L_3, L_4)))), (0.0f), L_5, NULL);
		return L_6;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Clamp_mEB9AEA827D27D20FCC787F7375156AF46BB12BBF_inline (float ___0_value, float ___1_min, float ___2_max, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_value;
		float L_1 = ___1_min;
		if ((((float)L_0) < ((float)L_1)))
		{
			goto IL_000c;
		}
	}
	{
		float L_2 = ___0_value;
		float L_3 = ___2_max;
		if ((((float)L_2) > ((float)L_3)))
		{
			goto IL_000a;
		}
	}
	{
		float L_4 = ___0_value;
		return L_4;
	}

IL_000a:
	{
		float L_5 = ___2_max;
		return L_5;
	}

IL_000c:
	{
		float L_6 = ___1_min;
		return L_6;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void VRStereoCameraRig_set_GlobalIsVrMode_m6109AA5B3EE40574B27EFE754C4C41397246BC97_inline (bool ___0_value, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		bool L_0 = ___0_value;
		il2cpp_codegen_runtime_class_init_inline(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var);
		((VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_StaticFields*)il2cpp_codegen_static_fields_for(VRStereoCameraRig_tF036AEFE6BFDE220DB46B63EA9372598F812FF02_il2cpp_TypeInfo_var))->___U3CGlobalIsVrModeU3Ek__BackingField = L_0;
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Quaternion__ctor_m868FD60AA65DD5A8AC0C5DEB0608381A8D85FCD8_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974* __this, float ___0_x, float ___1_y, float ___2_z, float ___3_w, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_x;
		__this->___x = L_0;
		float L_1 = ___1_y;
		__this->___y = L_1;
		float L_2 = ___2_z;
		__this->___z = L_2;
		float L_3 = ___3_w;
		__this->___w = L_3;
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 Quaternion_op_Multiply_mCB375FCCC12A2EC8F9EB824A1BFB4453B58C2012_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___0_lhs, Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 ___1_rhs, const RuntimeMethod* method) 
{
	Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 V_0;
	memset((&V_0), 0, sizeof(V_0));
	{
		il2cpp_codegen_initobj((&V_0), sizeof(Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_0 = ___0_lhs;
		float L_1 = L_0.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_2 = ___1_rhs;
		float L_3 = L_2.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_4 = ___0_lhs;
		float L_5 = L_4.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_6 = ___1_rhs;
		float L_7 = L_6.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_8 = ___0_lhs;
		float L_9 = L_8.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_10 = ___1_rhs;
		float L_11 = L_10.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_12 = ___0_lhs;
		float L_13 = L_12.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_14 = ___1_rhs;
		float L_15 = L_14.___y;
		(&V_0)->___x = ((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_add(((float)il2cpp_codegen_add(((float)il2cpp_codegen_multiply(L_1, L_3)), ((float)il2cpp_codegen_multiply(L_5, L_7)))), ((float)il2cpp_codegen_multiply(L_9, L_11)))), ((float)il2cpp_codegen_multiply(L_13, L_15))));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_16 = ___0_lhs;
		float L_17 = L_16.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_18 = ___1_rhs;
		float L_19 = L_18.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_20 = ___0_lhs;
		float L_21 = L_20.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_22 = ___1_rhs;
		float L_23 = L_22.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_24 = ___0_lhs;
		float L_25 = L_24.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_26 = ___1_rhs;
		float L_27 = L_26.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_28 = ___0_lhs;
		float L_29 = L_28.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_30 = ___1_rhs;
		float L_31 = L_30.___z;
		(&V_0)->___y = ((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_add(((float)il2cpp_codegen_add(((float)il2cpp_codegen_multiply(L_17, L_19)), ((float)il2cpp_codegen_multiply(L_21, L_23)))), ((float)il2cpp_codegen_multiply(L_25, L_27)))), ((float)il2cpp_codegen_multiply(L_29, L_31))));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_32 = ___0_lhs;
		float L_33 = L_32.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_34 = ___1_rhs;
		float L_35 = L_34.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_36 = ___0_lhs;
		float L_37 = L_36.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_38 = ___1_rhs;
		float L_39 = L_38.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_40 = ___0_lhs;
		float L_41 = L_40.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_42 = ___1_rhs;
		float L_43 = L_42.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_44 = ___0_lhs;
		float L_45 = L_44.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_46 = ___1_rhs;
		float L_47 = L_46.___x;
		(&V_0)->___z = ((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_add(((float)il2cpp_codegen_add(((float)il2cpp_codegen_multiply(L_33, L_35)), ((float)il2cpp_codegen_multiply(L_37, L_39)))), ((float)il2cpp_codegen_multiply(L_41, L_43)))), ((float)il2cpp_codegen_multiply(L_45, L_47))));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_48 = ___0_lhs;
		float L_49 = L_48.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_50 = ___1_rhs;
		float L_51 = L_50.___w;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_52 = ___0_lhs;
		float L_53 = L_52.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_54 = ___1_rhs;
		float L_55 = L_54.___x;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_56 = ___0_lhs;
		float L_57 = L_56.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_58 = ___1_rhs;
		float L_59 = L_58.___y;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_60 = ___0_lhs;
		float L_61 = L_60.___z;
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_62 = ___1_rhs;
		float L_63 = L_62.___z;
		(&V_0)->___w = ((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_subtract(((float)il2cpp_codegen_multiply(L_49, L_51)), ((float)il2cpp_codegen_multiply(L_53, L_55)))), ((float)il2cpp_codegen_multiply(L_57, L_59)))), ((float)il2cpp_codegen_multiply(L_61, L_63))));
		Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974 L_64 = V_0;
		return L_64;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Quaternion_get_eulerAngles_m2DB5158B5C3A71FD60FC8A6EE43D3AAA1CFED122_inline (Quaternion_tDA59F214EF07D7700B26E40E562F267AF7306974* __this, const RuntimeMethod* method) 
{
	{
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_0;
		L_0 = Quaternion_Internal_ToEulerRad_mC5BD020889B5A4FB6894CFB69A5D4C07B321B919(__this, NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_1;
		L_1 = Vector3_op_Multiply_m87BA7C578F96C8E49BB07088DAAC4649F83B0353_inline(L_0, (57.2957802f), NULL);
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_2;
		L_2 = Quaternion_Internal_MakePositive_m73E2D01920CB0DFE661A55022C129E8617F0C9A8(L_1, NULL);
		return L_2;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t Touch_get_phase_mB82409FB2BE1C32ABDBA6A72E52A099D28AB70B0_inline (Touch_t03E51455ED508492B3F278903A0114FA0E87B417* __this, const RuntimeMethod* method) 
{
	{
		int32_t L_0 = __this->___m_Phase;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 Touch_get_deltaPosition_m2D51F960B74C94821ED0F6A09E44C80FD796D299_inline (Touch_t03E51455ED508492B3F278903A0114FA0E87B417* __this, const RuntimeMethod* method) 
{
	{
		Vector2_t1FD6F485C871E832B347AB2DC8CBA08B739D8DF7 L_0 = __this->___m_PositionDelta;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_LerpAngle_m0653422E15193C2E4A4E5AF05236B6315C789C23_inline (float ___0_a, float ___1_b, float ___2_t, const RuntimeMethod* method) 
{
	float V_0 = 0.0f;
	{
		float L_0 = ___1_b;
		float L_1 = ___0_a;
		float L_2;
		L_2 = Mathf_Repeat_m6F1560A163481BB311D685294E1B463C3E4EB3BA_inline(((float)il2cpp_codegen_subtract(L_0, L_1)), (360.0f), NULL);
		V_0 = L_2;
		float L_3 = V_0;
		if ((!(((float)L_3) > ((float)(180.0f)))))
		{
			goto IL_001e;
		}
	}
	{
		float L_4 = V_0;
		V_0 = ((float)il2cpp_codegen_subtract(L_4, (360.0f)));
	}

IL_001e:
	{
		float L_5 = ___0_a;
		float L_6 = V_0;
		float L_7 = ___2_t;
		float L_8;
		L_8 = Mathf_Clamp01_mA7E048DBDA832D399A581BE4D6DED9FA44CE0F14_inline(L_7, NULL);
		return ((float)il2cpp_codegen_add(L_5, ((float)il2cpp_codegen_multiply(L_6, L_8))));
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Lerp_m47EF2FFB7647BD0A1FDC26DC03E28B19812139B5_inline (float ___0_a, float ___1_b, float ___2_t, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_a;
		float L_1 = ___1_b;
		float L_2 = ___0_a;
		float L_3 = ___2_t;
		float L_4;
		L_4 = Mathf_Clamp01_mA7E048DBDA832D399A581BE4D6DED9FA44CE0F14_inline(L_3, NULL);
		return ((float)il2cpp_codegen_add(L_0, ((float)il2cpp_codegen_multiply(((float)il2cpp_codegen_subtract(L_1, L_2)), L_4))));
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Rect__ctor_m18C3033D135097BEE424AAA68D91C706D2647F23_inline (Rect_tA04E0F8A1830E767F40FB27ECD8D309303571F0D* __this, float ___0_x, float ___1_y, float ___2_width, float ___3_height, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_x;
		__this->___m_XMin = L_0;
		float L_1 = ___1_y;
		__this->___m_YMin = L_1;
		float L_2 = ___2_width;
		__this->___m_Width = L_2;
		float L_3 = ___3_height;
		__this->___m_Height = L_3;
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Action_Invoke_m7126A54DACA72B845424072887B5F3A51FC3808E_inline (Action_tD00B0A84D7945E50C2DFFC28EFEE6ED44ED2AD07* __this, const RuntimeMethod* method) 
{
	typedef void (*FunctionPointerType) (RuntimeObject*, const RuntimeMethod*);
	((FunctionPointerType)__this->___invoke_impl)((Il2CppObject*)__this->___method_code, reinterpret_cast<RuntimeMethod*>(__this->___method));
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Action_2_Invoke_m6343941059117DF354182855F996EB3D08B4C06C_gshared_inline (Action_2_t1D42C7D8DCD2DEB7C556FB3783F0EDAFF694E5E8* __this, Il2CppFullySharedGenericAny ___0_arg1, Il2CppFullySharedGenericAny ___1_arg2, const RuntimeMethod* method) 
{
	typedef void (*FunctionPointerType) (RuntimeObject*, Il2CppFullySharedGenericAny, Il2CppFullySharedGenericAny, const RuntimeMethod*);
	((FunctionPointerType)__this->___invoke_impl)((Il2CppObject*)__this->___method_code, ___0_arg1, ___1_arg2, reinterpret_cast<RuntimeMethod*>(__this->___method));
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t List_1_get_Count_mD2ED26ACAF3BAF386FFEA83893BA51DB9FD8BA30_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, const RuntimeMethod* method) 
{
	{
		int32_t L_0 = __this->____size;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void List_1_Add_mD4F3498FBD3BDD3F03CBCFB38041CBAC9C28CAFC_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, Il2CppFullySharedGenericAny ___0_item, const RuntimeMethod* method) 
{
	const uint32_t SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E = il2cpp_codegen_sizeof(il2cpp_rgctx_data_no_init(method->klass->rgctx_data, 9));
	const Il2CppFullySharedGenericAny L_8 = alloca(SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E);
	const Il2CppFullySharedGenericAny L_9 = L_8;
	const Il2CppFullySharedGenericAny L_10 = alloca(SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E);
	__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* V_0 = NULL;
	int32_t V_1 = 0;
	{
		int32_t L_0 = __this->____version;
		__this->____version = ((int32_t)il2cpp_codegen_add(L_0, 1));
		__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* L_1 = __this->____items;
		V_0 = L_1;
		int32_t L_2 = __this->____size;
		V_1 = L_2;
		int32_t L_3 = V_1;
		__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* L_4 = V_0;
		NullCheck(L_4);
		if ((!(((uint32_t)L_3) < ((uint32_t)((int32_t)(((RuntimeArray*)L_4)->max_length))))))
		{
			goto IL_0034;
		}
	}
	{
		int32_t L_5 = V_1;
		__this->____size = ((int32_t)il2cpp_codegen_add(L_5, 1));
		__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* L_6 = V_0;
		int32_t L_7 = V_1;
		il2cpp_codegen_memcpy(L_8, (il2cpp_codegen_class_is_value_type(il2cpp_rgctx_data_no_init(method->klass->rgctx_data, 9)) ? ___0_item : &___0_item), SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E);
		NullCheck(L_6);
		il2cpp_codegen_memcpy((L_6)->GetAddressAt(static_cast<il2cpp_array_size_t>(L_7)), L_8, SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E);
		Il2CppCodeGenWriteBarrierForClass(il2cpp_rgctx_data(method->klass->rgctx_data, 9), (void**)(L_6)->GetAddressAt(static_cast<il2cpp_array_size_t>(L_7)), (void*)L_8);
		return;
	}

IL_0034:
	{
		il2cpp_codegen_memcpy(L_9, (il2cpp_codegen_class_is_value_type(il2cpp_rgctx_data_no_init(method->klass->rgctx_data, 9)) ? ___0_item : &___0_item), SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E);
		List_1_AddWithResize_mA6DFDBC2B22D6318212C6989A34784BD8303AF33(__this, (il2cpp_codegen_class_is_value_type(il2cpp_rgctx_data_no_init(method->klass->rgctx_data, 9)) ? il2cpp_codegen_memcpy(L_10, L_9, SizeOf_T_t664E2061A913AF1FEE499655BC64F0FDE10D2A5E): *(void**)L_9), il2cpp_rgctx_method(method->klass->rgctx_data, 14));
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void List_1_Clear_mD615D1BCB2C9DD91DAD86A2F9E5CF1DFFCBF7925_gshared_inline (List_1_tDBA89B0E21BAC58CFBD3C1F76E4668E3B562761A* __this, const RuntimeMethod* method) 
{
	int32_t V_0 = 0;
	{
		int32_t L_0 = __this->____version;
		__this->____version = ((int32_t)il2cpp_codegen_add(L_0, 1));
		bool L_1;
		L_1 = il2cpp_codegen_is_reference_or_contains_references(il2cpp_rgctx_method(method->klass->rgctx_data, 25));
		if (!L_1)
		{
			goto IL_0035;
		}
	}
	{
		int32_t L_2 = __this->____size;
		V_0 = L_2;
		__this->____size = 0;
		int32_t L_3 = V_0;
		if ((((int32_t)L_3) <= ((int32_t)0)))
		{
			goto IL_003c;
		}
	}
	{
		__Il2CppFullySharedGenericTypeU5BU5D_tCAB6D060972DD49223A834B7EEFEB9FE2D003BEC* L_4 = __this->____items;
		int32_t L_5 = V_0;
		Array_Clear_m50BAA3751899858B097D3FF2ED31F284703FE5CB((RuntimeArray*)L_4, 0, L_5, NULL);
		return;
	}

IL_0035:
	{
		__this->____size = 0;
	}

IL_003c:
	{
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR void Vector3_Normalize_mC749B887A4C74BA0A2E13E6377F17CCAEB0AADA8_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, const RuntimeMethod* method) 
{
	float V_0 = 0.0f;
	{
		float L_0;
		L_0 = Vector3_get_magnitude_mF0D6017E90B345F1F52D1CC564C640F1A847AF2D_inline(__this, NULL);
		V_0 = L_0;
		float L_1 = V_0;
		if ((!(((float)L_1) > ((float)(9.99999975E-06f)))))
		{
			goto IL_003a;
		}
	}
	{
		float L_2 = __this->___x;
		float L_3 = V_0;
		__this->___x = ((float)(L_2/L_3));
		float L_4 = __this->___y;
		float L_5 = V_0;
		__this->___y = ((float)(L_4/L_5));
		float L_6 = __this->___z;
		float L_7 = V_0;
		__this->___z = ((float)(L_6/L_7));
		return;
	}

IL_003a:
	{
		__this->___x = (0.0f);
		__this->___y = (0.0f);
		__this->___z = (0.0f);
		return;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 Vector3_op_Multiply_m87BA7C578F96C8E49BB07088DAAC4649F83B0353_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 ___0_a, float ___1_d, const RuntimeMethod* method) 
{
	Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 V_0;
	memset((&V_0), 0, sizeof(V_0));
	{
		il2cpp_codegen_initobj((&V_0), sizeof(Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2));
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_0 = ___0_a;
		float L_1 = L_0.___x;
		float L_2 = ___1_d;
		(&V_0)->___x = ((float)il2cpp_codegen_multiply(L_1, L_2));
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_3 = ___0_a;
		float L_4 = L_3.___y;
		float L_5 = ___1_d;
		(&V_0)->___y = ((float)il2cpp_codegen_multiply(L_4, L_5));
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_6 = ___0_a;
		float L_7 = L_6.___z;
		float L_8 = ___1_d;
		(&V_0)->___z = ((float)il2cpp_codegen_multiply(L_7, L_8));
		Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2 L_9 = V_0;
		return L_9;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Mathf_Clamp01_mA7E048DBDA832D399A581BE4D6DED9FA44CE0F14_inline (float ___0_value, const RuntimeMethod* method) 
{
	{
		float L_0 = ___0_value;
		if ((((float)L_0) < ((float)(0.0f))))
		{
			goto IL_0018;
		}
	}
	{
		float L_1 = ___0_value;
		if ((((float)L_1) > ((float)(1.0f))))
		{
			goto IL_0012;
		}
	}
	{
		float L_2 = ___0_value;
		return L_2;
	}

IL_0012:
	{
		return (1.0f);
	}

IL_0018:
	{
		return (0.0f);
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR float Vector3_get_magnitude_mF0D6017E90B345F1F52D1CC564C640F1A847AF2D_inline (Vector3_t24C512C7B96BBABAD472002D0BA2BDA40A5A80B2* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Math_tEB65DE7CA8B083C412C969C92981C030865486CE_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		float L_0 = __this->___x;
		float L_1 = __this->___x;
		float L_2 = __this->___y;
		float L_3 = __this->___y;
		float L_4 = __this->___z;
		float L_5 = __this->___z;
		il2cpp_codegen_runtime_class_init_inline(Math_tEB65DE7CA8B083C412C969C92981C030865486CE_il2cpp_TypeInfo_var);
		double L_6;
		L_6 = sqrt(((double)((float)il2cpp_codegen_add(((float)il2cpp_codegen_add(((float)il2cpp_codegen_multiply(L_0, L_1)), ((float)il2cpp_codegen_multiply(L_2, L_3)))), ((float)il2cpp_codegen_multiply(L_4, L_5))))));
		return ((float)L_6);
	}
}
