Assets = {
  Asset('SOUNDPACKAGE', 'sound/song_of_guanyu.fev'),
  Asset('SOUND', 'sound/song_of_guanyu.fsb'),
}

local G = GLOBAL
local TheNet = G.TheNet

-- 只遵循各客户端的本地配置
local function GetClientConfig(name) return GetModConfigData(name, true) end

--------------------------------------------------------------------------------
-- 客户端侧音频播放

local EVENT = 'song_of_guanyu/song_of_guanyu/instrumental' -- 事件路径
local NAME = 'SongOfGuanyu' -- 名称
local VOLUME = 0.5 -- 音量

local function Play()
  local sound_emitter = G.TheFrontEnd and G.TheFrontEnd:GetSound()
  if sound_emitter then
    sound_emitter:KillSound(NAME) -- 切断之前可能已在播放的音乐，避免重叠
    sound_emitter:PlaySound(EVENT, NAME, VOLUME)
  end
end

--------------------------------------------------------------------------------
-- 死亡宣告触发

if
  (TheNet:GetIsClient() or not TheNet:IsDedicated()) -- 确保只在真正的玩家客户端以及非专用服务器的主机上工作
  and GetClientConfig('play_on_death_announcement')
then
  -- 拦截底层的网络公告入口，比动 UI 组件要安全和稳定得多
  if G.Networking_Announcement then
    local OldNetworking_Announcement = G.Networking_Announcement

    G.Networking_Announcement = function(message, colour, announce_type, ...)
      if announce_type == 'death' then Play() end -- 宣告类型可在 constants.lua ANNOUNCEMENT_ICONS 查到

      return OldNetworking_Announcement(message, colour, announce_type, ...)
    end
  end
end

--------------------------------------------------------------------------------
-- 首次击败藏影女王触发

if TheNet:GetIsClient() and GetClientConfig('play_for_charlie') then
  AddPrefabPostInit('charlie_boss', function(inst)
    inst:DoPeriodicTask(0.1, function(inst)
      if
        not inst.song_of_guanyu_played
        and inst.AnimState:IsCurrentAnimation('return')
      then
        inst.song_of_guanyu_played = true
        Play()
      end
    end)
  end)
end

--------------------------------------------------------------------------------
-- 首次击败天体后裔触发

if TheNet:GetIsClient() and GetClientConfig('play_for_wagstaff') then
  AddPrefabPostInit('alterguardian_phase4_lunarrift', function(inst)
    inst:DoPeriodicTask(0.1, function(inst)
      if
        not inst.song_of_guanyu_played
        and inst.AnimState:IsCurrentAnimation('defeated_loop')
      then
        inst.song_of_guanyu_played = true
        Play()
      end
    end)
  end)
end
