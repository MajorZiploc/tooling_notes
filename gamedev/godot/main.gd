  # dictionary .get and unpack(merge but is void)
  Global.app_state["npc"] = Global.app_state.get("npc", {});
  Global.app_state["npc"].merge({"combat_unit_data_type": key}, true);

