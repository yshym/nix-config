keyboardLayout = {}

function keyboardLayout:init()
  self:draw()
  self:setLayoutChangedHook()
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

  return { type = "text", id = "istext", text = text, action = "fill" }
end

function keyboardLayout:draw()
  canvas = hs.canvas
  self.c = canvas.new{ x = 1539, y = 0, h = 30, w = 64 }:show()
  self.c:behavior("canJoinAllSpaces")
  self.c:level("normal")
  self.c:insertElement({
    type = "rectangle",
    id = "isrect",
    action = "fill",
    fillColor = { hex = "202020", alpha = 0 }
  })
  self.c:insertElement(self:currentLayoutTextElement())
end

function keyboardLayout:setLayoutChangedHook()
  local function updateLayout()
    self.c:removeElement(2)
    self.c:insertElement(self:currentLayoutTextElement())
  end
  hs.keycodes.inputSourceChanged(updateLayout)
end

return keyboardLayout
