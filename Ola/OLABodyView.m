//
//  OLABodyView.m
//  Ola
//
//  Created by Terrence Xing on 3/25/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLABodyView.h"
#import "OLALayout.h"
#import "OLAUIFactory.h"
#import "OLALuaContext.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "OLADatabase.h"



@implementation OLABodyView
@synthesize ctx;
@synthesize viewUrl,parameters;
@synthesize bodyLayout;
@synthesize LuaCode;



OLAUIFactory * ui;




- (id) initWithViewController:(OLAView *)bodyView andViewXMLUrl:(NSString * )viewUrl
{
    self=[super init];
    self.ctx=bodyView;
    self.viewUrl = viewUrl;
    [self create];
    return self;
    
}
- (void) create
{
    
    ui = [[OLAUIFactory alloc] initWithBodyView:ctx];
    [[OLALuaContext getInstance] regist:ui withGlobalName:@"_ui"];
    [[OLALuaContext getInstance] doFile:@"OLAUIFactory.lua"];
    
    [self loadXMLActivity];
    [self loadLuaCode];
    
}
/*
- (NSString *) getParameters
{
    return parameters;
}

- (void) setParameters:(NSString *) parameters
{
    // TODO
    // resolve the params and it should be set to lua before the lua code of
    // current view is executed
    self.parameters = parameters;
}
*/
- (void) execCallBack:(NSString *) callback
{
    if (callback != nil && [trim(callback) caseInsensitiveCompare:@""]==NSOrderedSame)
        [[OLALuaContext getInstance] doString:callback];
}




- (void) registReloadFun
{
    /*
    OLALayout *layout = nil;
    lua_State * lua = [[OLALuaContext getInstance] getLuaState];
    lua_newtable(lua);
    lua_pushvalue(lua, -1);
    lua_setglobal(lua, "sys");
    lua_pushstring(lua, "reload");
    lua_pushcfunction(lua, reload);
    lua_settable(lua, -3);
     */
    [[OLALuaContext getInstance] regist:self withGlobalName:@"sys"];
    
}



-(void) reload
{
    [self loadXMLActivity];
    [self loadLuaCode];
    [self show];
}


- (void) loadXMLActivity
{
    
    bodyLayout = [ui createLayout:self.ctx withXMLFile:viewUrl];
    // ctx.setContentView(bodyView.getView());
}

- (void) loadLuaCode
{
    
    self.LuaCode = [OLAUIFactory loadLayoutLuaCode:viewUrl] ;//ui.loadLayoutLuaCode(viewUrl);
    // ctx.setContentView(bodyView.getView());
}

/**
 * executed by other code while the View was shown to the Activity
 */
- (void) executeLua
{
    [self registReloadFun];
    [[OLALuaContext getInstance] doString:LuaCode];
    
    // if database class is defined by Lua, create a database connection
    // and set it to lua global
    lua_State * lua=[[OLALuaContext getInstance] getLuaState]; //LuaContext.getInstance().getLuaState();
    lua_getglobal(lua, "database");
    if(lua_istable(lua, -1))
    {
        OLADatabase * db=[[OLADatabase alloc] init];
        [[OLALuaContext getInstance] regist:db withGlobalName:@"connection"];
        /*
         lua.pushObjectValue(new Database(ctx));
         lua.setGlobal("connection");
         lua.pop(1);
         */
    }

    [[OLALuaContext getInstance] doString:@"initiate()"];
}

- (void) show
{
    if(LuaCode!=nil && [LuaCode compare:@""]!=NSOrderedSame)[self executeLua];
    //remove all the subviews from the view controller
    
    for (UIView * subview in [ctx.v subviews])
    {
        [subview removeFromSuperview];
        
    }
    NSLog(@"body show=%@",viewUrl);
    [ctx.v addSubview:bodyLayout.v];

}


@end
