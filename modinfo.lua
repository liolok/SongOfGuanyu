name = '玩家死亡播放关羽之歌'
author = '李皓奇'
description = '󰀕 死不可怕，死是凉爽的夏夜，可供人无忧的安眠。'
version = 'VERSION_PLACEHOLDER'
api_version = 10
dst_compatible = true
all_clients_require_mod = true
configuration_options = {
  {
    name = 'play_for_charlie',
    label = '为查理播放关羽之歌',
    options = {
      { description = '开启', data = true },
      { description = '关闭', data = false },
    },
    default = true,
  },
  {
    name = 'play_for_wagstaff',
    label = '为老瓦播放关羽之歌',
    options = {
      { description = '开启', data = true },
      { description = '关闭', data = false },
    },
    default = true,
  },
}
