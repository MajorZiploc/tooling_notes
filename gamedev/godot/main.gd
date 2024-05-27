# dictionary .get and unpack(merge but is void)
Global.app_state["npc"] = Global.app_state.get("npc", {});
Global.app_state["npc"].merge({"combat_unit_data_type": key}, true);

# Name the top level category of export variables in the inspector
@export_group("Player Category");
# Grouping export variables in the inspector
@export_group("Player");
@export var name: String;
# SubGrouping export variables in the inspector
@export_subgroup("Modifiers");
@export var speed: float;
@export_subgroup("Status");
@export_range(0.0, 100, 0.1) var HP: float;
