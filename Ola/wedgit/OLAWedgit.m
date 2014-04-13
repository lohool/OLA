//
//  OLAWedgit.m
//  Ola
//
//  Created by Terrence Xing on 3/21/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAWedgit.h"
#import "OLAView.h"
#import "XMLElement.h"
#import "CSS.h"
#import "OLALuaContext.h"
#import "LinearLayout.h"
#import "OLATextView.h"
#import "Layout.h"
#import "OLALongPressGestureRecognizer.h"
#import "Button.h"
#import "UILabelEx.h"
#import "OLAProperties.h"

@implementation OLAWedgit



//- abstract class IWedgit implements IView
LayoutParams * param;


- (id) initWithParent:(OLAView *) viewParent  withXMLElement:(XMLElement *) xmlRoot
{
    self.parent = viewParent;
    self.root = xmlRoot;
    return self;
    
}

- (void) initiate
{
    NSLog(@"start to initite OLAWedgit...");
    [self parseAttribute];
    [self parseCSS];
    [self addListner];
}

- (void) parseAttribute
{
    objId = (NSString *)[root.attributes objectForKey:@"id"];//((XMLElement *) root).getAttribute("id");
    if (objId != nil && ![objId isEqualToString:@""])
    {
        self.objId = [objId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // System.out.println("Create View Item by Id="+objId);
        [[OLALuaContext getInstance] regist:self withGlobalName:objId];
    }
    
    NSString * clicked = (NSString *)[root.attributes objectForKey:@"onclick"];
    if (clicked != nil && ![clicked isEqualToString:@""])
    {
        self.onclick = trim(clicked);
    }
    NSString * onpress = (NSString *)[root.attributes objectForKey:@"onpress"];
    if (onpress != nil && ![onpress isEqualToString:@""])
    {
        self.pressed = trim(onpress);
    }
    NSString * onrelease = (NSString *)[root.attributes objectForKey:@"onrelease"];
    if (onrelease != nil && ![onrelease isEqualToString:@""])
    {
        self.released = trim(onrelease);
    }
    NSLog(@"end parse attribute...");
}

- (void) parseCSS
{
    // set attributes
    if (css == nil)
    {
        NSString * cssNSString = (NSString *)[root.attributes objectForKey:@"style"];
        css = [[CSS alloc] initWithStyles:cssNSString];
    }
    // table
    if ([self.root.tagName caseInsensitiveCompare:@"TR"]==NSOrderedSame)
    {
        return;
    }
    
    CSS * parentCss = nil;
    if (self.parent != nil)
        parentCss = self.parent.css;
    NSString * attr;

   // if (param == nil)
    {
        /*
        if (getParent() == nil)
        {
            // the BODY tag or the created first level layout
            param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
                                           MarginLayoutParams.WRAP_CONTENT);
            // System.out.println("layout 1");
        }
        else if (getParent().getView() instanceof RelativeLayout)// ((attr=css.getStyleValue("position"))!=nil)
        {
            // System.out.println("layout 2");
            param = new RelativeLayout.LayoutParams(
                                                    MarginLayoutParams.WRAP_CONTENT,
                                                    MarginLayoutParams.WRAP_CONTENT);
            RelativeLayout.LayoutParams p = (RelativeLayout.LayoutParams) param;
            if (parentCss.textAlign != nil)
            {
                if ((parentCss.textAlign.equalsIgnoreCase("center")))
                    p.addRule(RelativeLayout.CENTER_HORIZONTAL,
                              RelativeLayout.TRUE);
                // else if(
                // (css.textAlign.equalsIgnoreCase("top")))p.addRule(RelativeLayout.ALIGN_TOP,RelativeLayout.TRUE);
                else if ((parentCss.textAlign.equalsIgnoreCase("left")))
                    p.addRule(RelativeLayout.ALIGN_LEFT,
                              RelativeLayout.TRUE);
                else if ((parentCss.textAlign.equalsIgnoreCase("right")))
                    p.addRule(RelativeLayout.ALIGN_RIGHT,
                              RelativeLayout.TRUE);
                // else if(
                // (css.textAlign.equalsIgnoreCase("bottom")))p.addRule(RelativeLayout.ALIGN_BOTTOM,RelativeLayout.TRUE);
            }
            if (parentCss.verticalAlign != nil)
            {
                if ((parentCss.verticalAlign.equalsIgnoreCase("middle") || (css.verticalAlign
                                                                            .equalsIgnoreCase("center"))))
                    p.addRule(RelativeLayout.CENTER_VERTICAL,
                              RelativeLayout.TRUE);
                else if (parentCss.verticalAlign.equalsIgnoreCase("top"))
                    p.addRule(RelativeLayout.ALIGN_TOP, RelativeLayout.TRUE);
                else if (parentCss.verticalAlign.equalsIgnoreCase("bottom"))
                    p.addRule(RelativeLayout.ALIGN_BOTTOM,
                              RelativeLayout.TRUE);
            }
        }
        // table
        else if (self.getRoot().getXMLElement *Name().equalsIgnoreCase("TABLE"))
        {
            // System.out.println("layout 3");
            param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
                                           MarginLayoutParams.WRAP_CONTENT);
        }
        
        // table cells
        else if (getParent().getRoot().getXMLElement *Name().equalsIgnoreCase("TR"))
        {
            // System.out.println("layout 4");
            TableRow.LayoutParams p = new TableRow.LayoutParams(
                                                                TableRow.LayoutParams.WRAP_CONTENT,
                                                                TableRow.LayoutParams.WRAP_CONTENT);
            param = p;
        }
        else 
         
         if ([self.parent.v isKindOfClass: [LinearLayout class]])
        {
            // System.out.println("layout 5");
            //LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
            //                                                            MarginLayoutParams.WRAP_CONTENT,
            //                                                            MarginLayoutParams.WRAP_CONTENT);
            LinearLayout * layout= (LinearLayout *)self.parent.v;
            param=layout.layoutParams;
            NSLog(@"css.weight=%d",css.weight);
            if (css.weight > 0)
            {
                param->weight = css.weight;
            }

        }
        
        else
            param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
                                           MarginLayoutParams.WRAP_CONTENT);
        // System.out.println("layout 6");
         */
    }
    /*
    if (param == nil)
        return;
    */
    /*
    if (css.weight > 0)
    {
        param->weight = css.weight;
    }
    */
    
    if ((attr = [css getStyleValue:@"background-color"]) != nil)
    {
        [self setBackgroundColor:attr];
    }
    /*
    if (css.color != 0)
        self.setColor(css.color);
     */
    if(css.color!=nil)
    {
        NSString * text = css.color;
        if (text != nil && ![trim(text) isEqualToString:@""])
        {
            if ([self isKindOfClass:[OLATextView class]])
            {
                 NSLog(@"text view set color=%@",css.color);
                [((OLATextView *) self) setColor:text];
            }
        }
        //NSLog(@"tag=%@, text=%@",self.root.tagName,text);
    }
    
    // System.out.println("background-image="
    // + css.getStyleValue("background-image"));
    
    if ((attr = [css getStyleValue:@"background-image"]) != nil)
    {
        NSLog(@"image=%@",[CSS parseImageUrl:attr]);
        [self setBackgroundImageUrl:[CSS parseImageUrl:attr]];
    }
     
    // set position attributes
    // System.out.println("top=" + css.getStyleValue("top"));
    if ((attr = [css getStyleValue:@"top"]) != nil)
    {
        [self setTop:[CSS parseInt:attr]];
    }
     
    // System.out.println("left=" + css.getStyleValue("left"));
    if ((attr = [css getStyleValue:@"left"]) != nil)
    {
        [self setLeft:[CSS parseInt:attr]];
    }
    
    // System.out.println("width=" + css.getStyleValue("width"));
    if ((attr = [css getStyleValue:@"width"]) != nil)
    {
        if ([attr caseInsensitiveCompare:@"auto"] ==NSOrderedSame)
        {
            [self setWidth:0];
        } else
            [self setWidth:[CSS parseInt:attr]];
    }
    // System.out.println("height=" + css.getStyleValue("height"));
    if ((attr = [css getStyleValue:@"height"]) != nil)
    {
        NSLog(@"height attr=%@",attr);
        if ([attr caseInsensitiveCompare:@"auto"] ==NSOrderedSame)
        {
            [self setHeight:0];
        } else
            [self setHeight:[CSS parseInt:attr]];
    }
    /*
    // System.out.println("text=" + css.getStyleValue("text"));
    if ((attr = css.getStyleValue("text")) != nil)
    {
        self.setText(attr);
    }
    
    param.setMargins(css.margin.left, css.margin.top, css.margin.right,
                     css.margin.bottom);
    */
    if(root.textContent!=nil)
    {
    NSString * text = root.textContent.value;
    if (text != nil && ![trim(text) isEqualToString:@""])
    {
        if ([self isKindOfClass:[OLATextView class]])
        {
            NSLog(@"self.view=%f",self.v.frame.size.width);
            [((OLATextView *) self) setText:text];
        }
    }
    //NSLog(@"tag=%@, text=%@",self.root.tagName,text);
    }
    /*
    else{
        NSLog(@"tag=%@, text=is null",self.root.tagName);
    }
     */
    
   // v.setLayoutParams(param);
    
   // v.requestLayout();
}

- (void) doubleClicked:(UITapGestureRecognizer*)recognizer
{
    
    NSLog(@"view=%@,doubleClicked=%@",[v class],onclick);
    if (onclick != nil)
    {
        [[OLALuaContext getInstance] doString:onclick];
    }
}

- (void) clicked
{
    
    NSLog(@"view=%@,clicked=%@",[v class],onclick);
    if (onclick != nil)
    {
        [[OLALuaContext getInstance] doString:onclick];
    }
}

- (void) clicked1:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"clicked1 UIGestureRecognizerStateBegan,view id=%@",self.objId);
        if (pressed != nil)
        {
            [[OLALuaContext getInstance] doString:pressed];
        }
    }
    if (recognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"clicked1 UIGestureRecognizerStateChanged");
        //draged
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"clicked1 UIGestureRecognizerStateEnded");
        [self released];
    }
    
}
- (void) onpress
{
    if (pressed != nil)
    {
        [[OLALuaContext getInstance] doString:pressed];
    }
}
- (void) pressed1:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan,view id=%@",self.objId);
        if (pressed != nil)
        {
            [[OLALuaContext getInstance] doString:pressed];
        }
    }
    if (recognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        //draged
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self released];
    }

}

- (void) onrelease
{
    NSLog(@"released=%@",released);
    if (released != nil)
    {
        [[OLALuaContext getInstance] doString:released];
    }
}

- (void) addListner
{
    
    if([self.v isKindOfClass:[Button class]])
    {
        Button *btn=(Button *)self.v;
        btn.delegate=self;
    }
    else if([self.v isKindOfClass:[UILabelEx class]])
    {
        UILabelEx *iv=(UILabelEx *)self.v;
        iv.delegate=self;
    }
    else if([self.v isKindOfClass:[IView class]])
    {
        IView *iv=(IView *)self.v;
        iv.delegate=self;
    }


    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicked:)];
    
    UITapGestureRecognizer*  doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClicked:)];

    if( [self.v isKindOfClass:[UITextField class]] )
    {
        
    }
    else
    {
        
        //tapGesture.delegate = self;
        tapGesture.delaysTouchesBegan=YES;
        tapGesture.delaysTouchesEnded=NO;
        //[v addGestureRecognizer:tapGesture];
        /*
        // 双击的 Recognizer
        
        doubleRecognizer.numberOfTapsRequired = 2; // 双击
        //关键语句，给self.view添加一个手势监测；
        [v addGestureRecognizer:doubleRecognizer];
        
        // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
        [ tapGesture requireGestureRecognizerToFail: doubleRecognizer];
         */
    }
    
    
    //do not regist long preaaed event to UIButton(UIButton can be reqrited by UILabel)
    if([self.v isKindOfClass:[UIButton class]] || [self.v isKindOfClass:[UITextField class]])
    {
        
    }
    //else
    //    if([self.v isKindOfClass:[Layout class] ])
    //if(self.pressed!=nil)
    {
        
        UILongPressGestureRecognizer *singleClick = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clicked1:)];
        singleClick.minimumPressDuration = 0.01;
        //longPressReger1.delegate =  self;
       // singleClick.delaysTouchesBegan=NO;
        //singleClick.delaysTouchesEnded=NO;
        //[singleClick requireGestureRecognizerToFail:doubleRecognizer];
       // [v addGestureRecognizer:singleClick];
        
    UILongPressGestureRecognizer *longPressReger1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressed1:)];
    longPressReger1.minimumPressDuration = 0.3;
    //longPressReger1.delegate =  self;
    //longPressReger1.delaysTouchesBegan=NO;
    //longPressReger1.delaysTouchesEnded=NO;
    [tapGesture requireGestureRecognizerToFail:longPressReger1];
    //[v addGestureRecognizer:longPressReger1];
    }
    
    
    if([self.v isKindOfClass:[UIButton class]])
    {
        
    }
    else
    {
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [v addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [v addGestureRecognizer:recognizer];
    }

    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *)event
{
     //NSLog(@"view touch was moved");
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self onpress];
    NSLog(@"view was pressed");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self clicked];
    NSLog(@"view touch was ended");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
   
    NSLog(@"view touch was cancelled");
}

-(void)event:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"view touch event:%d",recognizer.state);
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    //UISwipeGestureRecognizerDirectionLeft   UISwipeGestureRecognizerDirectionRight  UISwipeGestureRecognizerDirectionUp  UISwipeGestureRecognizerDirectionDown
    
     NSLog(@"move direction=%@",recognizer.description);
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft ) {
        NSLog(@"Left");
    }
    
    /*
     UISwipeGestureRecognizer *recognizer;
     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
     [[self view] addGestureRecognizer:recognizer];
     [recognizer release];
     
     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
     [[self view] addGestureRecognizer:recognizer];
     [recognizer release];
     
     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
     [[self view] addGestureRecognizer:recognizer];
     [recognizer release];
     
     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
     [[self view] addGestureRecognizer:recognizer];  
     [recognizer release];
     */
    
}


- (int) getWidth
{
    return self.v.frame.size.width;
}

- (void) setWidth:(int) width
{
    css.width = width;
    if(width>0)
    {
    [v setFrame:CGRectMake(self.v.frame.origin.x,self.v.frame.origin.y, width, self.v.frame.size.height)];
    NSLog(@"setWidth id=%@ : X=%f,Y=%f,w=%d,h=%f",self.objId, self.v.frame.origin.x,self.v.frame.origin.y, width, self.v.frame.size.height);
    }
}

- (int) getHeight
{
    
    return self.v.frame.size.height;
}

- (void) setHeight:(int) height
{
    if(height>0)
    {
        
    [v setFrame:CGRectMake(self.v.frame.origin.x,self.v.frame.origin.y, self.v.frame.size.width, height)];
     NSLog(@"setHeight id=%@ : X=%f,Y=%f,w=%f,h=%d",self.objId, self.v.frame.origin.x,self.v.frame.origin.y, self.v.frame.size.width, height);
    }
        css.height = height;
}
- (int) getTop
{
    return self.v.frame.origin.x;
}

- (void) setTop:(int) top
{
    [v setFrame:CGRectMake(self.v.frame.origin.x,top, self.v.frame.size.width, self.v.frame.size.height)];
    css.top = top;
}

- (int) getLeft
{
    return self.v.frame.origin.x;
}

-(void) setLeft:(int) left
{
    [v setFrame:CGRectMake(left,self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height)];
    css.left = left;
}


- (NSString *) getBackgroundColor
{
    
    return css.backgroundColor;
}

- (void) setBackgroundColor:(NSString * )backgroundColor
{
    UIColor * bg = [CSS parseColor:backgroundColor];
    [v setBackgroundColor:bg];
}




/*
- (void) setColorInt:(int) color
{
    css.color = color;
    //if (v instanceof TextView)
    //    ((TextView) v).setTextColor(color);
}
 */
/*
- (void) setVisibility:(BOOL) visibility
{
    if (visibility)
        v.setVisibility(View.VISIBLE);
    else
        v.setVisibility(View.GONE);
}
*/
- (NSString *) getBackgroundImageUrl
{
    return css.backgroundImageURL;
}
-(void) setBackgroundImageUrl:(NSString *) imageUrl
{
    OLAProperties * param=[OLAProperties getInstance];
    NSString * img =[param.appUrl stringByAppendingString:imageUrl];
    if([self.v isKindOfClass:[UIButton class]])
    {
        UIButton * btn=(UIButton *) self.v;
        [btn  setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateSelected];
        //这个是设置背景图片的
        //[deleteBtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        //这个是button前景图片
    }
    else if([self.v isKindOfClass:[UILabel class]])
    {
        //set back image for label
        UILabel * myLabel=(UILabel *)self.v;
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:img]];
        [myLabel setBackgroundColor:color];
        
    }
    else
    
    {
        UIImage * bg=[UIImage imageNamed:img];
        bg=[self imageScale:bg toSize:self.v.frame.size];
        UIColor *bgColor = [UIColor colorWithPatternImage: bg];
        [self.v setBackgroundColor:bgColor];
    }
}

- (UIImage *)imageScale:( UIImage *)sourceImage toSize:(CGSize)targetSize
{
    
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

/*
- (void) setBackgroundImageUrl:(NSString *) backgroundImageURL
{
    // v.setBackground( new
    // BitmapDrawable(returnBitMap(backgroundImageURL)));
    // BitmapDrawable bd=new
    // BitmapDrawable(returnBitMap(backgroundImageURL));
    
    if (backgroundImageURL.startsWith("http://"))
    {
        DownloadImage task = new DownloadImage();
        task.execute(backgroundImageURL);
    } else
    {
        
        v.setBackgroundDrawable(new BitmapDrawable(
                                                   getImageFromAssetsFile(backgroundImageURL)));
    }
    
    // Bitmap image = nil;
    
    // try {
    // image = task.get();
    // } catch (InterruptedException e) {
    // e.printStackTrace();
    // } catch (ExecutionException e) {
    // e.printStackTrace();
    // }
    // v.setBackgroundDrawable(new BitmapDrawable(image));
    
    // v.setBackgroundDrawable(new BitmapDrawable(
    // returnBitMap(backgroundImageURL)));
    css.backgroundImageURL = backgroundImageURL;
}
 */
/*
+ PictureDrawable getcontentPic(NSString * imageUri)
{
    URL imgUrl = nil;
    imgUrl = new URL(imageUri);
    System.out.println(imageUri);
    PictureDrawable icon = nil;
    HttpURLConnection hp = (HttpURLConnection) imgUrl.openConnection();
    icon = new PictureDrawable(Picture.createFromStream(hp
                                                        .getInputStream()));// ��������ת����bitmap
    hp.disconnect();// �ر�����
    return icon;
}

- static Bitmap returnBitMap(NSString * url)
{
    
    URL myFileUrl = nil;
    Bitmap bitmap = nil;
    myFileUrl = new URL(url);
    HttpURLConnection conn = (HttpURLConnection) myFileUrl
    .openConnection();
    conn.setDoInput(true);
    conn.connect();
    InputStream is = conn.getInputStream();
    bitmap = BitmapFactory.decodeStream(is);
    is.close();
    return bitmap;
}
*/
/*
 * l onClick(View v) һ����ͨ�ĵ����ť�¼�
 *
 * l boolean onKeyMultiple(int keyCode,int repeatCount,KeyEvent
 * event)�����ڶ���¼�����ʱ�������ڰ����ظ�����������@Overrideʵ��
 *
 * l boolean onKeyDown(int keyCode,KeyEvent event) �����ڰ�����а���ʱ����
 *
 * l boolean onKeyUp(int keyCode,KeyEvent event�� �����ڰ�������ͷ�ʱ����
 *
 * l onTouchEvent(MotionEvent event)�������¼������ڴ��������ж���ʱ����
 *
 * l boolean onKeyLongPress(int keyCode, KeyEvent event)���㳤ʱ�䰴ʱ�������ʣ���
 */
/*
class ButtonListener implements OnClickListener, OnTouchListener
{
    - (void) onClick(View v)
    {
        
        Log.d("test", "cansal button ---> click");
        clicked();
    }
    
    - boolean onTouch(View v, MotionEvent event)
    {
        
        if (event.getAction() == MotionEvent.ACTION_UP)
        {
            Log.d("test", "cansal button ---> cancel");
            released();
            
        }
        if (event.getAction() == MotionEvent.ACTION_DOWN)
        {
            Log.d("test", "cansal button ---> down");
            pressed();
        }
        return false;
    }
    
}
 */


- (UIView*) getView
{
    return v;
}

- (XMLElement *) getRoot
{
    return self.root;
}
/*
*/

- (CSS *) getCss
{
    return css;
}

- (UIView *) getParent
{
    return parent;
}
/*
- (void) setParent:(UIView *)parent
{
    // clear the param while the view has no a previous parent
    // if(self.parent==nil)
    param = nil;
    self.parent = parent;
    //System.out.println("parent=" + parent);
    // rebuild the properties which will be related to the current parent.
    [self parseCSS];
    
}
 */
/*
private Bitmap getImageFromAssetsFile(NSString * fileName)
{
    Bitmap image = nil;
    AssetManager am = context.getResources().getAssets();
    try
    {
        InputStream is = am.open(fileName);
        image = BitmapFactory.decodeStream(is);
        is.close();
    } catch (IOException e)
    {
        e.printStackTrace();
    }
    
    return image;
    
}

private class DownloadImage extends AsyncTask<NSString *, Integer, Bitmap>
{
    
    - Bitmap doInBackground(NSString *... urls)
    {
        Bitmap image = nil;
        // backgroundImageURL = url;
        try
        {
            image = returnBitMap(urls[0]);
        } catch (Exception e1)
        {
            e1.printStackTrace();
        } finally
        {
            
        }
        return image;
        
    }
    
    - (void) onProgressUpdate(Integer... progress)
    {
        
    }
    
    - (void) onPostExecute(Bitmap result)
    {
        
        v.setBackgroundDrawable(new BitmapDrawable(result));
    }
    
}
 */


@end