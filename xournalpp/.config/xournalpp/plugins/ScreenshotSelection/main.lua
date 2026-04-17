local windowsScreenshotCommand = "explorer.exe ms-screenclip:"
local linuxScreenshotCommandSpectacleGui =
    "spectacle --region --no-shadow --nonotify --copy-image"
local linuxScreenshotCommandSpectacle = linuxScreenshotCommandSpectacleGui .. " --background"
-- the full spectacle launcher
-- local linuxScreenshotCommandSpectacleLauncher = "spectacle --no-shadow --nonotify --background --launchonly"
-- flameshot has problems with multi monitor setups on Wayland
-- local linuxScreenshotCommandFlameshot = "flameshot gui"

function initUi()
    -- register menu bar entry and toolbar icon
    app.registerUi({
        ["menu"] = "Make screenshot of selection", -- menu bar entry/tooltip text
        ["callback"] = "run", -- function to run on click
        ["toolbarId"] = "SCREENSHOT_SELECTION_SHORTCUT", -- toolbar ID
        ["iconName"] = "icon-screenshot-selection", -- the icon ID
    })
    -- register additional menu bar entry and toolbar icon
    if package.config:sub(1, 1) ~= "\\" then
        app.registerUi({
            ["menu"] = "Make screenshot of selection (GUI)", -- menu bar entry/tooltip text
            ["callback"] = "run_gui", -- function to run on click
            ["toolbarId"] = "SCREENSHOT_SELECTION_GUI_SHORTCUT", -- toolbar ID
            ["iconName"] = "icon-screenshot-selection", -- the icon ID
        })
    end
end

local function run_screenshot_command(command)
    print("Run screenshot command: '" .. command .. "'")
    local _, _, exitCode = os.execute(command)
    if exitCode ~= 0 then
        print("Screenshot command failed with exit code: " .. tostring(exitCode))
    end
end

function run()
    local command
    -- determine platform and set the appropriate screenshot command
    if package.config:sub(1, 1) ~= "\\" then
        command = linuxScreenshotCommandSpectacle
    else
        command = windowsScreenshotCommand
    end
    run_screenshot_command(command)
end

function run_gui()
    run_screenshot_command(linuxScreenshotCommandSpectacleGui .. " &")
end
