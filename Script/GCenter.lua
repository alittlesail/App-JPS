-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.JPS == nil then _G.JPS = {} end
local JPS = JPS
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


JPS.g_GConfig = nil
JPS.GCenter = Lua.Class(nil, "JPS.GCenter")

function JPS.GCenter:Ctor()
	___rawset(self, "_start_x", 0)
	___rawset(self, "_start_y", 0)
	___rawset(self, "_end_x", 0)
	___rawset(self, "_end_y", 0)
	___rawset(self, "_grid_len", 30)
	___rawset(self, "_grid_frame", 2)
	___rawset(self, "_map_width", 0)
	___rawset(self, "_map_height", 0)
end

function JPS.GCenter:Setup()
	JPS.g_GConfig = ALittle.CreateConfigSystem(JPS.g_ModuleBasePath .. "/User.cfg")
	ALittle.Math_RandomSeed(ALittle.Time_GetCurTime())
	ALittle.System_SetThreadCount(1)
	self._main_layer = ALittle.DisplayLayout(JPS.g_Control)
	self._main_layer.width_type = 4
	self._main_layer.height_type = 4
	JPS.g_LayerGroup:AddChild(self._main_layer, nil)
	self._dialog_layer = ALittle.DisplayLayout(JPS.g_Control)
	self._dialog_layer.width_type = 4
	self._dialog_layer.height_type = 4
	JPS.g_LayerGroup:AddChild(self._dialog_layer, nil)
	self:InitScene()
end

function JPS.GCenter:InitScene()
	JPS.g_Control:CreateControl("sand_table_scn", self, self._main_layer)
	do
		local max_width = self._grid_container.width
		local offset_x = 0
		while offset_x < max_width do
			local quad = ALittle.Quad(JPS.g_Control)
			quad.width = self._grid_frame
			quad.height_type = 4
			quad.x = offset_x
			quad.red = 179 / 255
			quad.green = 179 / 255
			quad.blue = 179 / 255
			self._grid_container:AddChild(quad)
			local label = JPS.g_AUIPluginControl:CreateControl("usual_label")
			label.text = ALittle.Math_Floor(offset_x / self._grid_len)
			label.x = offset_x + self._grid_frame
			label.y = self._grid_frame
			self._grid_container:AddChild(label)
			offset_x = offset_x + (self._grid_len)
		end
		self._map_width = ALittle.Math_Floor(max_width / self._grid_len)
	end
	do
		local max_height = self._grid_container.height
		local offset_y = 0
		while offset_y < max_height do
			local quad = ALittle.Quad(JPS.g_Control)
			quad.height = self._grid_frame
			quad.width_type = 4
			quad.y = offset_y
			quad.red = 179 / 255
			quad.green = 179 / 255
			quad.blue = 179 / 255
			self._grid_container:AddChild(quad)
			local label = JPS.g_AUIPluginControl:CreateControl("usual_label")
			label.text = ALittle.Math_Floor(offset_y / self._grid_len)
			label.x = self._grid_frame
			label.y = offset_y + self._grid_frame
			self._grid_container:AddChild(label)
			offset_y = offset_y + (self._grid_len)
		end
		self._map_height = ALittle.Math_Floor(max_height / self._grid_len)
	end
	self:SetStartQuad(3 * self._grid_len, 12 * self._grid_len)
	self:SetEndQuad(16 * self._grid_len, 12 * self._grid_len)
	self._cost_time.text = "--"
	self._jps = carp.CarpSquareJPS(self._map_width, self._map_height)
end

function JPS.GCenter:HandleStartQuadDrag(event)
	self:SetStartQuad(event.abs_x, event.abs_y)
end

function JPS.GCenter:HandleEndQuadDrag(event)
	self:SetEndQuad(event.abs_x, event.abs_y)
end

function JPS.GCenter:SetStartQuad(x, y)
	local col = ALittle.Math_Floor(x / self._grid_len)
	local row = ALittle.Math_Floor(y / self._grid_len)
	if self._start_x == col and self._start_y == row then
		return
	end
	self._start_x = col
	self._start_y = row
	self._start_quad.x = col * self._grid_len + self._grid_frame
	self._start_quad.y = row * self._grid_len + self._grid_frame
	self._start_label.text = "(" .. self._start_x .. ", " .. self._start_y .. ")"
end

function JPS.GCenter:SetEndQuad(x, y)
	local col = ALittle.Math_Floor(x / self._grid_len)
	local row = ALittle.Math_Floor(y / self._grid_len)
	if self._end_x == col and self._end_y == row then
		return
	end
	self._end_x = col
	self._end_y = row
	self._end_quad.x = col * self._grid_len + self._grid_frame
	self._end_quad.y = row * self._grid_len + self._grid_frame
	self._end_label.text = "(" .. self._end_x .. ", " .. self._end_y .. ")"
end

function JPS.GCenter:HandleStartClick(event)
	local start_time = ALittle.System_GetCurMSTime()
	local result, x_list, y_list = self._jps:SearchRoute(self._start_x, self._start_y, self._end_x, self._end_y)
	local end_time = ALittle.System_GetCurMSTime()
	self._cost_time.text = (end_time - start_time) .. "ms"
	self._jump_container:RemoveAllChild()
	self._line_container:RemoveAllChild()
	if result then
		local pre_x = nil
		local pre_y = nil
		for index, x in ___ipairs(x_list) do
			local y = y_list[index]
			local quad = ALittle.Quad(JPS.g_Control)
			quad.width = self._start_quad.width
			quad.height = self._start_quad.height
			quad.red = 208 / 255
			quad.green = 208 / 255
			quad.blue = 251 / 255
			quad.x = x * self._grid_len + self._grid_frame
			quad.y = y * self._grid_len + self._grid_frame
			self._jump_container:AddChild(quad)
			if pre_x ~= nil then
				local start_x = pre_x * self._grid_len + self._grid_len / 2
				local start_y = pre_y * self._grid_len + self._grid_len / 2
				local end_x = x * self._grid_len + self._grid_len / 2
				local end_y = y * self._grid_len + self._grid_len / 2
				local line = ALittle.Quad(JPS.g_Control)
				line:SetSizeAsLine(self._grid_frame, start_x, start_y, end_x, end_y)
				line.red = 254 / 255
				line.green = 193 / 255
				line.blue = 133 / 255
				line:SetPosAsLine(start_x, start_y, end_x, end_y)
				self._line_container:AddChild(line)
			end
			pre_x = x
			pre_y = y
		end
	end
end

function JPS.GCenter:HandleBlockQuadDrag(event)
	self:SetBlock(event.abs_x, event.abs_y)
end

function JPS.GCenter:HandleBlockQuadClick(event)
	self:SetBlock(event.abs_x, event.abs_y)
end

function JPS.GCenter:SetBlock(x, y)
	local col = ALittle.Math_Floor(x / self._grid_len)
	local row = ALittle.Math_Floor(y / self._grid_len)
	if not self._jps:IsEmpty(col, row) then
		return
	end
	self._cost_time.text = "--"
	self._jump_container:RemoveAllChild()
	self._line_container:RemoveAllChild()
	self._jps:SetEmpty(col, row, true)
	local quad = ALittle.Quad(JPS.g_Control)
	quad.width = self._start_quad.width
	quad.height = self._start_quad.height
	quad.red = 85 / 255
	quad.green = 85 / 255
	quad.blue = 85 / 255
	quad.x = col * self._grid_len + self._grid_frame
	quad.y = row * self._grid_len + self._grid_frame
	self._block_container:AddChild(quad)
end

function JPS.GCenter:HandleClearClick(event)
	self._cost_time.text = "--"
	self._jump_container:RemoveAllChild()
	self._line_container:RemoveAllChild()
	self._block_container:RemoveAllChild()
	self._jps:SetAllEmpty()
end

function JPS.GCenter:Shutdown()
end

_G.g_GCenter = JPS.GCenter()
end