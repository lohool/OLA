#import <Foundation/Foundation.h>
@interface LuaTestClass:NSObject {
   NSString  *name;
   NSString  *value;
}
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *value;
+(int) d:(NSString *)message;
+ (int) CallAdd:(lua_State*) L;
@end
