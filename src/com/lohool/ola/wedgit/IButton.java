package com.lohool.ola.wedgit;


import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.lohool.ola.Main;
import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.widget.Button;
import android.widget.TextView;


@SuppressLint("NewApi")
public class IButton extends IWedgit{
	
	int preBgColor;
	
	String defaultStyle="width:auto;align:center;valign:middle;background-color:#FFFBF0;border:solid 1px #FFF0F0 5px;";
	
	public IButton(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context, root,ui);
		Button t=new Button(context);
		v=t;
		super.defaultCSSStyle=defaultStyle;
		super.initiate();
		t.setGravity(css.getGravity());
	}
//	public void setText(String text)
//	{
//		Button btn=(Button)super.v;
//			text=text.replaceAll("\\\\n", "\n");
//			text=text.replaceAll("\\\\\n", "\\\\n");
//			btn.setText(text);
//			btn.requestLayout();
//	}

	protected void clicked() {
		
		super.clicked();
	}

	@Override
	protected void pressed() {
		System.out.println("button pressed");
		//this.setBackgroundColor(preBgColor);
		Button btn=(Button)v;

		//Rect bounds=btn.getBackground().getBounds();
		Drawable drawable1=btn.getBackground();
		if(drawable1 instanceof ColorDrawable || drawable1 instanceof GradientDrawable)
		{
			preBgColor=this.getBackgroundColor();
			GradientDrawable drawable = new GradientDrawable();
		    drawable.setShape(GradientDrawable.RECTANGLE);
		    drawable.setStroke(1, Color.parseColor("#FF7F00"));
		    drawable.setFilterBitmap(true);
		    //drawable.setBounds(bounds.left-1, bounds.top-1, bounds.right+1, bounds.bottom+1);
		    //drawable.set
		    //drawable.setAlpha(0.9); 
		    drawable.setColor(preBgColor);
		    //drawable.setColorFilter(Color.argb(168, 255, 75, 75), android.graphics.PorterDuff.Mode.DST_OUT);
		    btn.setBackground(drawable);
		}
		else if(drawable1 instanceof IBorder )
		{
			IBorder b=new IBorder(Color.parseColor("#FF7F00"),css.border.color,(int)(css.border.width*Main.scale),(int)(css.border.radius*Main.scale));
			v.setBackground(b);
		}
		else
		{			
			//drawable1.setColorFilter(Color.argb(168, 255, 75, 75), android.graphics.PorterDuff.Mode.DST_OUT);
			btn.setBackground(drawable1);
		}

		super.pressed();
	}

	@Override
	protected void released() {
		System.out.println("button released"); 
		Button btn=(Button)v;	
		Drawable drawable1=btn.getBackground();
		drawable1.clearColorFilter();
		if(drawable1 instanceof ColorDrawable || drawable1 instanceof GradientDrawable)
		{
			preBgColor=this.getBackgroundColor();
			GradientDrawable drawable = new GradientDrawable();
		    drawable.setColor(preBgColor);
		    drawable1=drawable;
		    
		    
		}
		else if(drawable1 instanceof IBorder )
		{
			drawable1=new IBorder(this.getBackgroundColor(),css.border.color,(int)(css.border.width*Main.scale),(int)(css.border.radius*Main.scale));
		}
		
		btn.setBackground(drawable1);
		super.released();
	}

 

}
