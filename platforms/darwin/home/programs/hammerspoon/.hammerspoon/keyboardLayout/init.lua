keyboardLayout = {}

function keyboardLayout:init()
  self:draw()
  self:setLayoutChangedHook()

  self.layoutIndexes = {}
  for i, name in ipairs(hs.keycodes.layouts()) do
    self.layoutIndexes[name] = i
  end

  local function nextLayout()
    self:setNextLayout()
  end

  hs.hotkey.bind({"ctrl", "alt"}, "space", nextLayout)
end

function keyboardLayout:currentLayoutTextElement()
  st = hs.styledtext
  kc = hs.keycodes

  text = st.new(
    kc.currentLayout():gsub("ABC", "English"):gsub("%s.+", ""),
    {
      font = st.convertFont({ name = "Helvetica Neue", size = 14 }, st.fontTraits.boldFont),
      color = { hex = "a8a8a8", alpha = 0.85 },
      paragraphStyle = { alignment = "right", minimumLineHeight = 24 },
    }
  )

  return { type = "text", id = "kltext", text = text, action = "fill" }
end

function keyboardLayout:currentLayoutImageElement()
  kc = hs.keycodes
  text = kc.currentLayout()

  image = text == "ABC"
    and hs.image.imageFromPath("~/.hammerspoon/keyboardLayout/abc.png")
    or kc.currentLayoutIcon()

  return { type = "image", id = "klimage", image = image }
end

function keyboardLayout:draw()
  canvas = hs.canvas
  self.c = canvas.new{ x = 1585, y = 8, h = 16, w = 16 }:show()
  self.c:behavior("canJoinAllSpaces")
  self.c:level("normal")
  self.c:insertElement({
    type = "rectangle",
    id = "klrect",
    action = "fill",
    fillColor = { hex = "202020", alpha = 0 }
  })
  self.c:insertElement(self:currentLayoutImageElement())
end

function keyboardLayout:setLayoutChangedHook()
  local function updateLayout()
    self.c:removeElement(2)
    self.c:insertElement(self:currentLayoutImageElement())
  end
  hs.keycodes.inputSourceChanged(updateLayout)
end

function keyboardLayout:setNextLayout()
  kc = hs.keycodes
  layouts = kc.layouts()

  index = self.layoutIndexes[kc.currentLayout()]
  nextIndex = index == #layouts and 1 or index + 1

  kc.setLayout(layouts[nextIndex])
end

return keyboardLayout
