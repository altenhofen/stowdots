-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	local clear = '#00000000'
	local lexers = vis.lexers

	lexers.STYLE_DEFAULT ='back:'..clear
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set autoindent on')
	vis:command('set colorcolumn 80')
	vis:command('set cursorline')
	vis:command('set expandtab on')
	vis:command('set number')
	vis:command('set relativenumbers')
	vis:command('set show-spaces off')
	vis:command('set show-tabs on')
	vis:command('set tabwidth 4')
end)

