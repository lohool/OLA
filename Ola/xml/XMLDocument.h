// XMLParser.h
//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XMLElement.h"
#import "XMLAttribute.h"

//@class AppDelegate, Book;
//@class XMLElement,XMLAttribute,Book;

#define  trim(str)  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface XMLDocument : NSObject <NSXMLParserDelegate> {
   NSMutableString *currentElementValue;  //���ڴ洢Ԫ�ر�ǩ��ֵ
   //AppDelegate *appDelegate;
   //Book *aBook;  //�鼮ʵ��
   XMLElement *root;
   int eleLevel;
}
@property (nonatomic, retain, readonly) XMLElement *root;
- (XMLDocument *)initXMLParser; //������
@end