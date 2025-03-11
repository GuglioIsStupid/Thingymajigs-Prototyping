local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()
end

function love.conf(t)
    t.console = true
    t.window.title = "Thingymajigs" .. (IS_DEBUG and " - Debug" or "")
    t.window.width = 1280
    t.window.height = 720

    t.version = "11.5"
end
