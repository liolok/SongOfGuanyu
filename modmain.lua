Assets = {
  Asset('SOUNDPACKAGE', 'sound/song_of_guanyu.fev'),
  Asset('SOUND', 'sound/song_of_guanyu.fsb'),
}

local G = GLOBAL
local TheNet = G.TheNet

local EVENT = 'song_of_guanyu/song_of_guanyu/instrumental' -- 事件路径
local NAME = 'SongOfGuanyu' -- 名称
local VOLUME = 0.5 -- 音量

-- 确保只在真正的玩家客户端以及非专用服务器的主机上工作
if TheNet:GetIsClient() or not TheNet:IsDedicated() then
  -- 拦截底层的网络公告入口，比动 UI 组件要安全和稳定得多
  if G.Networking_Announcement then
    local OldNetworking_Announcement = G.Networking_Announcement

    G.Networking_Announcement = function(message, colour, announce_type, ...)
      if G.TheFrontEnd and announce_type == 'death' then -- 可在 constants.lua ANNOUNCEMENT_ICONS 查到
        local sound_emitter = G.TheFrontEnd:GetSound()
        if sound_emitter then
          sound_emitter:KillSound(NAME) -- 切断之前可能已在播放的音乐，避免重叠
          sound_emitter:PlaySound(EVENT, NAME, VOLUME)
        end
      end

      return OldNetworking_Announcement(message, colour, announce_type, ...)
    end
  end
end
