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
	logerLevel = "debug",
	userCommandName = "PluginMode"
}

-- @param ... function[]

M.setup = function(...)
	for _, plugin in ipairs(...) do
		plugin(__Config)
	end
	print(vim.inspect(__Config))

	local logger = require("plenary.log"):new()
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
M.debug = function()
	-- @param _config __Config
	return function(_config)
		print("Appying debug mode")
		_config.loggerLevel = "debug"
	end
end
-- @return function
-- @param _config __Config
M.info = function()
	-- @param _config __Config
	return function(_config)
		_config.loggerLevel = "info"
	end
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
