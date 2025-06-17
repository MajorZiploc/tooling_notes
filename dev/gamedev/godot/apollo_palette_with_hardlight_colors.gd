class ColorRampEntry:
  var base: Color;
  var shadow_1: Color;
  var shadow_2: Color;
  var highlight_1: Color;
  var highlight_2: Color;
  func _init(_base, _shadow_1, _shadow_2, _highlight_1, _highlight_2):
    self.base = _base;
    self.shadow_1 = _shadow_1;
    self.shadow_2 = _shadow_2;
    self.highlight_1 = _highlight_1;
    self.highlight_2 = _highlight_2;

var blue_color_ramp = [
  ColorRampEntry.new('#172038', '#0d1124', '#060713', '#5b5e88', '#b4b4ce'),
  ColorRampEntry.new('#253a5e', '#141f3c', '#090e1f', '#65719f', '#b9bdd7'),
  ColorRampEntry.new('#3c5e8b', '#213258', '#0f162e', '#758bba', '#c0c9e2'),
  ColorRampEntry.new('#4f8fba', '#2b4c76', '#13213d', '#83aed6', '#c7daee'),
  ColorRampEntry.new('#73bed3', '#3f6586', '#1c2c45', '#9cd0e5', '#d2e9f4'),
  ColorRampEntry.new('#a4dddb', '#5a768b', '#283448', '#bfe6ea', '#e2f3f6'),
];

var green_color_ramp = [
  ColorRampEntry.new('#19332d', '#0e1b1d', '#060c0f', '#5d6c82', '#b5bbcb'),
  ColorRampEntry.new('#25562e', '#142e1d', '#09140f', '#658582', '#b9c7cb'),
  ColorRampEntry.new('#468232', '#264520', '#111e11', '#7ca585', '#c3d5cc'),
  ColorRampEntry.new('#75a743', '#40592b', '#1d2716', '#9ec08f', '#d3e2d0'),
  ColorRampEntry.new('#a8ca58', '#5c6c38', '#292f1d', '#c2d99b', '#e3edd5'),
  ColorRampEntry.new('#d0da91', '#72745c', '#333330', '#dee4bd', '#f0f3e4'),
];

var skin_color_ramp = [
  ColorRampEntry.new('#4d2b32', '#442024', '#3c181a', '#816685', '#c6b8cc'),
  ColorRampEntry.new('#7a4841', '#6b362f', '#5e2822', '#a17b8e', '#d4c2d0'),
  ColorRampEntry.new('#ad7757', '#98593f', '#86422e', '#c59d9b', '#e5d2d5'),
  ColorRampEntry.new('#c09473', '#a96e54', '#94523d', '#d3b2ac', '#ebdbdc'),
  ColorRampEntry.new('#d7b594', '#bd876c', '#a6654f', '#e3cabf', '#f2e6e4'),
  ColorRampEntry.new('#e7d5b3', '#cb9f83', '#b27660', '#eee1d2', '#f7f1ec'),
];

var brown_color_ramp = [
  ColorRampEntry.new('#241527', '#140b19', '#09050d', '#64567e', '#b8b1c9'),
  ColorRampEntry.new('#341c27', '#1d0f19', '#0d070d', '#705b7e', '#beb3c9'),
  ColorRampEntry.new('#602c2c', '#35171c', '#180a0e', '#8f6781', '#ccb9cb'),
  ColorRampEntry.new('#884b2b', '#4b281b', '#22120e', '#ab7d81', '#d9c3cb'),
  ColorRampEntry.new('#be772b', '#683f1b', '#2e1c0e', '#d19d81', '#ead2cb'),
  ColorRampEntry.new('#e8c170', '#7f6747', '#392d25', '#efd2aa', '#f8eadc'),
];

var red_color_ramp = [
  ColorRampEntry.new('#411d31', '#240f1f', '#100710', '#795c84', '#c2b4cc'),
  ColorRampEntry.new('#752438', '#401324', '#1d0813', '#9e6188', '#d3b6ce'),
  ColorRampEntry.new('#a53030', '#5b1a1e', '#290b10', '#bf6a84', '#e2bacc'),
  ColorRampEntry.new('#cf573c', '#722e26', '#331414', '#dd868b', '#f0c7cf'),
  ColorRampEntry.new('#da863e', '#784727', '#361f14', '#e5a88c', '#f3d7cf'),
  ColorRampEntry.new('#de9e41', '#7a5429', '#372515', '#e8b98e', '#f5dfd0'),
];

var purple_color_ramp = [
  ColorRampEntry.new('#1e1d39', '#100f24', '#070713', '#605c89', '#b7b4ce'),
  ColorRampEntry.new('#402751', '#231533', '#10091a', '#786397', '#c2b7d4'),
  ColorRampEntry.new('#7a367b', '#431d4e', '#1e0d28', '#a16eb0', '#d4bcde'),
  ColorRampEntry.new('#a23e8c', '#592159', '#280e2e', '#bd74ba', '#e1bfe2'),
  ColorRampEntry.new('#c65197', '#6d2b60', '#311332', '#d781c1', '#edc5e5'),
  ColorRampEntry.new('#df84a5', '#7a4669', '#371f36', '#e8a6c9', '#f5d6e9'),
];

var gray_color_ramp = [
  ColorRampEntry.new('#090a14', '#05050d', '#020207', '#514e73', '#b0adc5'),
  ColorRampEntry.new('#10141f', '#090b14', '#04050a', '#565579', '#b2b0c7'),
  ColorRampEntry.new('#151d28', '#0c0f19', '#05070d', '#5a5c7f', '#b4b4ca'),
  ColorRampEntry.new('#202e37', '#121923', '#080b12', '#626888', '#b8b9ce'),
  ColorRampEntry.new('#394a50', '#1f2733', '#0e111a', '#737c97', '#bfc2d4'),
  ColorRampEntry.new('#577277', '#303d4c', '#151b27', '#8899ae', '#c9d0dd'),
  # next row
  ColorRampEntry.new('#819796', '#47515f', '#202431', '#a6b4c0', '#d7dce5'),
  ColorRampEntry.new('#a8b5b2', '#5c6171', '#292b3a', '#c2cad1', '#e3e6ec'),
  ColorRampEntry.new('#c7cfcc', '#6d6e82', '#313043', '#d7dce1', '#edeff3'),
  ColorRampEntry.new('#ebede9', '#817e94', '#3a374d', '#f1f2f2', '#f9f9fa'),
];
