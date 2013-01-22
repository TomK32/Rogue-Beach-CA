
local sounds = {}

sounds.waves = {
  love.audio.newSource("sounds/Ocean_Waves-Mike_Koenig-980635527.mp3", "static")
}

sounds.music = {
  love.audio.newSource("sounds/Jano Gonzales - Kurt Goedel.mp3", "static"),
  love.audio.newSource("sounds/Jano Gonzales - Cobquecura.mp3", "static"),
  love.audio.newSource("sounds/Jano Gonzales - Jugo Blues.mp3", "static")
}


return sounds
