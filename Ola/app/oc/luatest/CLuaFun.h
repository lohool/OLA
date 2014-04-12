#import <Foundation/Foundation.h>
#import <lua.h>
#import <lualib.h>
#import <lauxlib.h>
extern void lua_objc_setid(lua_State* state,int stack_index,id object);
#define LUA_OBJC_OBJECT_STORAGE_NAME "__lua_objc_id"
extern void lua_objc_configuremetatable(lua_State* state, int stack_index,int hook_gc_events);
  
@interface CLuaFun : NSObject {
   NSString  *name;

}
@property (nonatomic, retain) NSString  *name;

        - (CLuaFun *) Init;            //初始化Lua对象指针参数   
        - (void) Close;         //关闭Lua对象指针   
  
        - (bool) LoadLuaFile: (char *) pFileName;                              //加载指定的Lua文件   
        - (bool) CallFileFn:(char *) pFunctionName  nParam1: (int) nParam1  nParam2:(int) nParam2;        //执行指定Lua文件中的函数   
-(int) d:(char *)message;
- (int) CreateCTest:(lua_State*) L;

@end


