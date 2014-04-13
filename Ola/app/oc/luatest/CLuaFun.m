#import <Foundation/Foundation.h>
#import <lua.h>
#import <lualib.h>
#import <lauxlib.h>
#import "CLuaFun.h"



@implementation CLuaFun
@synthesize name;

 lua_State* m_pState;   //�����Lua��State����ָ�룬�����һ��lua�ļ���Ӧһ����   

- (CLuaFun *) Init
{  
	[super init];
        if(NULL == m_pState)  
        {  
                m_pState = luaL_newstate();//lua_open();  
                luaL_openlibs(m_pState);  
				[self pushJavaClass:m_pState];
        }  
	self.name=@"name";
			return self;

} 
- (void)dealloc {
	if(NULL != m_pState)  
        {  
                lua_close(m_pState);  
		[m_pState release];
        }
    [super dealloc];
}

- (void) Close  
{  
        if(NULL != m_pState)  
        {  
                lua_close(m_pState);  
                m_pState = NULL;  
        }  
}  



- (bool)  LoadLuaFile: (char *) pFileName
  
{  
  
        int nRet = 0;  
  
        if(NULL == m_pState)  
  
        {  
  
                printf("[ LoadLuaFile]m_pState is NULL./n");  
  
                return false;  
  
        }  
  
  
  
        nRet = luaL_dofile(m_pState, pFileName);  
  
        if (nRet != 0)  
  
        {  
  
                printf("[ LoadLuaFile]luaL_loadfile(%s) is file(%d)(%s)./n", pFileName, nRet, lua_tostring(m_pState, -1));  
  
                return false;  
  
        }  
  
  
  
        return true;  
  
} 

- (bool) CallFileFn: (char *) pFunctionName nParam1:(int) nParam1  nParam2:(int) nParam2
  
{  
  
        int nRet = 0;  
  
        if(NULL == m_pState)  
  
        {  
  
                printf("[CallFileFn]m_pState is NULL./n");  
  
                return false;  
  
        }  
  
  
  
        lua_getglobal(m_pState, pFunctionName);  
  
  
  
        lua_pushnumber(m_pState, nParam1);  
  
        lua_pushnumber(m_pState, nParam2);  
  
  
  
        nRet = lua_pcall(m_pState, 2, 1, 0);  
  
        if (nRet != 0)  
  
        {  
  
                printf("[CallFileFn]call function(%s) error(%d).\n", pFunctionName, nRet);  
  
                return false;  
  
        }  
  
  
  
        if (lua_isnumber(m_pState, -1) == 1)  
  
        {  
  
                int nSum = lua_tonumber(m_pState, -1);  
  
                printf("[CallFileFn]Sum = %d.\n", nSum);  
  
        }  
  
  
  
        return true;  
  
}  
+ (int) CreateCTest:(lua_State*) L
{    // ����һ��Ԫ��ΪCTest��Table����Lua����  
	 CLuaFun** pData = (CLuaFun**)lua_newuserdata(L, sizeof(CLuaFun*));   
	 *pData = (CLuaFun *)[[CLuaFun alloc] init];
	luaL_getmetatable(L, "CLuaFun");  
	lua_setmetatable(L, -2);    
	return 1;
}

- (int) CallAdd:(lua_State*) L
{  
    //����C++�෽�������庯��,�˴���ʵ�и�����   
    //lua_topointer���ص���ʵ��CTest**�����ڴ˴����漰��   
    //������ݳ�Ա����,����ν�Ҿ�û�и���   
    //CLuaFun* pT = (CLuaFun*)lua_topointer(L,1);  
	//NSString * msg=[[NSString alloc] initWithCString:lua_tostring(L,2)];
    //lua_pushnumber(L, [pT d:msg]);  
	NSLog(@"call add");
    return 1;  
} 

- (int) pushJavaClass:(lua_State *) L  
{
   // ����һ��Ԫ��ΪCTest��Table����Lua����
    //CLuaFun *test=(CLuaFun *)[[CLuaFun alloc] init];
   // lua_newuserdata(L, sizeof(test));


	// CLuaFun** pData = (CLuaFun**)lua_newuserdata(L, sizeof(CLuaFun*));   
	// *pData = (CLuaFun *)[[CLuaFun alloc] init];

	NSLog(@"[CLuaFun]size = %d.\n", sizeof( self) ); 
     CLuaFun ** userData = ( CLuaFun ** ) lua_newuserdata( L , sizeof( [CLuaFun class]) );
    *userData = (CLuaFun *)[[CLuaFun alloc] init];

    luaL_getmetatable(L, "CLuaFun");
    lua_setmetatable(L, -2);





	//void* return_class_userdata = lua_newuserdata(lua_state, sizeof(LuaUserDataContainerForObject));
	//LuaUserDataContainerForObject* lua_class_container = (LuaUserDataContainerForObject*)return_class_userdata;



   //lua_pushlightuserdata(L,     *userData); 
    
    lua_newtable( L );          // ����һ��Ԫ��
	lua_setuservalue(L, -2);

	/*
    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);                           // ע����һ�䣬��ʵ�ǽ�__index���ó�Ԫ���Լ�
    lua_settable(L, -3);

    lua_pushstring(L, "__gc");                    // ��������
    lua_pushcfunction(L, [self Close]);
    lua_settable(L, -3);                               // �����������õ�ʵ�־��ڴ˰�

*/

	//��Ԫ�������Ӻ���,�������л��ڸ�Ԫ�ص�Table����Add������   
   //lua_pushstring(L,"Add");  
   //lua_pushcfunction(L,[self CallAdd]);  
  // lua_settable(L,-3);

	//lua_pushlightuserdata(L, *userData);
	//lua_pushvalue(L, -2);
	//lua_settable(L, -3);

	// lua_setglobal( L , "CLuaFun" );
	// lua_pop(L,1);
    lua_setglobal(L,  "CLuaFun");


   return 1;
}
-(int) d:(char *)message
{
	NSLog([[NSString alloc] initWithCString:message]);
	return 1;
}
int lua_objc_methodlookup(lua_State* state){
#ifdef LUA_OBJC_EACH_LUA_TYPE_HAS_METATABLE
	if(lua_istable(state,-2)){
		lua_pushvalue(state,-1);
		lua_rawget(state,-3);
		if(!lua_isnil(state,-1)){
			return 1;
			}
		else{
			lua_pop(state,1);
			}
		}
	lua_pushvalue(state,-1);
	lua_pushcclosure(state,&lua_objc_methodcall,1);
#else
	lua_pushvalue(state,-1);
	lua_rawget(state,-3);
	if(lua_isnil(state,-1)){
		lua_pop(state,1);
		lua_pushvalue(state,-1);
		lua_pushcclosure(state,&lua_objc_methodcall,1);
		}
#endif
	return 1;
	}

void lua_objc_configuremetatable(lua_State* state, int stack_index,int hook_gc_events){
	if(stack_index<0){
		stack_index=lua_gettop(state)+(stack_index+1);
		}
		
	if(lua_getmetatable(state,stack_index)){
		int metatable=lua_gettop(state);
		
		//
		// Set hook to intercept method calls ("index events")
		//

		lua_pushstring(state,"__index");
		lua_pushcfunction(state,&lua_objc_methodlookup);
		lua_settable(state,metatable);
		
		//
		// Set hook to intercept garbage collection events
		//
		
#ifdef LUA_OBJC_RETAIN_AND_RELEASE_INSTANCES
		if(hook_gc_events){
			lua_pushstring(state,"__gc");
			lua_pushcfunction(state,&lua_objc_release);
			lua_settable(state,metatable);
			}
#endif		
		lua_pop(state,1);
		}
	}

void lua_objc_setid(lua_State* state,int stack_index,id object){
	if(stack_index<0){
		stack_index=lua_gettop(state)+(stack_index+1);
		}
	
	//
	// Get the metatable for this value; create if required
	//
	
	int metatable=0;
	if(!lua_getmetatable(state,stack_index)){
		lua_newtable(state);
		lua_setmetatable(state,stack_index);
		lua_objc_configuremetatable(state,stack_index,[object respondsToSelector:@selector(retain)]);
		lua_getmetatable(state,stack_index);
		}
	metatable=lua_gettop(state);	
		
#ifdef LUA_OBJC_RETAIN_AND_RELEASE_INSTANCES
	if([object respondsToSelector:@selector(retain)]){
		[object retain];
		}
#endif

	//
	// Store a reference to the id in the metatable
	//		

#ifdef LUA_OBJC_EACH_LUA_TYPE_HAS_METATABLE
	if((lua_istable(state,stack_index))||(lua_isuserdata(state,stack_index))){
#else
	if(lua_istable(state,stack_index)){
#endif
		lua_pushstring(state,LUA_OBJC_OBJECT_STORAGE_NAME);
		lua_pushlightuserdata(state,object);
		lua_settable(state,metatable);
		}
#ifdef LUA_OBJC_EACH_LUA_TYPE_HAS_METATABLE
	else if(!lua_isnil(state,stack_index)){
	
		//
		// This type has a shared metatable - we have to store the id globally
		//
		
		lua_pushstring(state,LUA_OBJC_LIBRARY_NAME);
		lua_gettable(state,LUA_GLOBALSINDEX);
		int globals=lua_gettop(state);
		lua_pushstring(state,LUA_OBJC_GLOBAL_OBJECT_STORAGE_NAME);
		lua_gettable(state,globals);
		
		//
		// Create a global private table for storage, if required.
		//
		// To avoid interfering with the mechanism linking Lua's garbage
		// collection with ObjC's retain/release system, we use a Lua table to
		// do this.
		//
		
		if(lua_isnil(state,-1)){
			lua_pop(state,1);
			
			lua_pushstring(state,LUA_OBJC_GLOBAL_OBJECT_STORAGE_NAME);
			lua_newtable(state);
			lua_settable(state,globals);
			
			lua_pushstring(state,LUA_OBJC_GLOBAL_OBJECT_STORAGE_NAME);
			lua_gettable(state,globals);
			}
		int ids=lua_gettop(state);
			
		//
		// Store the id in our global private table
		//
			
		lua_pushlightuserdata(state,lua_objc_topointer(state,stack_index));
		lua_pushlightuserdata(state,object);
		lua_settable(state,ids);
			
		lua_pop(state,1);
		lua_pop(state,1);
		}
#endif
	lua_pop(state,1);
	}


int main(int argc, const char *argv[]) 
  
{  
  
        CLuaFun *LuaFn=[[CLuaFun alloc] Init];  
  
  
  
        //LuaFn.InitClass();   
  
  
  
        [LuaFn LoadLuaFile:"testLua.lua"];  
  
        [LuaFn CallFileFn:"func_Add" nParam1:11  nParam2:12];  
  
        getchar();  
  
  
  
        return 0;  
  
}  

@end