local UI        = UI                or {}

UI.Constants    = UI.Constants      or {}
UI.Vars         = UI.Vars           or {}
UI.Config       = UI.Config         or {}
UI.Fonts        = UI.Fonts          or {}
UI.Colours      = UI.Colours        or {}
UI.Materials    = UI.Materials      or {}
UI.Themes       = UI.Themes         or {}
UI.Draw         = UI.Draw           or {}
UI.Functions    = UI.Functions      or {}
UI.Elements     = UI.Elements       or {}

-- UI.Constants ---------------------------------------------------------------------------------------------------------------------------------
    UI.Constants = {
        ["Version"] = "1.0.0",
        ["Date"]    = os.date( "%b %d %Y", os.time() ),
        ["LocalPlayer"] = LocalPlayer(),
    }
-- UI.Vars --------------------------------------------------------------------------------------------------------------------------------------
    UI.Vars = {
        ["grabbing"] = false,
    }
-- UI.Config ------------------------------------------------------------------------------------------------------------------------------------
    UI.Config = {
        ["EaseType"]  = "OutExpo",
        ["AnimSpeed"] = 2,
    }
-- UI.Fonts ------------------------------------------------------------------------------------------------------------------------------------
    UI.Fonts = {
        ["CurrentFont"] = "Minecraft",
    }
-- UI.Colours ----------------------------------------------------------------------------------------------------------------------------------
    UI.Colours = {
        ["Accent"]      = nil,
        ["Contrast"]    = nil,
        ["Contrast2"]   = nil,
        ["Text"]        = nil,
        ["Text2"]       = nil,
        ["Text3"]       = nil,
        ["Inline"]      = nil,
        ["Outline"]     = nil,
        ["OutlineAMed"] = nil,
        ["OutlineALow"] = nil,
        ["Gradient"]    = nil,
    }
-- UI.Materials --------------------------------------------------------------------------------------------------------------------------------
    UI.Materials = {
        ["gradientup"]     = Material( "vgui/gradient-u" ),
        ["gradientdown"]   = Material( "vgui/gradient-d" ),
        ["gradientleft"]   = Material( "vgui/gradient-l" ),
        ["gradientright"]  = Material( "vgui/gradient-r" ),
        ["alphagrid"]      = Material( "gui/alpha_grid.png", "nocull" ),
    }
-- UI.Themes -----------------------------------------------------------------------------------------------------------------------------------
    UI.Themes = {
        ["Dracula"] = {
            Accent      = Color( 130, 107, 149, 255 ),
            Contrast    = Color(  42,  42,  56, 255 ),
            Contrast2   = Color(  36,  36,  48, 255 ),
            Text        = Color( 155, 125, 175, 255 ),
            Text2       = Color( 150, 150, 150, 255 ),
            Text3       = Color( 100, 100, 100, 255 ),
            Inline      = Color(  60,  55,  75, 255 ),
            Outline     = Color(  30,  30,  36, 255 ),
            OutlineAMed = Color(  30,  30,  36, 175 ),
            OutlineALow = Color(  30,  30,  36,  33 ),
            Gradient    = Color(  44,  44,  56, 150 ),
        },
        ["Temple"]  = {
            Accent      = Color(  98, 117, 180, 255 ),
            Contrast    = Color(  34,  34,  34, 255 ),
            Contrast2   = Color(  30,  30,  30, 255 ),
            Text        = Color(  84, 116, 165, 255 ),
            Text2       = Color( 180, 180, 180, 255 ),
            Text3       = Color( 150, 150, 150, 255 ),
            Inline      = Color(  54,  54,  54, 255 ),
            Outline     = Color(   0,   0,   0, 255 ),
            OutlineAMed = Color(   0,   0,   0, 100 ),
            OutlineALow = Color(   0,   0,   0,  33 ),
            Gradient    = Color(  38,  38,  38, 150 ),
        },
        ["Atlanta"] = {
            Accent      = Color( 155,  30,  80, 255 ),
            Contrast    = Color(  30,   6,  16, 255 ),
            Contrast2   = Color(  26,   5,  14, 255 ),
            Text        = Color(  94,  13,  45, 255 ),
            Text2       = Color( 197, 197, 197, 255 ),
            Text3       = Color( 150, 150, 150, 255 ),
            Inline      = Color(  38,   9,  21, 255 ),
            Outline     = Color(  30,   6,  16, 255 ),
            OutlineAMed = Color(  30,   6,  16, 175 ),
            OutlineALow = Color(  30,   6,  16,  33 ),
            Gradient    = Color(  44,   9,  21, 150 ),
        },
    }
-- UI.Draw -------------------------------------------------------------------------------------------------------------------------------------
    UI.Draw = {
        ["AccentBar"] = function(x, y ,w)
            surface.SetDrawColor( UI.Colours.Accent )
            --// top part
            surface.SetMaterial( UI.Materials.gradientdown )
            surface.DrawTexturedRect( x, y, w, 2 )
            --// bottom part
            surface.SetMaterial( UI.Materials.gradientup )
            surface.DrawTexturedRect( x, y + 2, w, 2 )
        end,
        ["ContrastBox"] = function(x, y, w, h)
            --// outline
            surface.SetDrawColor( UI.Colours.Outline )
            surface.DrawOutlinedRect(x, y, w, h)
            --// inline
            surface.SetDrawColor( UI.Colours.Inline )
            surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2 )
            --// main frame
            surface.SetDrawColor( UI.Colours.Contrast )
            surface.DrawRect( x + 2, y + 2, w - 4, h - 4 )
        end,
        ["Contrast2Box"] = function(x, y, w, h)
            --// outline
            surface.SetDrawColor( UI.Colours.Inline )
            surface.DrawOutlinedRect(x, y, w, h )
            --// inline
            surface.SetDrawColor( UI.Colours.Outline )
            surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2 )
            --// main frame
            surface.SetDrawColor( UI.Colours.Contrast2 )
            surface.DrawRect( x + 2, y + 2, w - 4, h - 4 )
        end,
        ["Gradient"] = function(x, y, w, h)

        end,
    }
-- UI.Functions --------------------------------------------------------------------------------------------------------------------------------
    UI.Functions = {
        ["Lerp"] = function( from, to )
            return Lerp(math.ease[UI.Config.EaseType](FrameTime() * UI.Config.AnimSpeed), from, to)
        end,
        ["SwitchTheme"] = function( theme )
            local Theme = UI.Themes[ theme ]

            if not Theme then return end

            for k, v in pairs( Theme ) do
                UI.Colours[ k ] = v
            end

            UI.Colours.OutlineALow = ColorAlpha(UI.Colours.OutlineAMed, 33)
        end,
        ["screenpanic"] = function()
            if UI.Vars.grabbing then return end
            UI.Vars.grabbing = true

            render.Clear( 0, 0, 0, 255, true, true)

            render.RenderView( {
                origin = UI.Constants.LocalPlayer:EyePos(),
                angles = UI.Constants.LocalPlayer:EyeAngles(),
                x = 0,
                y = 0,
                w = scrw,
                h = scrh,
                dopostprocess = true,
                drawhud = true,
                drawmonitors = true,
                drawviewmodel = true
            } )

            UI.Vars.grabbing = false
        end,
    }
-- UI.Elements ---------------------------------------------------------------------------------------------------------------------------------
    do
        
    end
-- Screengrab stuff ----------------------------------------------------------------------------------------------------------------------------
    do
        local rendercap = _G.render.Capture
        function render.Capture( data )
            UI.Functions.screenpanic()
            return rendercap( data )
        end
    end
-- Fetching icons ------------------------------------------------------------------------------------------------------------------------------
    do
        if !file.Exists( "atlanta", "DATA" ) then
            print( "[ATL] No data/atlanta directory, creating one ..." .. '\n' )
            file.CreateDir( "atlanta" )
        end

        local materials = "https://api.github.com/repos/unknownhans/Atlanta-G-Lua-Public/contents/source/ressources/materials"
        
        http.Fetch( materials,
            -- success
            function( body )
                local success, icons = pcall( util.JSONToTable, body )
                if not success or not icons or ( icons.status == "404" ) then print( "[ATL] Failed to parse GitHub API response" ) return end

                local delay = 0
                
                for _, icon in pairs( icons ) do
                    timer.Simple( delay, function()
                        if !file.Exists( "atlanta/" .. icon.name, "DATA" ) then
                            print( "[ATL] No " .. icon.name .. ", fetching ..." )

                            http.Fetch( icon.download_url,
                                -- success
                                function( body )
                                    if !file.Write( "atlanta/" .. icon.name, body ) then
                                        print( "[ATL] Failed to write " .. icon.name )
                                        return
                                    end

                                    print( "[ATL] Created " .. icon.name .. " (data/atlanta)" .. '\n' )
                                end,
                                -- failure
                                function( err )
                                    print( "[ATL] Failed to fetch " .. icon.name )
                                    print( "[ATL] Error : " .. err .. '\n' )
                                end
                            )
                        end

                        timer.Simple(0.5, function() 
                            UI.Materials[ icon.name ] = Material( "data/atlanta/" .. icon.name ) 
                        end )

                    end )

                    delay = delay + 0.5
                end
            end,
            function( err )
                print( "[ATL] Failed to fetch materials folder" )
                print( "[ATL] Error : " .. err .. '\n' )
            end
        )
    end
-- Setting fonts -------------------------------------------------------------------------------------------------------------------------------
    do
        if !file.Exists("resource/fonts/Minecraft.ttf", "GAME") then

            print("[ATL] Minecraft font not found, defaulting to Tahoma")
            surface.CreateFont( "Minecraft",   { font = "Tahoma",    size = 13, antialias = false, outline = true } )
            surface.CreateFont( "Minecraft10", { font = "Tahoma",    size = 10, antialias = false, outline = true } )
            surface.CreateFont( "Minecraft16", { font = "Tahoma",    size = 16, antialias = false, outline = true } )
        else
            surface.CreateFont( "Minecraft",   { font = "Minecraft",    size = 13, antialias = false, outline = true } )
            surface.CreateFont( "Minecraft10", { font = "Minecraft",    size = 10, antialias = false, outline = true } )
            surface.CreateFont( "Minecraft16", { font = "Minecraft",    size = 16, antialias = false, outline = true } )
        end

    end

