local sprite = app.activeSprite

-- Checks for a valid sprite
if not sprite then
  app.alert("There is no sprite to export")
  return
end

local colorPairs = {
  {from=Color(23, 32, 56)}, to=Color(30, 29, 57)},
  {from=Color(37, 58, 94)}, to=Color(64, 39, 81)},
  {from=Color(60, 94, 139)}, to=Color(122, 54, 123)},
  {from=Color(79, 143, 186)}, to=Color(162, 62, 140)},
  {from=Color(115, 190, 211)}, to=Color(198, 81, 151)},
  {from=Color(164, 221, 219)}, to=Color(223, 132, 165)},
}

for _, pair in ipairs(colorPairs) do
  app.command.ReplaceColor {
    ui=false, -- true to debug
    tolerance=0,
    from=pair.from,
    to=pair.to,
    -- channels=ColorMode.Indexed,
  }
end

-- NOTE: can set the fgColor and bgColor since they are defaults for from and to or just set from and to directly in ReplaceColor
-- 122	72	65	#7a4841
-- app.fgColor = Color(122, 72, 65)
-- 117	36	56	#752438
-- app.bgColor = Color(117, 36, 56)

