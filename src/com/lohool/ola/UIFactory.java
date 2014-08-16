package com.lohool.ola;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;

import org.apache.http.util.EncodingUtils;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;











import com.lohool.ola.util.XMLProperties;
import com.lohool.ola.wedgit.IButton;
import com.lohool.ola.wedgit.ICheckBox;
import com.lohool.ola.wedgit.IContainer;
import com.lohool.ola.wedgit.ILabel;
import com.lohool.ola.wedgit.IProgressBar;
import com.lohool.ola.wedgit.IScrollView;
import com.lohool.ola.wedgit.ITable;
import com.lohool.ola.wedgit.ITableRow;
import com.lohool.ola.wedgit.ITextField;
import com.lohool.ola.wedgit.IView;
import com.lohool.ola.wedgit.Layout;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Looper;


public class UIFactory {
	Context ctx;
	BodyView bodyView;
	static HashMap viewCache= new HashMap();
	

	
	public UIFactory(BodyView bodyView,Context ctx )
	{
		this.bodyView=bodyView;
		this.ctx=ctx;
	}
	public void switchView(String name,String callback,String params)
	{
		switchView(name,callback,params,false);
	}
	
	public void switchView(String pageName,String callback,String params,boolean needReload)
    {
//		String name=AppProperties.getInstance().getAppBase()+pageName;
		String name=OLA.appBase+pageName;
		BodyView v;
		Object obj=viewCache.get(name);
		if(obj!=null && !needReload)
		{			
			v=(BodyView)obj;
		}
		else
		{
		 v=new BodyView(ctx,name);
		if(!needReload) viewCache.put(name, v);
		
		}
		v.setParameters(params);
		v.execCallBack(callback);
  	 	v.show();

    }
	public String getParameters() {
		return bodyView.getParameters();
	}
	
//	public  Layout loadXML(String url) 
//	{
//	 return loadXML(url,true);
//	}
	/**
	 * load and create an first Level Layout from an XML file
	 * @return
	 */
	public  Layout createLayoutByXMLFile(String url) {
		Layout layout = null;

			try {
				// String
				// xml=loadAssetsString("http://10.0.2.2:8080/CRM/testLua.htm");
				 System.out.println("Layout xml url="+url);
				XMLProperties xmlRoot = new XMLProperties(loadAssetsString(url));
				Element html = xmlRoot.getRootElement();
				layout=createActiveBody(html);
//				LayoutInflater flat=LayoutInflater.from(ctx);
				
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		
		
		return layout;
	}
	public  Layout createLayoutByXMLString(String xml) {
		Layout layout = null;

			try {
				// String
				// xml=loadAssetsString("http://10.0.2.2:8080/CRM/testLua.htm");
				// System.out.println(xml);
				XMLProperties xmlRoot = new XMLProperties(xml);
				Element html = xmlRoot.getRootElement();
				layout=createActiveBody(html);
//				LayoutInflater flat=LayoutInflater.from(ctx);
				
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		
		
		return layout;
	}
	/**
	 * create a dynamic view by Lua script
	 * @param xml
	 * @return
	 */
	public String createView(String xml)
	{
		String id=null;
		try {
			//System.out.println("create xml view:"+xml);
			//Looper.prepare();
			XMLProperties xmlRoot = new XMLProperties(xml);
			Element root=xmlRoot.getRootElement();
			id=root.getAttribute("id");
			if(id==null || id.trim().equals(""))
			{
				id="View_ID_"+root.getNodeName()+"_"+System.currentTimeMillis()+"_"+(int)(Math.random()*1000);
				root.setAttribute("id", id);				
			}
			
			IView v=null;
			if(root.getNodeName().equalsIgnoreCase("DIV"))
			{
				Layout layout= Layout.createLayout(null, ctx,  root);
				v=layout;
			}
			else if(root.getNodeName().equalsIgnoreCase("TR"))
			{
				v=new ITableRow(null, ctx,  root);
			}
			else
			{
				
				IView view=UIFactory.createView(null, ctx,  root);
				v=view;
			}
			LuaContext.getInstance().regist(v, id);
			//Looper.loop();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return id;
	}

	private Layout createActiveBody(Element xmlRoot)
	{
		Layout layout = null;
		try {
			NodeList nl = xmlRoot.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {

				Node n = nl.item(i);
				if (n != null && n.getNodeType() == Node.ELEMENT_NODE
						&& ((Element) n).getTagName().equalsIgnoreCase("body")) {
					layout = Layout.createLayout(null, ctx, n);
					// this.setContentView(layout.getView());
				}
			}
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		

		return layout;
	}
	public static String loadLayoutLuaCode(String xmlUrl)
	{
//		String temp = loadAssetsString("http://10.0.2.2:8080/test/lua/FileOpener.lua");
//		lua.LdoString(temp);
		System.out.println("lua file="+xmlUrl+".lua");
		
		String temp = loadAssetsString(xmlUrl+".lua");
		return temp;
	}

	
	public static IView createView(IContainer rootView,Context context,Node n)
	{
		IView v=null;
		String name=n.getNodeName();
    	if (name.equalsIgnoreCase("BUTTON"))
    	{
    		v= new IButton(rootView,context,n);
    		
    	}
    	else if (name.equalsIgnoreCase("LABEL"))
    	{
    		v= new ILabel(rootView,context,n);
    	}
    	else if (name.equalsIgnoreCase("TEXTFIELD"))
    	{
    		v= new ITextField(rootView,context,n);
    		//rootView.addView(text);
    	}
    	else if (name.equalsIgnoreCase("TABLE"))
    	{
    		v= new ITable(rootView,context,n);
    		//rootView.addView(text);
    	}
    	else if (name.equalsIgnoreCase("SCROLLVIEW"))
    	{
    		v= new IScrollView(rootView,context,n);
    		//rootView.addView(text);
    	}
    	else if (name.equalsIgnoreCase("PROGRESSBAR"))
    	{
    		v= new IProgressBar(rootView,context,n);
    	}
    	else if (name.equalsIgnoreCase("CHECKBOX"))
    	{
    		v= new ICheckBox(rootView,context,n);
    		//rootView.addView(text);
    	}
    	return v;
	}
//	static HttpURLConnection  urlConn =null;
	 private static class DownloadTask extends AsyncTask<String, Integer, String> {

		 protected String doInBackground(String... urls)
		 {
			 InputStream in=null;
			 ByteArrayOutputStream out= new ByteArrayOutputStream();
				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					URL url = new URL(urls[0]);
					urlConn = (HttpURLConnection) url.openConnection();
					in = urlConn.getInputStream();

					int count = 0;

					while (-1 != (count = in.read(bs)))
					{
						out.write(bs, 0, count);
					}


				} catch (Exception e1)
				{
					e1.printStackTrace();
				} finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (in != null)
					{
						try
						{
							in.close();

						} catch (IOException e)
						{
						}
					}
				}
				String content="";
				try
				{
					content=out.toString("utf-8");
				} catch (UnsupportedEncodingException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					out.close();
				} catch (IOException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				return content;
		 }
		protected String doInBackground1(String... urls) {
			int count = urls.length;
			InputStream isread = null;
			HttpURLConnection urlConn =null;
			StringBuffer buf = new StringBuffer();
			byte[] luaByte = new byte[1];
			try {
				URL url = new URL(urls[0]);
				urlConn = (HttpURLConnection) url.openConnection();
				
				isread = urlConn.getInputStream();
				

				int len = 0;
				while ((len = isread.available()) > 0) 
				{
					luaByte = new byte[len];
					isread.read(luaByte);
					buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally {
				if (isread != null) {
					try {
						isread.close();
						isread=null;
					} catch (IOException e) {
					}
				}
				if (urlConn != null) {
						urlConn.disconnect();
				}
			}
			return buf.toString();

		}
		protected void onProgressUpdate(Integer... progress) {

		}

		protected void onPostExecute(Long result) {

		}

	}

	// ���URL�õ�������
//	private static InputStream getInputStreamFromUrl(String urlStr)
//			throws Exception {
//		URL url = new URL(urlStr);
//		HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
//		InputStream inputStream = urlConn.getInputStream();
//		return inputStream;
//	}
	
	public static String loadResourceTextDirectly(String resPath) {

		if(resPath.startsWith("http://"))return loadOnline(resPath);
		else
		return loadAssert(resPath);

	}
	public static String loadOnline(String resPath) {

			 InputStream in=null;
			 ByteArrayOutputStream out= new ByteArrayOutputStream();
				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					URL url = new URL(resPath);
					urlConn = (HttpURLConnection) url.openConnection();
					in = urlConn.getInputStream();

					int count = 0;

					while (-1 != (count = in.read(bs)))
					{
						out.write(bs, 0, count);
					}


				} catch (Exception e1)
				{
					e1.printStackTrace();
				} finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (in != null)
					{
						try
						{
							in.close();

						} catch (IOException e)
						{
						}
					}
				}
				String content="";
				try
				{
					content=out.toString("utf-8");
				} catch (UnsupportedEncodingException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					out.close();
				} catch (IOException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				return content;

	}
	
	public static String loadAssert(String resPath) {
		StringBuffer buf = new StringBuffer();
			// 获得InputStream对象
//			InputStream is = getResources().getAssets().open("IELTSCore3000.db");
			
		InputStream isread = null;
			
			byte[] luaByte = new byte[0];
			try {
				 isread =new FileInputStream(resPath);
				int len = 0;
				while ((len = isread.available()) > 0) {
					luaByte = new byte[len];
					isread.read(luaByte);
					buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally {
				if (isread != null) {
					try {
						isread.close();
					} catch (IOException e) {
					}
				}
			}
			return buf.toString();
	}

	// ����õ��������浽һ���ַ���
	public static String loadAssetsString(String resPath) {
		String code=null;
		
		if(resPath.startsWith("http://"))
		{
		DownloadTask task=new DownloadTask();
        task.execute(resPath); 
        
		try {
			code = task.get();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}
		else
			code=loadAssert(resPath);

       return code;
		/*
		InputStream isread = null;
		StringBuffer buf = new StringBuffer();
		byte[] luaByte = new byte[1];
		try {
			isread = UIFactory.getInputStreamFromUrl(resPath);

			int len = 0;
			while ((len = isread.available()) > 0) {
				luaByte = new byte[len];
				isread.read(luaByte);
				buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
			if (isread != null) {
				try {
					isread.close();
				} catch (IOException e) {
				}
			}
		}
		return buf.toString();
		*/
		
	}
/*	
	private class DownloadAscill implements Runnable
	{
		boolean isFinished;
		String ac;
		public DownloadAscill(String ac)
		{
			this.ac=ac;
		}
		StringBuffer buf = new StringBuffer();
		@Override
		public void run() {
			InputStream isread = null;
			HttpURLConnection urlConn =null;
			byte[] luaByte = new byte[1];
			try {
				
				URL url = new URL(ac);
				urlConn = (HttpURLConnection) url.openConnection();
				isread = urlConn.getInputStream();

				int len = 0;
				while ((len = isread.available()) > 0) {
					luaByte = new byte[len];
					isread.read(luaByte);
					buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally {
				if (isread != null) {
					try {
						isread.close();
					} catch (IOException e) {
					}
				}
				if(urlConn!=null)
				{
					urlConn.disconnect();
				}
			}
			
		  	 	
		  	 	//ac.setContentView(v.getLayout().getView());
		}
		public boolean isFinished()
		{
			return this.isFinished;
		}
		public String getValue()
		{
			return buf.toString();
		}
		
	}
	
*/
}
