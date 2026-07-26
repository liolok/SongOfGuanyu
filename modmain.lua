Assets = {
  Asset('SOUNDPACKAGE', 'sound/song_of_guanyu.fev'),
  Asset('SOUND', 'sound/song_of_guanyu.fsb'),
}
local SOUND = 'song_of_guanyu/song_of_guanyu/instrumental' -- sound event
local MOD = 'Song_of_Guanyu' -- mod namespace
local RPC = 'Play' -- RPC name

local fns = require('prefabs/player_common_extensions')
local OldOnPlayerDeath = fns.OnPlayerDeath
fns.OnPlayerDeath = function(dead_player, ...)
  for _, player in ipairs(GLOBAL.AllPlayers or {}) do
    SendModRPCToClient(
      GetClientModRPC(MOD, RPC),
      player.userid,
      dead_player.userid,
      dead_player.name,
      dead_player.prefab
    )
  end
  return OldOnPlayerDeath(dead_player, ...)
end

AddClientModRPCHandler(MOD, RPC, function(id, name, prefab)
  local sound_emitter = GLOBAL.TheFrontEnd and GLOBAL.TheFrontEnd:GetSound()
  if not sound_emitter then return end

  sound_emitter:KillSound(MOD)
  sound_emitter:PlaySound(SOUND, MOD, 0.5)
  local player_info = string.format('[%s] %s (%s)', id, name, prefab)
  print('Song of Guanyu is played for ' .. player_info)
end)
