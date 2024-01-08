----------------------------------------------------------------------
-- Takes a sprite for a tile sheet and splits
--    each tile onto its own layer.
----------------------------------------------------------------------
local sprite = app.activeSprite

-- Checks for a valid sprite
if not sprite then
  app.alert("There is no sprite to export")
  return
end

-- NOTE: can set the fgColor and bgColor since they are defaults for from and to or just set from and to directly in ReplaceColor
-- 122	72	65	#7a4841
-- app.fgColor = Color(122, 72, 65)
-- 117	36	56	#752438
-- app.bgColor = Color(117, 36, 56)

local colorPairs = {
  {from=Color(122, 72, 65), to=Color(21, 29, 40)},
  {from=Color(173, 119, 87), to=Color(32, 46, 55)}
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

-- -- 122	72	65	#7a4841
-- -- 21	,29	,40	#151d28
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(122, 72, 65),
--   to=Color(21	,29	,40	),
--   -- channels=ColorMode.Indexed,
-- }

-- -- 173	,119	,87	#ad7757
-- -- 32	,46	,55	#202e37
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(173	,119	,87),
--   to=Color(32	,46	,55	),
-- }

-- -- 77	,43	,50	#4d2b32
-- -- 57	,74	,80	#394a50
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(77	,43	,50	),
--   to=Color(57	,74	,80),
-- }

-- -- 117	,167	,67	#75a743
-- -- 223	,132	,165	#df84a5
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(117	,167	,67),
--   to=Color(165	,48	,48),
-- }

-- -- 37	,86	,46	#25562e
-- -- 198	,81	,151	#c65197
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(37	,86	,46	),
--   to=Color(198	,81	,151	),
-- }

-- -- 25	,51	,45	#19332d
-- -- 162	,62	,140	#a23e8c
-- app.command.ReplaceColor {
--   ui=false, -- true to debug
--   tolerance=0,
--   from=Color(25	,51	,45	),
--   to=Color(162	,62	,140	),
-- }
