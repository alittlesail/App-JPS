-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.JPS == nil then _G.JPS = {} end
local JPS = JPS
local Lua = Lua
local ALittle = ALittle
local ___pairs = pairs
local ___ipairs = ipairs


function JPS.__Browser_Setup(layer_group, control, module_base_path, script_base_path, debug)
	local window_width, window_height, flag, scale = ALittle.System_CalcLandscape(1200, 600, 0)
	ALittle.System_CreateView("JPS", window_width, window_height, flag, scale)
	ALittle.System_SetViewIcon(module_base_path .. "/Other/ic_launcher.png")
	A_ModuleSystem:LoadModule(module_base_path, "JPS")
end
JPS.__Browser_Setup = Lua.CoWrap(JPS.__Browser_Setup)

function JPS.__Browser_AddModule(module_name, layer_group, module_info)
end

function JPS.__Browser_Shutdown()
end

JPS.g_Control = nil
JPS.g_LayerGroup = nil
JPS.g_ModuleBasePath = nil
JPS.g_AUIPluginControl = nil
function JPS.__Module_Setup(layer_group, control, module_base_path, script_base_path, debug)
	JPS.g_Control = control
	JPS.g_LayerGroup = layer_group
	JPS.g_ModuleBasePath = module_base_path
	JPS.g_AUIPluginControl = A_ModuleSystem:LoadPlugin("AUIPlugin")
	Require(script_base_path, "GCenter")
	g_GCenter:Setup()
end
JPS.__Module_Setup = Lua.CoWrap(JPS.__Module_Setup)

function JPS.__Module_Shutdown()
	g_GCenter:Shutdown()
end

function JPS.__Module_GetInfo(control, module_base_path, script_base_path)
	local info = {}
	info.title = "JPS"
	info.icon = nil
	info.width_type = 4
	info.width_value = 0
	info.height_type = 4
	info.height_value = 0
	return info
end

end