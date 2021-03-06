// XMLParser.h
//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XMLElement.h"
#import "XMLAttribute.h"

//@class AppDelegate, Book;
//@class XMLElement,XMLAttribute,Book;

#define  trim(str)  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface XMLDocument : NSObject <NSXMLParserDelegate> {
   NSMutableString *currentElementValue;  //用于存储元素标签的值
   //AppDelegate *appDelegate;
   //Book *aBook;  //书籍实例
   XMLElement *root;
   int eleLevel;
}
@property (nonatomic, retain, readonly) XMLElement *root;
- (XMLDocument *)initXMLParser; //构造器
@end