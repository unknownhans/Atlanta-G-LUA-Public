
local UI                    = UI                or {}

UI.Constants                = UI.Constants      or {}
UI.Config                   = UI.Config         or {}
UI.Fonts                    = UI.Fonts          or {}
UI.Colours                  = UI.Colours        or {}
UI.Materials                = UI.Materials      or {}
UI.Themes                   = UI.Themes         or {}
UI.Draw                     = UI.Draw           or {}
UI.Functions                = UI.Functions      or {}
UI.Elements                 = UI.Elements       or {}

UI.Constants.Version        = "1.0.0"
UI.Constants.Date           = os.date( "%b %d %Y", os.time() )
UI.Constants.EaseOutExpo    = function() return math.ease.OutExpo( FrameTime() * ( UI.Config.AnimSpeed ) ) end

UI.Config.AnimSpeed         = 2

UI.Fonts.CurrentFont        = "Minecraft"

UI.Colours.Accent           = nil
UI.Colours.Contrast         = nil
UI.Colours.Contrast2        = nil
UI.Colours.Text             = nil
UI.Colours.Text2            = nil
UI.Colours.Text3            = nil
UI.Colours.Inline           = nil
UI.Colours.Outline          = nil
UI.Colours.OutlineAMed      = nil
UI.Colours.OutlineALow      = nil
UI.Colours.Gradient         = nil

UI.Materials.gradientup     = Material( "vgui/gradient-u" )
UI.Materials.gradientdown   = Material( "vgui/gradient-d" )
UI.Materials.gradientleft   = Material( "vgui/gradient-l" )
UI.Materials.Gradientright  = Material( "vgui/gradient-r" )
UI.Materials.alphagrid      = Material( "gui/alpha_grid.png", "nocull" )

-- UI.Themes -----------------------------------------------------------------------------------------------------------------------------------
    UI.Themes.Dracula   = {

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

    }

    UI.Themes.Temple    = {

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

    }

    UI.Themes.Atlanta   = {

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

    }

    UI.Themes.SwitchTheme = function( theme )
        local Theme = UI.Themes[ theme ]

        if not Theme then return end

        for i, v in pairs( Theme ) do
            UI.Colours[ i ] = v
        end

        UI.Colours.OutlineALow = ColorAlpha(UI.Colours.OutlineAMed, 33)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
-- Fetching Icons ------------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------
-- UI.Draw -------------------------------------------------------------------------------------------------------------------------------------
    UI.Draw.AccentBar = function( x, y, w )
        surface.SetDrawColor( UI.Colours.Accent )
        --// top part
        surface.SetMaterial( UI.Materials.gradientdown )
        surface.DrawTexturedRect( x, y, w, 2 )
        --// bottom part
        surface.SetMaterial( UI.Materials.gradientup )
        surface.DrawTexturedRect( x, y + 2, w, 2 )
    end

    UI.Draw.ContrastBox = function( x, y, w, h )
        --// outline
        surface.SetDrawColor( UI.Colours.Outline )
        surface.DrawOutlinedRect(x, y, w, h)
        --// inline
        surface.SetDrawColor( UI.Colours.Inline )
        surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2 )
        --// main frame
        surface.SetDrawColor( UI.Colours.Contrast )
        surface.DrawRect( x + 2, y + 2, w - 4, h - 4 )
    end

    UI.Draw.Contrast2Box = function( x, y, w, h )
        --// outline
        surface.SetDrawColor( UI.Colours.Inline )
        surface.DrawOutlinedRect(x, y, w, h )
        --// inline
        surface.SetDrawColor( UI.Colours.Outline )
        surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2 )
        --// main frame
        surface.SetDrawColor( UI.Colours.Contrast2 )
        surface.DrawRect( x + 2, y + 2, w - 4, h - 4 )
    end

    UI.Draw.Gradient = function( x, y, w, h )
        --// gradient
        surface.SetDrawColor( UI.Colours.OutlineALow )
    end
------------------------------------------------------------------------------------------------------------------------------------------------
-- setting fonts -------------------------------------------------------------------------------------------------------------------------------
    do
        if !file.Exists("resource/fonts/Minecraft.ttf", "GAME") then
            print("[ATL] Minecraft font not found, defaulting to Tahoma")
        end
        surface.CreateFont( "Minecraft",   { font = "Minecraft",    size = 13, antialias = false, outline = true } )
        surface.CreateFont( "Minecraft10", { font = "Minecraft",    size = 10, antialias = false, outline = true } )
        surface.CreateFont( "Minecraft16", { font = "Minecraft",    size = 16, antialias = false, outline = true } )


    end
------------------------------------------------------------------------------------------------------------------------------------------------
UI.Themes.SwitchTheme( "Temple" )