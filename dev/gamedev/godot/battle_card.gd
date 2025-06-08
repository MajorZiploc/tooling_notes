extends Node2D

class_name BattleCard

enum FrameType {
  FOCUS,
  IDLE,
  FLY_LEFT,
  FLIP,
}

# NOTE: will add a MIDDLE type for all types that is the hanging loop animation/state between start and end
#  this may break how transitions work - test with different transition types

enum INTERNAL_SIGNAL {
  FOCUS_START,
  FOCUS_END,
  FLY_LEFT_START,
  FLY_LEFT_END,
  FLIP_START,
  FLIP_END,
}

static var count: int = 0;

@onready var wrapper: Node2D = $wrapper;
@onready var base_bg_shadow: Sprite2D = $wrapper/base_bg_shadow;
@onready var base_bg: Sprite2D = $wrapper/base_bg;
@onready var base_decor: Sprite2D = $wrapper/base_decor;
@onready var entity_main: Sprite2D = $wrapper/entity_main;
@onready var card_area: Control = $wrapper/card_area;
@onready var details: Node2D = $wrapper/details;
@onready var anim_player: AnimationPlayer = %animation_player;
@onready var frame_type = FrameType.IDLE;
@onready var _scale_focus_mod = 1.15;
@onready var _fly_scale_mod = 0.7;
@onready var _fly_rotation_mod = 0.523599;
@onready var _fly_skew_mod = 0.523599;
@onready var _base_decor_scale_focus_mod = 1.1;
@onready var _entity_main_scale_focus_mod = 1.2;
@onready var _base_bg_shadow_scale_focus_mod = 0.97;
@onready var _zindex_mod = 1;

var first_default = true;
var is_flipped = false;
var _entity_class: String = "battle_mage_01";
var _side: String = "alliance";
var _sub_entity_class: String = "std_01";
var _card_base: String = "base_01";
var _card_back: String = "back_01";
# NOTE: trying to use Array[String] fails in anim_manager when trying to pass dict.keys() as arg for Array[String]
var all_anims: Array = ["flip","fly_left_end","fly_left_start","focus_end","focus_start","idle"];
var focus_anims: Array = ["focus_end","focus_start"];
var fly_anims: Array = ["fly_left_end","fly_left_start"];
var flip_anims: Array = ["flip"];
# NOTE: trying to use Dictionary[FrameType, Dictionary] fails due to u.setup_anim_state_machine_transitions returning Dictionary type
var valid_target_to_source_map: Dictionary = {};
# NOTE: trying to use Dictionary[FrameType, Dictionary] fails due to u.setup_anim_state_machine_transitions returning Dictionary type
var valid_source_to_target_map: Dictionary = {};
var textures: Dictionary = {};

var id: int;
var anim_manager: AnimManager;
var last_internal_signal: INTERNAL_SIGNAL;

func _ready() -> void:
  id = count;
  count = count + 1;
  var anim_metadata: Dictionary[String, Dictionary] = {
    "wrapper": {
      "instance": wrapper,
      "og_props": {
        "scale": {
          "value": wrapper.scale,
          "related_anims": all_anims,
        },
        "rotation": {
          "value": wrapper.rotation,
          "related_anims": fly_anims,
        },
        "skew": {
          "value": wrapper.skew,
          "related_anims": fly_anims,
        },
        "z_index": {
          "value": wrapper.z_index,
          "related_anims": focus_anims,
        },
      },
    },
    "base_bg_shadow": {
      "instance": base_bg_shadow,
      "og_props": {
        "scale": {
          "value": base_bg_shadow.scale,
          "related_anims": focus_anims + flip_anims,
        },
        "position": {
          "value": base_bg_shadow.position,
          "related_anims": flip_anims,
        },
      },
    },
    "base_decor": {
      "instance": base_decor,
      "og_props": {
        "scale": {
          "value": base_decor.scale,
          "related_anims": focus_anims,
        },
      },
    },
    "base_bg": {
      "instance": base_bg,
      "og_props": {
        "scale": {
          "value": base_bg.scale,
          "related_anims": [],
        },
      },
    },
    "entity_main": {
      "instance": entity_main,
      "og_props": {
        "scale": {
          "value": entity_main.scale,
          "related_anims": focus_anims,
        },
      },
    },
  };
  var anim_tree = _setup_anim();
  anim_manager = AnimManager.new(anim_player, anim_tree, anim_metadata, self);
  anim_manager.init_anims(all_anims);
  card_area.connect("focus_entered", _on_focus_start);
  card_area.connect("focus_exited", _on_focus_end);
  # card_area.connect("button_up", _on_button_up);
  # card_area.connect("button_down", _on_pressed_start);
  card_area.connect("mouse_entered", _on_focus_start);
  card_area.connect("mouse_exited", _on_focus_end);
  # MessageBus.connect("BATTLECARD_FLY_LEFT_START", _on_fly_left_start);
  # MessageBus.connect("BATTLECARD_FLY_LEFT_END", _on_fly_left_end);
  # card_area.connect("pressed", _on_pressed_start);
  # init_focus_looper();

# func init_focus_looper():
#   for n in 100:
#     _on_focus_start();
#     await get_tree().create_timer(1.1).timeout;
#     _on_focus_end();
#     await get_tree().create_timer(0.7).timeout;
#   # test_tween.tween_callback(func(): _on_focus_start).set_delay(1.1);
#   # test_tween.tween_callback(func(): _on_focus_end()).set_delay(0.7);
#   # test_tween.set_loops(-1);

func setup_obj(entity_class: String = "battle_mage_01", side: String = "alliance", sub_entity_class: String = "", card_base: String = "base_01", card_back: String = "back_01") -> void:
  _entity_class = entity_class;
  _side = side;
  _sub_entity_class = sub_entity_class;
  _card_base = card_base;
  _card_back = card_back;
  var __sub_entity_class = "_"+_sub_entity_class if _sub_entity_class else "";
  textures = {
    "front": {
      "base_bg": load("res://assets/my/art/card/base/"+_card_base+"/bg_"+_side+"_cached.png"),
      "base_decor": load("res://assets/my/art/card/base/"+_card_base+"/decor_"+_side+"_cached.png"),
      "entity_main": load("res://assets/my/art/card/entity/"+_entity_class+"/main_"+_side+__sub_entity_class+"_cached.png"),
     },
    "back": {
      "base_bg": load("res://assets/my/art/card/back/"+_card_back+"/bg_"+_side+"_cached.png"),
      "base_decor": load("res://assets/my/art/card/back/"+_card_back+"/decor_"+_side+"_cached.png"),
      "entity_main": null,
     },
  };
  set_textures();
  first_default = _side == "alliance";

func set_textures():
  var cur_textures = textures["back"] if is_flipped else textures["front"];
  base_bg.texture = cur_textures["base_bg"];
  base_decor.texture = cur_textures["base_decor"];
  if is_flipped:
    entity_main.visible = false;
    details.visible = false;
  else:
    entity_main.visible = true;
    details.visible = true;
    entity_main.texture = cur_textures["entity_main"];

func flip_card() -> void:
  is_flipped = !is_flipped;
  set_textures();

func swap_textures() -> void:
  if first_default:
    setup_obj(_entity_class, "alliance", _sub_entity_class, _card_base);
  else:
    setup_obj(_entity_class, "hive", _sub_entity_class, _card_base);
  first_default = not first_default;

func mk_focus_space() -> AnimationNodeBlendSpace1D:
  var space = AnimationNodeBlendSpace1D.new();
  space.blend_mode = AnimationNodeBlendSpace1D.BLEND_MODE_DISCRETE;
  space.add_blend_point(U.mk_anim_node("r/focus_start"), 1);
  space.add_blend_point(U.mk_anim_node("r/focus_end"), -1);
  return space;

func mk_idle_space() -> AnimationNodeBlendSpace1D:
  var space = AnimationNodeBlendSpace1D.new();
  space.blend_mode = AnimationNodeBlendSpace1D.BLEND_MODE_DISCRETE;
  space.add_blend_point(U.mk_anim_node("r/idle"), 1);
  space.add_blend_point(U.mk_anim_node("r/idle"), -1);
  return space;

func mk_fly_left_space() -> AnimationNodeBlendSpace1D:
  var space = AnimationNodeBlendSpace1D.new();
  space.blend_mode = AnimationNodeBlendSpace1D.BLEND_MODE_DISCRETE;
  space.add_blend_point(U.mk_anim_node("r/fly_left_start"), 1);
  space.add_blend_point(U.mk_anim_node("r/fly_left_end"), -1);
  return space;

func mk_flip_space() -> AnimationNodeBlendSpace1D:
  var space = AnimationNodeBlendSpace1D.new();
  space.blend_mode = AnimationNodeBlendSpace1D.BLEND_MODE_DISCRETE;
  space.add_blend_point(U.mk_anim_node("r/flip"), 1);
  space.add_blend_point(U.mk_anim_node("r/flip"), -1);
  return space;

func _on_fly_left_start() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FOCUS_START;
  frame_type = FrameType.IDLE;
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FLY_LEFT)+"/blend_position", 1);
  frame_type = FrameType.FLY_LEFT;
  anim_manager.travel(frame_type);

func _on_fly_left_end() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FLY_LEFT_END;
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FLY_LEFT)+"/blend_position", -1);
  frame_type = FrameType.IDLE;
  anim_manager.travel(frame_type);

func _on_focus_start() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FOCUS_START;
  if (!L.dict_get(valid_target_to_source_map, [FrameType.FOCUS, frame_type], false)): return;
  await get_tree().create_timer(0.05).timeout;
  if last_internal_signal != INTERNAL_SIGNAL.FOCUS_START: return;
  # NOTE: full_manual_animations - needs the following set commented
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FOCUS)+"/blend_position", 1);
  frame_type = FrameType.FOCUS;
  # NOTE: manual_animations - needs the following set uncommented
  anim_manager.travel(frame_type);
  MessageBus.BATTLECARD_FOCUS_START.emit(self);

func _on_focus_end() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FOCUS_END;
  if frame_type != FrameType.FOCUS: return;
  var target_frame_type = FrameType.IDLE;
  if (!L.dict_get(valid_source_to_target_map, [target_frame_type, FrameType.FOCUS], false)): return;
  # NOTE: full_manual_animations - needs the following set commented
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FOCUS)+"/blend_position", -1);
  frame_type = target_frame_type;
  # NOTE: manual_animations - needs the following set uncommented
  anim_manager.travel(frame_type);
  MessageBus.BATTLECARD_FOCUS_END.emit(self);

func _on_flip_start() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FLIP_START;
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FLIP)+"/blend_position", 1);
  frame_type = FrameType.FLIP;
  anim_manager.travel(frame_type);

func _on_flip_end() -> void:
  last_internal_signal = INTERNAL_SIGNAL.FLIP_END;
  anim_manager.anim_tree.set("parameters/state_machine/"+str(FrameType.FLIP)+"/blend_position", -1);
  frame_type = FrameType.IDLE;
  anim_manager.travel(frame_type);

# func _on_pressed_start() -> void:
#   _set_modulate(pressed_modulate);

# func _on_button_down() -> void:
#   _set_modulate(pressed_modulate);

# func _on_button_up() -> void:
#   _set_modulate(normal_modulate);

# NOTE: for fully managed state_machine
func _setup_anim() -> AnimationTree:
  var anim_tree = AnimationTree.new();
  self.add_child(anim_tree);
  anim_tree.name = "animation_tree";
  anim_tree.anim_player = anim_player.get_path();
  anim_tree.advance_expression_base_node = self.get_path();
  var state_machine = AnimationNodeStateMachine.new();
  var _idle_space = mk_idle_space();
  state_machine.add_node(str(FrameType.IDLE), _idle_space);
  var _focus_space = mk_focus_space();
  state_machine.add_node(str(FrameType.FOCUS), _focus_space);
  var _fly_left_space = mk_fly_left_space();
  state_machine.add_node(str(FrameType.FLY_LEFT), _fly_left_space);
  var _flip_space = mk_flip_space();
  state_machine.add_node(str(FrameType.FLIP), _flip_space);
  # NOTE: full_managed_animation AnimationNodeStateMachineTransition.AdvanceMode.ADVANCE_MODE_AUTO
  var adv_mode = AnimationNodeStateMachineTransition.AdvanceMode.ADVANCE_MODE_ENABLED;
  var transition1 = AnimationNodeStateMachineTransition.new();
  transition1.advance_mode = AnimationNodeStateMachineTransition.AdvanceMode.ADVANCE_MODE_ENABLED;
  transition1.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_IMMEDIATE;
  # NOTE: auto switches to idle - used if the travel.(str(FrameType.IDLE)) section at the end of this fn isnt used
  #  doing it this was is considered an anti pattern tho
  # transition1.advance_mode = AnimationNodeStateMachineTransition.AdvanceMode.ADVANCE_MODE_AUTO;
  # transition1.advance_expression = "1 == 1";
  var transition2 = AnimationNodeStateMachineTransition.new();
  transition2.advance_mode = adv_mode;
  transition2.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_IMMEDIATE;
  # transition2.advance_expression = "frame_type == "+str(FrameType.FOCUS);
  var transition3 = AnimationNodeStateMachineTransition.new();
  transition3.advance_mode = adv_mode;
  transition3.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_AT_END;
  # transition3.advance_expression = "frame_type == "+str(FrameType.IDLE);
  var transition4 = AnimationNodeStateMachineTransition.new();
  transition4.advance_mode = adv_mode;
  transition4.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_IMMEDIATE;
  # transition4.advance_expression = "frame_type == "+str(FrameType.FLY_LEFT);
  var transition5 = AnimationNodeStateMachineTransition.new();
  transition5.advance_mode = adv_mode;
  transition5.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_AT_END;
  # transition5.advance_expression = "frame_type == "+str(FrameType.IDLE);
  var transition6 = AnimationNodeStateMachineTransition.new();
  transition6.advance_mode = adv_mode;
  transition6.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_IMMEDIATE;
  # transition6.advance_expression = "frame_type == "+str(FrameType.FLIP);
  var transition7 = AnimationNodeStateMachineTransition.new();
  transition7.advance_mode = adv_mode;
  transition7.switch_mode = AnimationNodeStateMachineTransition.SwitchMode.SWITCH_MODE_IMMEDIATE;
  # transition7.advance_expression = "frame_type == "+str(FrameType.IDLE);
  var transition_metadatas: Array[Dictionary] = [
    {
      "source": "Start",
      "target": FrameType.IDLE,
      "transition": transition1,
    },
    {
      "source": FrameType.IDLE,
      "target": FrameType.FOCUS,
      "transition": transition2,
    },
    {
      "source": FrameType.FOCUS,
      "target": FrameType.IDLE,
      "transition": transition3,
    },
    {
      "source": FrameType.IDLE,
      "target": FrameType.FLY_LEFT,
      "transition": transition4,
    },
    {
      "source": FrameType.FLY_LEFT,
      "target": FrameType.IDLE,
      "transition": transition5,
    },
    {
      "source": FrameType.IDLE,
      "target": FrameType.FLIP,
      "transition": transition6,
    },
    {
      "source": FrameType.FLIP,
      "target": FrameType.IDLE,
      "transition": transition7,
    },
  ];
  var state_maps = U.setup_anim_state_machine_transitions(state_machine, transition_metadatas);
  valid_target_to_source_map = state_maps["valid_target_to_source_map"];
  valid_source_to_target_map = state_maps["valid_source_to_target_map"];
  var anim_node_blend_tree = AnimationNodeBlendTree.new();
  anim_node_blend_tree.add_node("state_machine", state_machine);
  anim_node_blend_tree.connect_node("output", 0, "state_machine");
  anim_tree.tree_root = anim_node_blend_tree;
  anim_tree.active = true;
  # NOTE: .travel(str(FrameType.IDLE)) used to init the state_machine into idle if using AdvanceMode.ADVANCE_MODE_ENABLED for transition1
  # NOTE: creating a blank playback doesnt seem to do anything either way
  # anim_tree.set("parameters/state_machine/playback", AnimationNodeStateMachinePlayback.new())
  anim_tree.get("parameters/state_machine/playback").travel(str(FrameType.IDLE))
  return anim_tree;

# # NOTE: full_manual_animations - seems to work - no state_machine
# #  bezier works with this
# func travel():
#   if frame_type == FrameType.FOCUS:
#     anim_player.play("r/focus_start");
#   elif frame_type == FrameType.IDLE:
#     if last_internal_signal == INTERNAL_SIGNAL.FOCUS_END:
#       anim_player.play("r/focus_end");
#     else:
#       anim_player.play("r/idle");

func _mk_focus_start() -> Animation:
  var anim: Animation = Animation.new();
  anim.resource_name = "";
  anim.length = 0.35;
  # anim.loop = true;
  anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var transition_curve = 0.19;
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  anim.track_insert_key(track_idx_0, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"], transition_curve);
  anim.track_insert_key(track_idx_0, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"] * _scale_focus_mod);
  var track_idx_1 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_1, NodePath(String(base_decor.get_path())+":scale"));
  anim.track_insert_key(track_idx_1, 0.0, anim_manager.anim_metadata["base_decor"]["og_props"]["scale"]["value"], transition_curve);
  anim.track_insert_key(track_idx_1, anim.length, anim_manager.anim_metadata["base_decor"]["og_props"]["scale"]["value"] * _base_decor_scale_focus_mod);
  var track_idx_2 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_2, NodePath(String(entity_main.get_path())+":scale"));
  anim.track_insert_key(track_idx_2, 0.0, anim_manager.anim_metadata["entity_main"]["og_props"]["scale"]["value"], transition_curve);
  anim.track_insert_key(track_idx_2, anim.length, anim_manager.anim_metadata["entity_main"]["og_props"]["scale"]["value"] * _entity_main_scale_focus_mod);
  var track_idx_3 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_3, NodePath(String(base_bg_shadow.get_path())+":scale"));
  anim.track_insert_key(track_idx_3, 0.0, anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["scale"]["value"], transition_curve);
  anim.track_insert_key(track_idx_3, anim.length, anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["scale"]["value"] * _base_bg_shadow_scale_focus_mod);
  var track_idx_4 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_4, NodePath(String(wrapper.get_path())+":z_index"));
  anim.track_insert_key(track_idx_4, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["z_index"]["value"]);
  anim.track_insert_key(track_idx_4, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["z_index"]["value"] + _zindex_mod);
  # # NOTE: TYPE_BEZIER doesnt appear to work with current state machine settings
  # # would be nice to figure out why animation state_machine is wrong
  # # else would be nice to have a manual transition state_machine if cant get full state_machine
  # # manually playing animations works - tested and it does play animations
  # var axises = ['x', 'y'];
  # for axis in axises:
  #   var track = anim.add_track(Animation.TYPE_BEZIER)
  #   anim.track_set_path(track, NodePath(String(wrapper.get_path()) + ":scale:"+axis))
  #   # anim.bezier_track_set_interpolation_type(track, Animation.BEZIER_INTERPOLATION_CUBIC)
  #   # anim.bezier_track_set_wrap_mode(track, Animation.LOOP_WRAP)
  #   var val = anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].x if axis == 'x' else anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].y
  #   anim.bezier_track_insert_key(track, 0.0, val, Vector2(-0.175, 0.0), Vector2(0.05, 0.0))
  #   anim.bezier_track_insert_key(track, 0.35, val * _scale_focus_mod, Vector2(-0.183, 0.0), Vector2(0.175, 0.0))
  return anim;

func _mk_focus_end() -> Animation:
  var anim = Animation.new();
  anim.resource_name = "";
  anim.length = 0.5;
  anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var transition_curve = 2.54;
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  anim.track_insert_key(track_idx_0, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"] * _scale_focus_mod, transition_curve);
  anim.track_insert_key(track_idx_0, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"]);
  var track_idx_1 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_1, NodePath(String(base_decor.get_path())+":scale"));
  anim.track_insert_key(track_idx_1, 0.0, anim_manager.anim_metadata["base_decor"]["og_props"]["scale"]["value"] * _base_decor_scale_focus_mod, transition_curve);
  anim.track_insert_key(track_idx_1, anim.length, anim_manager.anim_metadata["base_decor"]["og_props"]["scale"]["value"]);
  var track_idx_2 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_2, NodePath(String(entity_main.get_path())+":scale"));
  anim.track_insert_key(track_idx_2, 0.0, anim_manager.anim_metadata["entity_main"]["og_props"]["scale"]["value"] * _entity_main_scale_focus_mod, transition_curve);
  anim.track_insert_key(track_idx_2, anim.length, anim_manager.anim_metadata["entity_main"]["og_props"]["scale"]["value"]);
  var track_idx_3 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_3, NodePath(String(base_bg_shadow.get_path())+":scale"));
  anim.track_insert_key(track_idx_3, 0.0, anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["scale"]["value"] * _base_bg_shadow_scale_focus_mod, transition_curve);
  anim.track_insert_key(track_idx_3, anim.length, anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["scale"]["value"]);
  var track_idx_4 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_4, NodePath(String(wrapper.get_path())+":z_index"));
  anim.track_insert_key(track_idx_4, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["z_index"]["value"] + _zindex_mod);
  anim.track_insert_key(track_idx_4, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["z_index"]["value"]);
  return anim;

func _mk_fly_left_start() -> Animation:
  var anim = Animation.new();
  anim.resource_name = "";
  anim.length = 0.2;
  anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var transition_curve = 0.241;
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  anim.track_insert_key(track_idx_0, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"], transition_curve);
  anim.track_insert_key(track_idx_0, anim.length, Vector2(anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].x * _fly_scale_mod, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].y));
  var track_idx_1 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_1, NodePath(String(wrapper.get_path())+":rotation"));
  anim.track_insert_key(track_idx_1, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["rotation"]["value"], transition_curve);
  anim.track_insert_key(track_idx_1, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["rotation"]["value"] + _fly_rotation_mod);
  var track_idx_2 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_2, NodePath(String(wrapper.get_path())+":skew"));
  anim.track_insert_key(track_idx_2, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["skew"]["value"], transition_curve);
  anim.track_insert_key(track_idx_2, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["skew"]["value"] - _fly_skew_mod);
  return anim;

func _mk_fly_left_end() -> Animation:
  var anim = Animation.new();
  anim.resource_name = "";
  anim.length = 1.9;
  anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var transition_curve = -0.9;
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  anim.track_insert_key(track_idx_0, 0.0, Vector2(anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].x * _fly_scale_mod, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"].y), transition_curve);
  anim.track_insert_key(track_idx_0, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"]);
  var track_idx_1 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_1, NodePath(String(wrapper.get_path())+":rotation"));
  anim.track_insert_key(track_idx_1, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["rotation"]["value"] + _fly_rotation_mod, transition_curve);
  anim.track_insert_key(track_idx_1, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["rotation"]["value"]);
  var track_idx_2 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_2, NodePath(String(wrapper.get_path())+":skew"));
  anim.track_insert_key(track_idx_2, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["skew"]["value"] - _fly_skew_mod, transition_curve);
  anim.track_insert_key(track_idx_2, anim.length, anim_manager.anim_metadata["wrapper"]["og_props"]["skew"]["value"]);
  return anim;

func _mk_flip() -> Animation:
  var anim = Animation.new();
  anim.resource_name = "";
  anim.length = 2.0;
  var anim_quart_len = anim.length / 4;
  var anim_half_len = anim_quart_len * 2;
  anim.loop = true;
  # anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var transition_curve = 1.0;
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  var og_scale = anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"];
  anim.track_insert_key(track_idx_0, 0.0, og_scale, transition_curve);
  anim.track_insert_key(track_idx_0, anim_half_len, Vector2(og_scale.x * -1, og_scale.y));
  anim.track_insert_key(track_idx_0, anim.length, og_scale);
  var track_idx_1 = anim.add_track(Animation.TYPE_METHOD);
  anim.track_set_path(track_idx_1, NodePath(String(self.get_path())));
  anim.track_insert_key(track_idx_1, anim_quart_len, { "method": "flip_card", "args": [] });
  anim.track_insert_key(track_idx_1, anim_quart_len * 3, { "method": "flip_card", "args": [] });
  var track_idx_2 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_2, NodePath(String(base_bg_shadow.get_path())+":position"));
  var og_position = anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["position"]["value"];
  anim.track_insert_key(track_idx_2, 0.0, og_position, transition_curve);
  anim.track_insert_key(track_idx_2, anim_half_len, Vector2(og_position.x * -1, og_position.y), transition_curve);
  anim.track_insert_key(track_idx_2, anim.length, og_position);
  # NOTE: track_idx_3 shouldnt be needed but for some reason the base_bg_shadow seems to revert to scale = Vector2(1, 1)
  #  If we change the shadow to have a Vector2(1, 1) base be default, we shouldnt need track_idx_3
  var track_idx_3 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_3, NodePath(String(base_bg_shadow.get_path())+":scale"));
  anim.track_insert_key(track_idx_3, 0.0, anim_manager.anim_metadata["base_bg_shadow"]["og_props"]["scale"]["value"], transition_curve);
  return anim;

func _mk_idle() -> Animation:
  var anim = Animation.new();
  anim.resource_name = "";
  anim.length = 0.0;
  anim.set_loop_mode(Animation.LoopMode.LOOP_NONE);
  var track_idx_0 = anim.add_track(Animation.TYPE_VALUE);
  anim.track_set_path(track_idx_0, NodePath(String(wrapper.get_path())+":scale"));
  anim.track_insert_key(track_idx_0, 0.0, anim_manager.anim_metadata["wrapper"]["og_props"]["scale"]["value"]);
  return anim;

func _mk_RESET() -> Animation:
  return anim_manager.mk_RESET();
