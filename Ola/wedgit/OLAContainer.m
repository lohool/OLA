//
//  OLAContainer.m
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAContainer.h"

#import "OLAView.h"
#import "OLALayout.h"
#import "OLAProperties.h"
#import "OLAButton.h"
#import "OLATable.h"
#import "OLALuaContext.h"
#import "OLAUIFactory.h"
#import "UILabelEx.h"
#import "OLALabel.h"


@implementation OLAContainer



- (id):(OLAView *) parentView  withXMLElement:(XMLElement *) rootEle
{
    return [super initWithParent:parentView withXMLElement:rootEle];
    //return self;
}
//	- void addView(View child)
//	{
//		((ViewGroup)v).addView(child);
//		//child.requestLayout();
//	}
//	void addView(OLAView * child)
//	{
//		((ViewGroup)v).addView(child.getView());
//		//child.getView().requestLayout();
//	}

- (void) parseChildren:(OLAContainer *) rootView withXMLElement:(XMLElement *) rootEle
{
    NSLog(@"start to parse children...");
    for (XMLElement * n in rootEle.children)
    {
        
        //if (n != null && n.getXMLElementType() == XMLElement.ELEMENT_XMLElement)
        {
            NSString * name=n.tagName;
            NSLog(@"view=%@,text=%@",name,n.textContent.value);
            if([name caseInsensitiveCompare:@"DIV"]==NSOrderedSame)
            {
                NSString * layoutName=[n.attributes objectForKey:@"layout"];
                if([layoutName caseInsensitiveCompare:@"FrameLayout"]
                   || ([layoutName caseInsensitiveCompare:@"LinearLayout"]) || ([layoutName caseInsensitiveCompare:@"RelativeLayout"]))
                {
                    OLALayout * layout= [OLALayout createLayout:rootView withXMLElement:n];//Layout.createLayout(rootView,self.context,n);
                    [rootView addSubview:layout];
                }
            }
            else
            {
                OLAView * view=[OLAUIFactory createView:rootView withXMLElement:n];//UIFactory.createView(rootView, context,   n);
                [rootView addSubview:view];
                
            }
            
            
        }
    }
}


- (void) addSubview:(OLAView *) child
{
    //implemented by sub class
}

- (void) addOLAView :(OLAView *) child
{
    
    if(child.parent==nil)
    {
        child.parent=self;
        //rebuild the properties of the view.
        //be rebuilt by the setParent method
        //((IWedgit)child).parseCSS();
    }
    [self addSubview:child];
    
    //child.getView().requestLayout();
}
/*
 - void removeView(OLAView * child) {
 if (child==null) return;
 ((ViewGroup) v).removeView(child.getView());
 
 }
 */
/**
 * add a child by Lua id, self method will be used by the lua script
 * @param id
 */
- (void) addView:(NSString *) objLuaId
{
    CGRect size=self.v.frame;
    //lua.getGlobal(id);
    id obj=[[OLALuaContext getInstance]  getObject:objLuaId];
    [self addSubview:obj];
    
    //adjust the Label's acture size, and the layout will be shrinked
    if([obj isKindOfClass:[OLALabel class]])
    {
        OLALabel *label =(OLALabel *)obj;
        [label adjustSelfSize:v.frame.size.width];
    }
    //repaint the layout with its origional size
    [v setFrame:size];
    Layout *layout = (Layout *)v;
    [layout repaint];
    
    
}
/**
 * remove a child view from the current container by the child's lua id
 * @param id
 */
- (void) removeChild:(NSString *) objId
{
    id obj=[[OLALuaContext getInstance]  remove:objId];
    //v remove//removeView((OLAView *)obj);
}
- (void) repaint
{
    
}
@end
