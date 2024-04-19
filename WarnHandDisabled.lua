file_name = "game.lua"
fun_name = "Game:update"
replacements = {
{'scale = 0.7','scale = 1.5'},
{'if not self.boss_warning_text then', [[if not self.boss_warning_text then 
G.play_confirm_needed = true
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
G.play_confirm_needed = nil
self.boss_warning_cover_play:remove()
self.boss_warning_cover_play = nil
self.boss_warning_cover_hand:remove()
self.boss_warning_cover_hand = nil]]}
}

--[[

G.FUNCS.can_play = function(e)
  if #G.hand.highlighted <= 0 or G.GAME.blind.block_play or #G.hand.highlighted > 5 then 
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else 
      e.config.colour = G.C.BLUE
      e.config.button = 'play_cards_from_highlighted'
  end
end

--insert this
G.FUNCS.confirm_play_cards = function(e)
  G.play_confirm_needed = nil
  G.boss_warning_cover_play.states.visible = false  
end
--insert end

]]



local can_play_ref = nil

table.insert(mods,
    {
        mod_id = "TD_WarnHandDisabled",
        name = "Warn Hand Disabled",
        version = "0.2",
        author = "TD",
        description = {
            "Warn and Confirm Play when the Boss Blind disables your hand"
        },
        enabled = true,
        
        
        on_enable = function()
        --[[
          can_play_ref = G.FUNCS.can_play
          G.FUNCS.can_play = function(e)
            can_play_ref(e)
            if G.play_confirm_needed then
                e.config.colour = G.C.GREEN
                e.config.button = 'confirm_play_cards'
            end
          end
          ]]
          G.FUNCS.can_play = function(e)
            if #G.hand.highlighted <= 0 or G.GAME.blind.block_play or #G.hand.highlighted > 5 then 
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
            elseif G.play_confirm_needed then
                e.config.colour = G.C.GREEN
                e.config.button = 'confirm_play_cards'
            else
                e.config.colour = G.C.BLUE
                e.config.button = 'play_cards_from_highlighted'
            end
          end
              
          G.FUNCS.confirm_play_cards = function(e)
            G.play_confirm_needed = nil
            G.boss_warning_cover_play.states.visible = false  
          end

          for i, r in ipairs(replacements) do
            inject(file_name, fun_name, r[1], r[2])
          end
          
        end,
        
        
        on_disable = function()
        
          G.FUNCS.can_play = can_play_ref
          can_play_ref = nil
          
          G.FUNCS.confirm_play_cards = nil
        
          for i, r in ipairs(replacements) do
            inject(file_name, fun_name, r[2], r[1])
          end
          
        end,
    }
)

