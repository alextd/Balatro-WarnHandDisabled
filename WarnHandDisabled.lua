file_name = "game.lua"
fun_name = "Game:update"
replacements = {
{'scale = 0.7','scale = 1.5'},
{'if not self.boss_warning_text then', [[if not self.boss_warning_text then 
self.boss_warning_cover_play = UIBox{
definition = 
{
	n=G.UIT.ROOT,
	config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2},
	nodes=
	{
		{
			n=G.UIT.O,
			config=
				{
					object = DynaText({scale = 1.5, string = "?", maxw = 9, colours = {G.C.RED},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})
				}
		}
	}
}, 
config = {
	align = 'cm',
	major = G.play,
	offset = {x=4,y=4}
}}
self.boss_warning_cover_play.attention_text = true
self.boss_warning_cover_play.states.collide.can = false

self.boss_warning_cover_hand = UIBox{
definition = 
{
	n=G.UIT.ROOT,
	config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2},
	nodes=
	{
		{
			n=G.UIT.O,
			config=
				{
					object = DynaText({scale = 1.5, string = "NOPE", maxw = 9, colours = {G.C.RED},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})
				}
		}
	}
}, 
config = {
	align = 'cm',
	major = G.play,
	offset = {x=-9,y=-0.5}
}}
self.boss_warning_cover_hand.attention_text = true
self.boss_warning_cover_hand.states.collide.can = false]]},

{'if self.boss_warning_text then', [[if self.boss_warning_text then
self.boss_warning_cover_play:remove()
self.boss_warning_cover_play = nil
self.boss_warning_cover_hand:remove()
self.boss_warning_cover_hand = nil]]}
}

table.insert(mods,
				{
						mod_id = "TD_WarnHandDisabled",
						name = "Warn Hand Disabled",
						version = "0.1",
						author = "TD",
						description = {
								"Much more obvious warnings when the Boss Blind disables your hand"
						},
						enabled = true,
						on_enable = function()
						
						  for i, r in ipairs(replacements) do
								inject(file_name, fun_name, r[1], r[2])
							end
						end,
						on_disable = function()
						
						  for i, r in ipairs(replacements) do
								inject(file_name, fun_name, r[2], r[1])
							end
						end,
				}
)

