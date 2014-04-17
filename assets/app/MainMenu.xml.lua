function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('To UTF8 Char','........')
	Log:d('To UTF8 Char',str:toUTF6LE('230,00'))
	--addUIWedgit()
end

function addUIWedgit()
	 Log:d("UI Test","addUIWedgit")
	 viewStr="<div layout='LinearLayout'  style='orientation:vertical;width:80px;align:center;background-color:#00EF00'><label>asd</label><label>asd2</label><button>btn</button></div>"
	 --viewStr="<label>asd</label>"
	 view=ui:createView(viewStr)
	 Log:d("UI Test","id="..view)
	 free_area:addView(view)
	 Log:d("UI Test","view was added")
end

function switch()
	Log:d("UI","switch to Study View ")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end
function reload()
	 Log:d("reload","MainMenu Lua reload is executed..")
	 sys.reload()
end

function showFirstStudyView()
	ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
end
function showReviewInfo()
	ui:switchView("ReviewInfo.xml","callback('file opener returned param')","file opener params")
end
function test()
	--[[
	rootPath=FileConnector:getSDRoot()
	Log:d("File test",rootPath)
	filesStr=FileConnector:listFiles(Global.storage)
	Log:d("File test",filesStr)
	files=loadstring('return {'..filesStr..'}')()



	for i,row in ipairs(files) do
	  local file=createTableRow(row)
		Log:d("File test",file.name)
	end
	]]
	local o = io.open("/sdcard/test/IELTSCore3000.dbx", 'wb+')
	o:write(1)
	o:write("test")
	o:close()
	--[[
	Log:d("File test","read file:/sdcard/test/ITIES1228.dbx")
	local f = io.open("/sdcard/test/ITIES1228.dbx", 'rb+')
	Log:d("File test","open file successful")
	local line=f:read("*n")
	Log:d("File test","line="..line)
	f:close()


	local index = WordIndex.new(self)
	index.open("/sdcard/test/ITIES1228.dbx")
	local wordPos= index.getPos(1)
	for i=1, 6, 1 do
		Log:d("Word Index","word pos="..wordPos[i])
	end

	]]

end


function create()
	Log:d("Player","start")
    Log:d("Player","URL="..OLA.base..'yellow_submarine.mp3')
	soundPlayer=MediaPlayer:createPlayer(OLA.base..'yellow_submarine.mp3')

	Log:d("Player","created")
	soundPlayer:play()
	Log:d("Player","playing")
end

function pause()
	soundPlayer:pause()
end
function stop()
	soundPlayer:stop()
end


function dialogBtnTest()
	Log:d("dialogBtnTest","running.......")
end

function testDialog()
		--local viewStr="<div id='dialog' layout='LinearLayout'  style='padding:20px;orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.5;background-color:#00EF00'><label>asd</label><textfield  id=\"Next_Group\" style=\"width:auto;text-align:left;valign:middle\">0</textfield><button onclick='reload()' style='padding:3px;'>Reload</button><button onclick='close()' style='background-color:#0000ff;background-image:url(images/blue_velvet_029.png)'>Close</button></div>"
		local viewStr="<button onclick='close()' style='background-color:#0000ff;background-image:url(images/blue_velvet_029.png)'>Close</button>"
		local view=ui:createView(viewStr)
		--local alert = Alert:create()
		--alert:show()
		--alert:setContentView(view)
		body:addView(view)

end
Log:d("test Global","Global.volumeLevel=")
Log:d("test Global","Global.volumeLevel="..Global.volumeLevel)