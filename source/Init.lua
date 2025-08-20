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