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

        - (CLuaFun *) Init;            //��ʼ��Lua����ָ�����   
        - (void) Close;         //�ر�Lua����ָ��   
  
        - (bool) LoadLuaFile: (char *) pFileName;                              //����ָ����Lua�ļ�   
        - (bool) CallFileFn:(char *) pFunctionName  nParam1: (int) nParam1  nParam2:(int) nParam2;        //ִ��ָ��Lua�ļ��еĺ���   
-(int) d:(char *)message;
- (int) CreateCTest:(lua_State*) L;

@end

