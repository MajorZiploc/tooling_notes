local sprite = app.activeSprite

-- Checks for a valid sprite
if not sprite then
  app.alert("There is no sprite to export")
  return
end

local colorPairs = {
  {from=Color(25, 51, 45), to=Color(52, 28, 39)},
{from=Color(37, 86, 46), to=Color(96, 44, 44)},
{from=Color(70, 130, 50), to=Color(136, 75, 43)},
{from=Color(117, 167, 67), to=Color(190, 119, 43)},
{from=Color(168, 202, 88), to=Color(222, 158, 65)},
{from=Color(208, 218, 145), to=Color(232, 193, 112)},
{from=Color(77, 43, 50), to=Color(36, 21, 39)},
{from=Color(122, 72, 65), to=Color(65, 29, 49)},
{from=Color(173, 119, 87), to=Color(117, 36, 56)},
{from=Color(192, 148, 115), to=Color(165, 48, 48)},
{from=Color(215, 181, 148), to=Color(207, 87, 60)},
{from=Color(231, 213, 179), to=Color(218, 134, 62)},

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

