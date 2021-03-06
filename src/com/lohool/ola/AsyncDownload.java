package com.lohool.ola;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayDeque;

import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;

import com.lohool.ola.wedgit.IProgressBar;
import com.lohool.ola.wedgit.UIMessage;


/**
 * For Lua
 * 
 * @author xingbao-
 * 
 */
@SuppressLint("NewApi")
public class AsyncDownload
{
	IProgressBar bar;
	IProgressBar barTotal;
	String processingCallback;
	String complitedCallback;
	File tmpDir = new File(PortalProperties.fileBase + "/download/");
	// File tmpDir= new File(LMProperties.fileBase+"/download/");
	// ArrayList urls=new ArrayList();
	ArrayDeque<URL> urls = new ArrayDeque<URL>();
	ArrayDeque<String> keys = new ArrayDeque<String>();
	Download down = new Download();
	
	boolean isFinished=false;
	public AsyncDownload()
	{
		if (!tmpDir.exists())
			tmpDir.mkdirs();
	}
	public AsyncDownload(String url)
	{
		this();
		addUrl(url);
	}
	
	public static AsyncDownload create()
	{
		return new AsyncDownload();
	}
	public static AsyncDownload create(String url)
	{
		return new AsyncDownload(url);
	}
	
	public void setDestination(String despath)
	{
		tmpDir=new File(despath);
		if (!tmpDir.exists())
			tmpDir.mkdirs();
	}
	public void start()
	{
		
		Thread t = new Thread(down);
		t.start();
	}
	public void receive()
	{
		while(!isFinished)
		{
			try
			{
				Thread.sleep(1000);
			} catch (InterruptedException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	public void addUrl(String url)
	{
		addUrl_forKey(url,"");
	}
	public void addUrl_forKey( String url,String key)
	{
		try
		{
			String encodedUrl=URLEncoder.encode(url, "UTF-8");
			URL mUrl = new URL(url);
			urls.add(mUrl);
			keys.add(key);
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void setProcessingCallback(String callback)
	{
		this.processingCallback=callback;
	}
	public void setComplitedCallback(String callback)
	{
		this.complitedCallback=callback;
	}
	
	public void setProgressBar(IProgressBar bar)
	{
		this.bar = bar;
	}
	public void setProgressBar(String barId)
	{
		
		this.bar = (IProgressBar)(LuaContext.getInstance().getObject(barId));
	}

	public void setTotalProgressBar(IProgressBar bar)
	{
		this.barTotal = bar;
	}
	
	public void setTotalProgressBar(String barId)
	{
		this.barTotal = (IProgressBar)(LuaContext.getInstance().getObject(barId));
	}

	private class Download implements Runnable
	{
		int processedFileCount = 0;
		int total = 0;
		int process = 0;
		int state = 0;
		String err = "";
		URL currentUrl;
		String key;
		File currentFile;

		@Override
		public void run()
		{
			UIMessage msg=new UIMessage();
			currentUrl = urls.poll();
			key=keys.poll();
			while (currentUrl != null)
			{
				InputStream isread = null;
				FileOutputStream fos = null;
				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					System.out.println("start to download file:"+currentUrl.getPath());
					urlConn = (HttpURLConnection) currentUrl.openConnection();
					urlConn.setConnectTimeout(10000);
					InputStream in = urlConn.getInputStream();
					// isread = UIFactory.getInputStreamFromUrl(ac);
					
					String fn=null;
					
					String disposition= urlConn.getHeaderField("Content-Disposition");
		             String[] ps=disposition.split(";");
		             for(String p:ps)
		             {
		                 String head=p.trim();
		                if(head.toLowerCase().startsWith("filename"))
		                {
		                    fn=(head.substring(10,head.length()-1));
		                    break;
		                }
		             }
		             
		             if(fn==null)
		             {
						String path = currentUrl.getPath();
						String filePath = path.substring(path.lastIndexOf('/') + 1,path.length());
						//int point = filePath.lastIndexOf('.');
						//String fileName =filePath.substring(0, point);
						//String fileExt = filePath.substring(point + 1,filePath.length());
						//currentFile = new File(tmpDir.getAbsolutePath() + "/" + fileName + "." + fileExt);
						//fn=fileName + "." + fileExt;
						fn=filePath;
		             }
		            int point = fn.lastIndexOf('.');
		            String fileName =fn.substring(0, point);
					String fileExt = fn.substring(point + 1,fn.length());
						
					currentFile = new File(tmpDir.getAbsolutePath() + "/" + fn);
					int i = 1;
					while (currentFile.exists())
					{
						currentFile = new File(tmpDir.getAbsolutePath() +"/" + fileName + "[" + i++ + "]." + fileExt);
					}
					System.out.println("local file:"+currentFile.getPath());
					fos = new FileOutputStream(currentFile);

					int count = 0;
					total = urlConn.getContentLength();
					state = 1;
					
					while (-1 != (count = in.read(bs)))
					{
						//System.out.println("Total:"+total+"; read bytes:"+count);
						fos.write(bs, 0, count);
						process += count;
						if (bar != null)
						{
							int percent = (int) ((1.0d * process / total) * 100);
							bar.setValue(percent);
						}
						if(processingCallback!=null)
						{
//							LuaContext.getInstance().doString(processingCallback);
							/*
							LuaState lua=LuaContext.getInstance().getLuaState();
	                		lua.getField(LuaState.LUA_GLOBALSINDEX, processingCallback);
	                		lua.pushNumber(state);
	                		lua.pushNumber(total);
	                		lua.pushNumber(process);
	                		lua.pushString(currentUrl.getHost()+"/"+currentUrl.getPath());
	                		lua.pushString(currentFile.getAbsolutePath());
	                		 
	                		 lua.call(5,0);
	                		 */
							String callback=processingCallback.trim();
							//find the last char")"
							int pos=callback.lastIndexOf(')');
							callback=callback.substring(0, pos);
							String luaCallback=callback;
							if(pos>0)
							{
							luaCallback+=","+state+","+total+","+process+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"','"+key+"')";
							}
							else
							{
								luaCallback+=state+","+total+","+process+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"','"+key+"')";
								
							}
							msg.updateMessage(luaCallback);
							
							msg.updateMessage(luaCallback);
	                		 
//	                		// save returned value to param "result"   
//	                	        lua.setField(LuaState.LUA_GLOBALSINDEX, "result");   
//	                	        // read result
//	                	        LuaObject lobj =lua.getLuaObject("result"); 
	                	        
						}
						if(process>102400)fos.flush();
						Thread.sleep(50);
					}

					fos.flush();
					fos.close();
//					Bitmap img=returnBitMap(currentUrl.toString());

				} catch (Exception e1)
				{
					err = e1.toString();
					state = -1;
					e1.printStackTrace();
				} finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (isread != null)
					{
						try
						{
							isread.close();

						} catch (IOException e)
						{
						}
					}
					if (fos != null)
					{
						try
						{
							fos.close();

						} catch (IOException e)
						{
						}
					}
			
					state = 2;
				}
				processedFileCount++;
				if (barTotal != null)
				{
					int percent = (int) ((1.0d * processedFileCount / (processedFileCount+urls.size())) * 100);
					barTotal.setValue(percent);
				}
				if(complitedCallback!=null)
				{
					
//					LuaContext.getInstance().doString(complitedCallback);
					/*
					LuaState lua=LuaContext.getInstance().getLuaState();
            		lua.getField(LuaState.LUA_GLOBALSINDEX, complitedCallback);
            		lua.pushNumber(processedFileCount+urls.size());
            		lua.pushNumber(processedFileCount);
            		lua.pushString(currentUrl.getHost()+"/"+currentUrl.getPath());
            		lua.pushString(currentFile.getAbsolutePath());
            	    lua.call(4,0);
            	    */
					String callback=complitedCallback.trim();
					//find the last char")"
					int pos=callback.lastIndexOf(')');
					callback=callback.substring(0, pos);
					String luaCallback=callback;
					if(pos>0)
					{
					luaCallback+=","+(processedFileCount+urls.size())+","+processedFileCount+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"','"+key+"')";
					}
					else
					{
						luaCallback+=(processedFileCount+urls.size())+","+processedFileCount+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"','"+key+"')";
						
					}
					
//            	    String luaCallback=complitedCallback+"("+(processedFileCount+urls.size())+","+processedFileCount+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"','"+key+"')";
            	    msg.updateMessage(luaCallback);
				}
				try
				{
					Thread.sleep(100);
				} catch (InterruptedException e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
				total = 0;
				 process = 0;
				 state = 0;
				 err = "";
				 currentFile=null;
				
				currentUrl = urls.poll();
				key=keys.poll();
				
			}
			isFinished=true;
			System.out.println("end download..");
		}
		
	}
	
	/**
	 * -1:error,0: prepare,1: downloading, 2: complited
	 * 
	 * @return
	 */
	public int getState()
	{
		return down.state;
	}

	public String getError()
	{
		return down.err;
	}

	public int getTotalSize()
	{
		return down.total;
	}

	public int getValue()
	{
		return down.process;
	}

	public String getUrl()
	{
		if (down.currentUrl != null)
			return down.currentUrl.getPath();
		else
			return "";
	}
	
	public String getFilename()
	{
		if (down.currentFile != null)
			return down.currentFile.getAbsolutePath();
		else
			return "";
	}
	public static Bitmap returnBitMap(String url)
	{

		URL myFileUrl = null;
		Bitmap bitmap = null;

		try
		{
			myFileUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) myFileUrl
					.openConnection();
			conn.setDoInput(true);
			conn.connect();
			InputStream is = conn.getInputStream();
			Options opts = new Options(); 
			opts.inSampleSize = 4;
			bitmap = BitmapFactory.decodeStream(is);
			is.close();
			conn.disconnect();
			
		} catch (IOException e)
		{
			e.printStackTrace();
		}
		return bitmap;
	}
}


/*多线程断点下载

public class DownloadNetTest { 
private File fileOut; 
private URL url; 
private long fileLength=0; 
//初始化线程数 
private int ThreadNum=5; 

public DownloadNetTest(){ 
try{ 
   System.out.println("正在链接URL"); 
   url=new URL("http://211.64.201.201/uploadfile/nyz.mp3"); 
   HttpURLConnection urlcon=(HttpURLConnection)url.openConnection(); 
   //根据响应获取文件大小
   fileLength=urlcon.getContentLength(); 
   if(urlcon.getResponseCode()>=400){ 
   System.out.println("服务器响应错误"); 
   System.exit(-1); 
   } 
   if(fileLength<=0) 
   System.out.println("无法获知文件大小"); 
   //打印信息 
   printMIME(urlcon); 
   System.out.println("文件大小为"+fileLength/1024+"K"); 
   //获取文件名 
   String trueurl=urlcon.getURL().toString(); 
   String filename=trueurl.substring(trueurl.lastIndexOf('/')+1); 
   fileOut=new File("D://",filename); 
} 
catch(MalformedURLException e){ 
   System.err.println(e); 
} 
catch(IOException e){ 
   System.err.println(e); 
} 
init(); 
} 
private void init(){ 
   DownloadNetThread [] down=new DownloadNetThread[ThreadNum]; 
try { 
   for(int i=0;i<ThreadNum;i++){ 
      RandomAccessFile randOut=new RandomAccessFile(fileOut,"rw"); 
      randOut.setLength(fileLength); 
      long block=fileLength/ThreadNum+1; 
      randOut.seek(block*i); 
      down[i]=new DownloadNetThread(url,randOut,block,i+1); 
      down[i].setPriority(7); 
      down[i].start(); 
   } 
//循环判断是否下载完毕 
boolean flag=true; 
while (flag) { 
   Thread.sleep(500); 
   flag = false; 
   for (int i = 0; i < ThreadNum; i++) 
   if (!down[i].isFinished()) { 
   flag = true; 
   break; 
   } 
}// end while 
System.out.println("文件下载完毕，保存在"+fileOut.getPath() );
} catch (FileNotFoundException e) { 
      System.err.println(e); 
      e.printStackTrace(); 
} 
catch(IOException e){ 
   System.err.println(e); 
   e.printStackTrace(); 
} 
catch (InterruptedException e) { 
System.err.println(e); 
} 

} 
private void printMIME(HttpURLConnection http){ 
for(int i=0;;i++){ 
String mine=http.getHeaderField(i); 
if(mine==null) 
return; 
System.out.println(http.getHeaderFieldKey(i)+":"+mine); 
} 
} 

public static void main(String[] args) { 
    DownloadNetTest app=new DownloadNetTest(); 
} 

} 


//线程类
public class DownloadNetThread extends Thread{ 
private InputStream randIn; 
private RandomAccessFile randOut; 
private URL url; 
private long block; 
private int threadId=-1; 
private boolean done=false; 

public DownloadNetThread(URL url,RandomAccessFile out,long block,int threadId){ 
this.url=url; 
this.randOut=out; 
this.block=block; 
this.threadId=threadId; 
} 
public void run(){ 
try{ 
   HttpURLConnection http=(HttpURLConnection)url.openConnection(); 
   http.setRequestProperty("Range","bytes="+block*(threadId-1)+"-"); 
   randIn=http.getInputStream(); 
} 
catch(IOException e){ 
   System.err.println(e); 
} 

//////////////////////// 
byte [] buffer=new byte[1024]; 
int offset=0; 
long localSize=0; 
System.out.println("线程"+threadId+"开始下载"); 
try { 
   while ((offset = randIn.read(buffer)) != -1&&localSize<=block) { 
   randOut.write(buffer,0,offset); 
   localSize+=offset; 
   } 
   randOut.close(); 
   randIn.close(); 
   done=true; 
   System.out.println("线程"+threadId+"完成下载"); 
   this.interrupt(); 
} 
catch(Exception e){ 
   System.err.println(e); 
} 
} 
public boolean isFinished(){ 
  return done; 
} 
}


*/