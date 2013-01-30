require 'views/start_menu_view'

StartMenu = class("Menu", GameState)

function StartMenu:initialize()
  self.view = StartMenuView()
end

function StartMenu:update(dt)
  self.view:update(dt)
end

