#ifndef NOCOMPAT
/*qc2rust::define::COMPAT_NO_MOD_IS_XONOTIC*/
#define COMPAT_NO_MOD_IS_XONOTIC /*qc2rust::macro_begin::COMPAT_NO_MOD_IS_XONOTIC*/ /*qc2rust::macro_end::COMPAT_NO_MOD_IS_XONOTIC*/
#endif

#ifdef CSQC
/*qc2rust::define::IS_CSQC*/
#define IS_CSQC /*qc2rust::macro_begin::IS_CSQC*/1 /*qc2rust::macro_end::IS_CSQC*/
#else
/*qc2rust::define::IS_CSQC*/
#define IS_CSQC /*qc2rust::macro_begin::IS_CSQC*/0 /*qc2rust::macro_end::IS_CSQC*/
#endif

#ifdef SVQC
/*qc2rust::define::IS_SVQC*/
#define IS_SVQC /*qc2rust::macro_begin::IS_SVQC*/1 /*qc2rust::macro_end::IS_SVQC*/
#else
/*qc2rust::define::IS_SVQC*/
#define IS_SVQC /*qc2rust::macro_begin::IS_SVQC*/0 /*qc2rust::macro_end::IS_SVQC*/
#endif

#include "compiler.qh"

#ifndef QCC_SUPPORT_INT
/*qc2rust::define::int*/
#define int /*qc2rust::macro_begin::int*/float /*qc2rust::macro_end::int*/
#endif

#ifndef QCC_SUPPORT_BOOL
/*qc2rust::define::bool*/
#define bool /*qc2rust::macro_begin::bool*/float /*qc2rust::macro_end::bool*/
#endif

#ifndef QCC_SUPPORT_ACCUMULATE
	#warning "QCC does not support accumulate, may not compile correctly"
/*qc2rust::define::ACCUMULATE*/
#define ACCUMULATE /*qc2rust::macro_begin::ACCUMULATE*/ /*qc2rust::macro_end::ACCUMULATE*/
#else
/*qc2rust::define::ACCUMULATE*/
#define ACCUMULATE /*qc2rust::macro_begin::ACCUMULATE*/[[accumulate]] /*qc2rust::macro_end::ACCUMULATE*/
#endif

#ifndef QCC_SUPPORT_ERASEABLE
/*qc2rust::define::ERASEABLE*/
#define ERASEABLE /*qc2rust::macro_begin::ERASEABLE*/ /*qc2rust::macro_end::ERASEABLE*/
#else
/*qc2rust::define::ERASEABLE*/
#define ERASEABLE /*qc2rust::macro_begin::ERASEABLE*/[[eraseable]] /*qc2rust::macro_end::ERASEABLE*/
#endif

#ifndef QCC_SUPPORT_ALIAS
    #warning "QCC does not support alias, may not compile correctly"
/*qc2rust::define::ALIAS*/
#define ALIAS(var) /*qc2rust::macro_begin::ALIAS*/ /*qc2rust::macro_end::ALIAS*/
#else
/*qc2rust::define::ALIAS*/
#define ALIAS(var) /*qc2rust::macro_begin::ALIAS*/[[alias( /*qc2rust::param_begin::var*/var /*qc2rust::param_end::var*/)]] /*qc2rust::macro_end::ALIAS*/
#endif

#include <dpdefs/pre.qh>

#if defined(CSQC)
	#include <dpdefs/csprogsdefs.qh>
	#include <dpdefs/keycodes.qh>
#elif defined(SVQC)
	#include <server/sys-pre.qh>
	#include <dpdefs/progsdefs.qh>
	#include <dpdefs/dpextensions.qh>
	#include <server/sys-post.qh>
#elif defined(MENUQC)
	#include <dpdefs/menudefs.qh>
	#include <dpdefs/keycodes.qh>
#endif

#include <dpdefs/post.qh>

#ifndef QCC_SUPPORT_POW
/*qc2rust::define::pow*/
#define pow(a,b) /*qc2rust::macro_begin::pow*/pow( /*qc2rust::param_begin::a*/a /*qc2rust::param_end::a*/,  /*qc2rust::param_begin::b*/b /*qc2rust::param_end::b*/) /*qc2rust::macro_end::pow*/
#else
/*qc2rust::define::pow*/
#define pow(a,b) /*qc2rust::macro_begin::pow*/(( /*qc2rust::param_begin::a*/a /*qc2rust::param_end::a*/) ** ( /*qc2rust::param_begin::b*/b /*qc2rust::param_end::b*/)) /*qc2rust::macro_end::pow*/
#endif

#include "self.qh"

/*qc2rust::define::USING*/
#define USING(name,T) /*qc2rust::macro_begin::USING*/typedef  /*qc2rust::param_begin::T*/T /*qc2rust::param_end::T*/  /*qc2rust::param_begin::name*/name /*qc2rust::param_end::name*/ /*qc2rust::macro_end::USING*/

#include "bool.qh"
#include "int.qh"

#include "macro.qh"

#if NDEBUG
/*qc2rust::define::TC*/
#define TC(T,sym) /*qc2rust::macro_begin::TC*/MACRO_BEGIN MACRO_END /*qc2rust::macro_end::TC*/
#else
	#define TC(T, sym) MACRO_BEGIN 		if (!is_##T(sym)) { 			LOG_WARNF("Type check failed: " #sym " :: " #T); 			isnt_##T(sym); 		} 	MACRO_END
#endif

#if !(NDEBUG)
/*qc2rust::define::is_float*/
#define is_float(this) /*qc2rust::macro_begin::is_float*/(true || ftoe( /*qc2rust::param_begin::this*/this /*qc2rust::param_end::this*/)) /*qc2rust::macro_end::is_float*/
/*qc2rust::define::isnt_float*/
#define isnt_float(this) /*qc2rust::macro_begin::isnt_float*/ /*qc2rust::macro_end::isnt_float*/
/*qc2rust::define::is_vector*/
#define is_vector(this) /*qc2rust::macro_begin::is_vector*/(true || vtos( /*qc2rust::param_begin::this*/this /*qc2rust::param_end::this*/)) /*qc2rust::macro_end::is_vector*/
/*qc2rust::define::isnt_vector*/
#define isnt_vector(this) /*qc2rust::macro_begin::isnt_vector*/ /*qc2rust::macro_end::isnt_vector*/
/*qc2rust::define::is_string*/
#define is_string(this) /*qc2rust::macro_begin::is_string*/(true || stof( /*qc2rust::param_begin::this*/this /*qc2rust::param_end::this*/)) /*qc2rust::macro_end::is_string*/
/*qc2rust::define::isnt_string*/
#define isnt_string(this) /*qc2rust::macro_begin::isnt_string*/ /*qc2rust::macro_end::isnt_string*/
/*qc2rust::define::is_entity*/
#define is_entity(this) /*qc2rust::macro_begin::is_entity*/(true || etof( /*qc2rust::param_begin::this*/this /*qc2rust::param_end::this*/)) /*qc2rust::macro_end::is_entity*/
/*qc2rust::define::isnt_entity*/
#define isnt_entity(this) /*qc2rust::macro_begin::isnt_entity*/ /*qc2rust::macro_end::isnt_entity*/
	bool      is_int(float this) { return this == floor(this); }
	void    isnt_int(float this) { print(ftos(this)); }
	bool      is_bool(float this) { return this == true || this == false; }
	void    isnt_bool(float this) { print(ftos(this)); }
#endif

#include "warpzone/mathlib.qc"

#include "accumulate.qh"
#include "angle.qc"
#include "arraylist.qh"
#include "bits.qh"
#include "color.qh"
#include "counting.qh"
#include "cvar.qh"
#include "defer.qh"
#include "draw.qh"
#include "enumclass.qh"
#include "file.qh"
#include "functional.qh"
#include "i18n.qh"
#include "intrusivelist.qh"
#include "iter.qh"
#include "json.qc"
#include "lazy.qh"
#include "linkedlist.qh"
#include "log.qh"
#include "map.qh"
#include "markdown.qh"
#include "math.qh"
#include "misc.qh"
#include "net.qh"
#include "nil.qh"
#include "noise.qh"
#include "oo.qh"
#include "p2mathlib.qc"
#include "progname.qh"
#include "promise.qc"
#include "random.qc"
#include "registry.qh"
#include "registry_net.qh"
#include "replicate.qh"
#include "sortlist.qc"
#include "sort.qh"
#include "spawnfunc.qh"
#include "static.qh"
#include "stats.qh"
#include "string.qh"
#include "struct.qh"
#include "test.qc"
#include "unsafe.qh"
#include "urllib.qc"
#include "vector.qh"
#include "yenc.qh"

#if XONOTIC
	#include "matrix/_mod.inc"
#endif

#ifndef SVQC
/*qc2rust::define::objerror_safe*/
#define objerror_safe(e) /*qc2rust::macro_begin::objerror_safe*/ /*qc2rust::macro_end::objerror_safe*/
#else
void make_safe_for_remove(entity this);
/*qc2rust::define::objerror_safe*/
#define objerror_safe(e) /*qc2rust::macro_begin::objerror_safe*/make_safe_for_remove( /*qc2rust::param_begin::e*/e /*qc2rust::param_end::e*/) /*qc2rust::macro_end::objerror_safe*/
#endif

/*qc2rust::define::objerror*/
#define objerror(this,msg) /*qc2rust::macro_begin::objerror*/MACRO_BEGIN 	LOG_WARN("======OBJECT ERROR======"); 	entity _e = ( /*qc2rust::param_begin::this*/this /*qc2rust::param_end::this*/); 	eprint(_e); 	objerror_safe(_e); 	delete(_e); 	LOG_WARNF("%s OBJECT ERROR in %s:\n%s\nTip: read above for entity information", PROGNAME, __FUNC__,  /*qc2rust::param_begin::msg*/msg /*qc2rust::param_end::msg*/); MACRO_END /*qc2rust::macro_end::objerror*/

#ifdef MENUQC
	void _m_init();
	void m_init() { if (_m_init) _m_init(); }
/*qc2rust::define::m_init*/
#define m_init /*qc2rust::macro_begin::m_init*/_m_init /*qc2rust::macro_end::m_init*/

	void _m_shutdown();
	void m_shutdown() { if (_m_shutdown) _m_shutdown(); }
/*qc2rust::define::m_shutdown*/
#define m_shutdown /*qc2rust::macro_begin::m_shutdown*/_m_shutdown /*qc2rust::macro_end::m_shutdown*/

	void _m_draw(float width, float height);
	void m_draw(float width, float height) { if (_m_draw) _m_draw(width, height); }
/*qc2rust::define::m_draw*/
#define m_draw /*qc2rust::macro_begin::m_draw*/_m_draw /*qc2rust::macro_end::m_draw*/

	void _m_keydown(int keynr, int ascii);
	void m_keydown(int keynr, int ascii) { if (_m_keydown) _m_keydown(keynr, ascii); }
/*qc2rust::define::m_keydown*/
#define m_keydown /*qc2rust::macro_begin::m_keydown*/_m_keydown /*qc2rust::macro_end::m_keydown*/

	void _m_toggle(int mode);
	void m_toggle(int mode) { if (_m_toggle) _m_toggle(mode); }
/*qc2rust::define::m_toggle*/
#define m_toggle /*qc2rust::macro_begin::m_toggle*/_m_toggle /*qc2rust::macro_end::m_toggle*/
#endif

#ifdef SVQC
	void _main();
	void main() { if (_main) _main(); }
/*qc2rust::define::main*/
#define main /*qc2rust::macro_begin::main*/_main /*qc2rust::macro_end::main*/

	void _SV_Shutdown();
	void SV_Shutdown() { if (_SV_Shutdown) _SV_Shutdown(); }
/*qc2rust::define::SV_Shutdown*/
#define SV_Shutdown /*qc2rust::macro_begin::SV_Shutdown*/_SV_Shutdown /*qc2rust::macro_end::SV_Shutdown*/

	void _StartFrame();
	bool _StartFrame_init;
	void spawnfunc_worldspawn(entity);
	void StartFrame() {
		if (!_StartFrame_init) {
			_StartFrame_init = true;
			float oldtime = time; time = 1;
			__spawnfunc_expecting = 2; NULL.__spawnfunc_constructor(NULL);
			time = oldtime;
        }
        if (_StartFrame) _StartFrame();
	}
/*qc2rust::define::StartFrame*/
#define StartFrame /*qc2rust::macro_begin::StartFrame*/_StartFrame /*qc2rust::macro_end::StartFrame*/

	void _SetNewParms();
	void SetNewParms() { if (_SetNewParms) _SetNewParms(); }
/*qc2rust::define::SetNewParms*/
#define SetNewParms /*qc2rust::macro_begin::SetNewParms*/_SetNewParms /*qc2rust::macro_end::SetNewParms*/

	void _SetChangeParms(entity this);
	void SetChangeParms() { ENGINE_EVENT(); if (_SetChangeParms) _SetChangeParms(this); }
/*qc2rust::define::SetChangeParms*/
#define SetChangeParms /*qc2rust::macro_begin::SetChangeParms*/_SetChangeParms /*qc2rust::macro_end::SetChangeParms*/

#ifdef DP_EXT_PRECONNECT
	void _ClientPreConnect(entity this);
	void ClientPreConnect() { ENGINE_EVENT(); if (_ClientPreConnect) _ClientPreConnect(this); }
/*qc2rust::define::ClientPreConnect*/
#define ClientPreConnect /*qc2rust::macro_begin::ClientPreConnect*/_ClientPreConnect /*qc2rust::macro_end::ClientPreConnect*/
#endif

	void _ClientConnect(entity this);
	void ClientConnect() { ENGINE_EVENT(); if (_ClientConnect) _ClientConnect(this); }
/*qc2rust::define::ClientConnect*/
#define ClientConnect /*qc2rust::macro_begin::ClientConnect*/_ClientConnect /*qc2rust::macro_end::ClientConnect*/

	void _ClientDisconnect(entity this);
	void ClientDisconnect() { ENGINE_EVENT(); if (_ClientDisconnect) _ClientDisconnect(this); }
/*qc2rust::define::ClientDisconnect*/
#define ClientDisconnect /*qc2rust::macro_begin::ClientDisconnect*/_ClientDisconnect /*qc2rust::macro_end::ClientDisconnect*/

	void _PutClientInServer(entity this);
	void PutClientInServer() { ENGINE_EVENT(); if (_PutClientInServer) _PutClientInServer(this); }
/*qc2rust::define::PutClientInServer*/
#define PutClientInServer /*qc2rust::macro_begin::PutClientInServer*/_PutClientInServer /*qc2rust::macro_end::PutClientInServer*/

	void _ClientKill(entity this);
	void ClientKill() { ENGINE_EVENT(); if (_ClientKill) _ClientKill(this); }
/*qc2rust::define::ClientKill*/
#define ClientKill /*qc2rust::macro_begin::ClientKill*/_ClientKill /*qc2rust::macro_end::ClientKill*/

	void _PlayerPreThink(entity this);
	void PlayerPreThink() { ENGINE_EVENT(); if (_PlayerPreThink) _PlayerPreThink(this); }
/*qc2rust::define::PlayerPreThink*/
#define PlayerPreThink /*qc2rust::macro_begin::PlayerPreThink*/_PlayerPreThink /*qc2rust::macro_end::PlayerPreThink*/

	void _PlayerPostThink(entity this);
	void PlayerPostThink() { ENGINE_EVENT(); if (_PlayerPostThink) _PlayerPostThink(this); }
/*qc2rust::define::PlayerPostThink*/
#define PlayerPostThink /*qc2rust::macro_begin::PlayerPostThink*/_PlayerPostThink /*qc2rust::macro_end::PlayerPostThink*/

	void _SV_PlayerPhysics(entity this);
	void SV_PlayerPhysics() { ENGINE_EVENT(); if (_SV_PlayerPhysics) _SV_PlayerPhysics(this); }
/*qc2rust::define::SV_PlayerPhysics*/
#define SV_PlayerPhysics /*qc2rust::macro_begin::SV_PlayerPhysics*/_SV_PlayerPhysics /*qc2rust::macro_end::SV_PlayerPhysics*/

	void _SV_OnEntityPreSpawnFunction(entity this);
	void SV_OnEntityPreSpawnFunction()
	{
		ENGINE_EVENT();
		__spawnfunc_expecting = true;
		__spawnfunc_expect = this;
	}
/*qc2rust::define::SV_OnEntityPreSpawnFunction*/
#define SV_OnEntityPreSpawnFunction /*qc2rust::macro_begin::SV_OnEntityPreSpawnFunction*/_SV_OnEntityPreSpawnFunction /*qc2rust::macro_end::SV_OnEntityPreSpawnFunction*/

	void _SV_ChangeTeam(entity this, int _color);
	void SV_ChangeTeam(int _color) { ENGINE_EVENT(); if (_SV_ChangeTeam) _SV_ChangeTeam(this, _color); }
/*qc2rust::define::SV_ChangeTeam*/
#define SV_ChangeTeam /*qc2rust::macro_begin::SV_ChangeTeam*/_SV_ChangeTeam /*qc2rust::macro_end::SV_ChangeTeam*/

	void _SV_ParseClientCommand(entity this, string command);
	void SV_ParseClientCommand(string command)
	{
		ENGINE_EVENT();
		if (_SV_ParseClientCommand) _SV_ParseClientCommand(this, command);
	}
/*qc2rust::define::SV_ParseClientCommand*/
#define SV_ParseClientCommand /*qc2rust::macro_begin::SV_ParseClientCommand*/_SV_ParseClientCommand /*qc2rust::macro_end::SV_ParseClientCommand*/
#endif

#ifdef CSQC
	void _CSQC_Init();
	void CSQC_Init() { if (_CSQC_Init) _CSQC_Init(); }
/*qc2rust::define::CSQC_Init*/
#define CSQC_Init /*qc2rust::macro_begin::CSQC_Init*/_CSQC_Init /*qc2rust::macro_end::CSQC_Init*/

	void _CSQC_Shutdown();
	void CSQC_Shutdown() { if (_CSQC_Shutdown) _CSQC_Shutdown(); }
/*qc2rust::define::CSQC_Shutdown*/
#define CSQC_Shutdown /*qc2rust::macro_begin::CSQC_Shutdown*/_CSQC_Shutdown /*qc2rust::macro_end::CSQC_Shutdown*/

	void _CSQC_UpdateView(entity this, float w, float h);
	void CSQC_UpdateView(float w, float h) { ENGINE_EVENT(); if (_CSQC_UpdateView) _CSQC_UpdateView(this, w, h); }
/*qc2rust::define::CSQC_UpdateView*/
#define CSQC_UpdateView /*qc2rust::macro_begin::CSQC_UpdateView*/_CSQC_UpdateView /*qc2rust::macro_end::CSQC_UpdateView*/

	bool _CSQC_InputEvent(int inputType, float nPrimary, float nSecondary);
	bool CSQC_InputEvent(int inputType, float nPrimary, float nSecondary)
	{
		return _CSQC_InputEvent ? _CSQC_InputEvent(inputType, nPrimary, nSecondary) : false;
	}
/*qc2rust::define::CSQC_InputEvent*/
#define CSQC_InputEvent /*qc2rust::macro_begin::CSQC_InputEvent*/_CSQC_InputEvent /*qc2rust::macro_end::CSQC_InputEvent*/

	bool _CSQC_ConsoleCommand(string s);
	bool CSQC_ConsoleCommand(string s) { return _CSQC_ConsoleCommand ? _CSQC_ConsoleCommand(s) : false; }
/*qc2rust::define::CSQC_ConsoleCommand*/
#define CSQC_ConsoleCommand /*qc2rust::macro_begin::CSQC_ConsoleCommand*/_CSQC_ConsoleCommand /*qc2rust::macro_end::CSQC_ConsoleCommand*/

	void _CSQC_Ent_Update(entity this, bool isNew);
	void CSQC_Ent_Update(bool isNew) { ENGINE_EVENT(); if (_CSQC_Ent_Update) _CSQC_Ent_Update(this, isNew); }
/*qc2rust::define::CSQC_Ent_Update*/
#define CSQC_Ent_Update /*qc2rust::macro_begin::CSQC_Ent_Update*/_CSQC_Ent_Update /*qc2rust::macro_end::CSQC_Ent_Update*/

	void _CSQC_Ent_Remove(entity this);
	void CSQC_Ent_Remove() { ENGINE_EVENT(); if (_CSQC_Ent_Remove) _CSQC_Ent_Remove(this); }
/*qc2rust::define::CSQC_Ent_Remove*/
#define CSQC_Ent_Remove /*qc2rust::macro_begin::CSQC_Ent_Remove*/_CSQC_Ent_Remove /*qc2rust::macro_end::CSQC_Ent_Remove*/
#endif
#undef ENGINE_EVENT

#if XONOTIC
#ifdef GAMEQC
	#include <ecs/_mod.qh>
#endif
#endif
