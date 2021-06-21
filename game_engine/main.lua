-- A list of paths to lua scrip modules
local paths = {
    '{root}/{module}',
    '{root}/lib/{module}',
    '{root}/lib/external/{module}',
    '{root}/lib/external/platform-specific/{platform}/{module}',
}

-- A list of paths to binary lua modules
local module_paths = {
    '?.{extension}',
    '?/init.{extension}',
    '?/core.{extension}',
}

-- List of supported os paired with binary file extension name
local extensions = {
    Windows = 'dll',
    Linux = 'so',
    Mac = 'dylib',
}

-- os_name is a supplemental module for
-- OS and CPU architecture detection
local os_name = require 'os_name'

-- A dot character represent current working directory
local root_dir = '.'
local current_platform, current_architecture = os_name.getOS()

local cpaths, lpaths = {}, {}
local current_clib_extension = extensions[current_platform]

-- checking if the current platform had defined binary module extensions
if current_clib_extension then
    -- Now you can process each defined path for module.
    for _, path in ipairs(paths) do
        local path = path:gsub("{(%w+)}", {
            root = root_dir,
            platform = current_platform,
        })
        --Skip empty path entries
        if #path > 0 then
            -- Make a substitution for each module file path.
            for _, raw_module_path in ipairs(module_paths) do
                local module_path = path:gsub("{(%w+)}", {
                    module = raw_module_path
                })
                -- Add path for binary module.
                cpaths[#cpaths + 1] = module_path:gsub("{(%w+)}", {
                    extension = current_clib_extension
                })
                -- Add paths for platform independent lua luac modules
                lpaths[#paths + 1] = module_path:gsub("{(%w+)}", {
                    extension = 'lua'
                })
                lpaths[#lpaths + 1] = module_path:gsub("{(%w+)}", {
                    extension = 'luac'
                })
            end
        end
    end
    -- Build module path list delimited with semicolon.
    package.path = table.concat(lpaths, ";")
    package.cpath = table.concat(cpaths, ";")
end












