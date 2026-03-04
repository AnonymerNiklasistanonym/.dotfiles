local placeholderId = "xoppFilename"

local function getDocumentPath()
    local docStruct = app.getDocumentStructure()
    local path = docStruct["xoppFilename"]

    print("Metatable of metatable keys:")
    for k, v in pairs(docStruct) do
        print(k, v)
    end

    if path then
        if path ~= "" then
            return path
        else
            return "<unsaved document>"
        end
    end
    return nil
end

function initUi()
    -- register menu bar entry and toolbar icon
    app.registerUi({
        ["menu"] = "Check Document", -- menu bar entry/tooltip text
        ["callback"] = "run", -- function to run on click
        ["toolbarId"] = "CHECK_DOCUMENT_SHORTCUT", -- toolbar ID
        ["iconName"] = "xopp-tool-pencil", -- the icon ID
    })

    local path = getDocumentPath()
    if path then
        print("xoppFilename exists: '" .. path .. "'")
    else
        print("xoppFilename does not exist")
    end
    app.registerPlaceholder(placeholderId, path or "none")
    app.addEventListener("documentChanged", "run")
end

function run()
    local path = getDocumentPath()
    if path then
        print("xoppFilename exists: '" .. path .. "'")
        app.setPlaceholderValue(placeholderId, path)
    else
        print("xoppFilename does not exist")
    end
end
