#import <Foundation/Foundation.h>
#import "luaTest.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@implementation luaTest

//#include <iostream> 
//#include <string> 
//using namespace std; 
     
int main(int argc, const char *argv[]) 
{ 
    //Luaʾ������ 
    char *szLua_code = 
        "r = string.gsub(c_Str, c_Mode, c_Tag) u = 3+3"; 
    //Lua���ַ���ģʽ 
    char *szMode = "(%w+)%s*=%s*(%w+)"; 
    //Ҫ�������ַ��� 
    char *szStr = "key1 = value1 key2 = value2"; 
    //Ŀ���ַ���ģʽ 
    char *szTag = "<%1>%2</%1>"; 
  
    lua_State *L = luaL_newstate(); 
    luaL_openlibs(L); 
  
    //��һ�������͸�Lua 
    lua_pushstring(L, szMode); 
    lua_setglobal(L, "c_Mode"); 
    lua_pushstring(L, szTag); 
    lua_setglobal(L, "c_Tag"); 
    lua_pushstring(L, szStr); 
    lua_setglobal(L, "c_Str"); 
  
    //ִ�� 
    bool err = luaL_loadbuffer(L, szLua_code, strlen(szLua_code), 
                "demo") || lua_pcall(L, 0, 0, 0); 
    if(err) 
    { 
        //���������ʾ 
       // NSLog( "Error: %s",lua_tostring(L, -1)); 
        //����ջ�������������Ϣ 
        lua_pop(L, 1); 
    } 
    else 
    { 
        //Luaִ�к�ȡ��ȫ�ֱ�����ֵ 
        lua_getglobal(L, "r"); 
        //cout << "r = " << lua_tostring(L,-1) << endl; 
		NSLog( @" r = %s",lua_tostring(L,-1)); 
        lua_pop(L, 1); 
         
        lua_getglobal(L, "u"); 
        //cout << "u = " << lua_tostring(L,-1) << endl;     
		NSLog( @" u = %s",lua_tostring(L,-1)); 
        lua_pop(L, 1); 
    } 
    lua_close(L); 
    return 0; 
} 

int file() {
// Create new Lua state and load the lua libraries
        lua_State *L = luaL_newstate();//lua_open();
        luaL_openlibs(L);

        // Tell Lua to load & run the file sample_script.lua
        luaL_dofile(L, "sample_script.lua");
        // Push "sum" function to the Lua stack
        lua_getglobal(L, "sum");
        // Checks if top of the Lua stack is a function.
        assert(lua_isfunction(L, -1));

        // Let's push two numbers to the sum function
        int a = 19;
        int b = 1;
        lua_pushnumber(L, a); // push a to the top of the stack
        lua_pushnumber(L, b); // push b to the top of the stack

        // Perform the function call (2 arguments, 1 result) */
        if (lua_pcall(L, 2, 1, 0) != 0) {
            printf("error running function `f': %s", lua_tostring(L, -1));
        }

        // Let's retrieve the function result
        // Check if the top of the Lua Stack has a numeric value
        if (!lua_isnumber(L, -1)) { 
            printf( "function `sum' must return a number");
        }

        double c = lua_tonumber(L, -1); // retrieve the result
        lua_pop(L, 1); // Pop retrieved value from the Lua stack
        printf("The number returned by sum is %f\n", c);

        // Close the Lua state
        lua_close(L);
        return 0;
    }



	/*  test.lua
		sin = mysin(5)
		print(sin)
	*/
    // Function that we will expose to lua
    static int l_sin (lua_State *L) {
        // check if the argument is a number
        double d = luaL_checknumber(L, 1); 
        lua_pushnumber(L, sin(d)); // Push the result
        return 1;  // number of results
    }

    int callCFromLua() {
        // Create new Lua state and load the lua libraries
        lua_State *L = luaL_newstate();// lua_open();
        luaL_openlibs(L);

        // Expose the mysin function to the lua environment
        lua_pushcfunction(L, l_sin);
        lua_setglobal(L, "mysin");

        // Tell Lua to load and run the file sample_script.lua
        luaL_dofile(L, "test.lua");
        return 0;
    }


@end