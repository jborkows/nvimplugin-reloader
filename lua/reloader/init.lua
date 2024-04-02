-- @class M
-- @field __config __Config
-- @field debug function
-- @field info function
-- @field setup function
--
local M = {}
-- @class __Config
-- @field logerLevel string
-- @field UserCommandName string
local __Config = {
	loggerLevel = "info",
	userCommandName = "PluginMode"
}

-- @param ... function[]

local logger = require("plenary.log"):new()
M.setup = function(...)
	for _, plugin in ipairs({ ... }) do
		plugin(__Config)
	end

	logger.level = __Config.loggerLevel
	local pluginModeGroup = vim.api.nvim_create_augroup("plugin-mode-jb", { clear = true })

	vim.api.nvim_create_user_command(__Config.userCommandName, function()
		logger.debug(vim.api.nvim_buf_get_name(0))
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = pluginModeGroup,
			buffer = 0,
			callback = function()
				vim.schedule(function()
					logger.debug("Save completed")
					vim.cmd { cmd = "source", args = { "%" } }
					logger.debug("Reloaded ->" .. vim.api.nvim_buf_get_name(0))
				end)
			end
		})
	end, {})
end

-- @return function
-- @param _config __Config
M.debug = 
	-- @param _config __Config
	function(_config)
		_config.loggerLevel = "debug"
	end
-- @return function
-- @param _config __Config
M.info = 
	-- @param _config __Config
	function(_config)
		_config.loggerLevel = "info"
	end

-- @return function
-- @param name string
M.userCommandName = function(name)
	-- @param _config __Config
	return function(_config)
		_config.userCommandName = name
	end
end


return M
