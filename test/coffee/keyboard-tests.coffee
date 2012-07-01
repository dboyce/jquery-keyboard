{KeyCombination, Keys, KeyEventManager, commons} = jQuery.fn.keyboard

module "KeyCombination"

test "test simple key combination", ->
  space = new KeyCombination(Keys.space)
  space2 = new KeyCombination(Keys.space)

  equal(space.hash(), space2.hash())

test "test multi key combination", ->
  combo = new KeyCombination(Keys.space, Keys.ctl)
  combo2 = new KeyCombination(Keys.ctl, Keys.space)

  equal(combo.hash(), combo2.hash())

module "KeyEventManager",
  setup: ->
    @eventManager = new KeyEventManager new commons.Map(), "<input id='dummy'></input>"

test "test dispatch keydown event", ->
  keydownInvoked = false
  @eventManager.mappings.put(new KeyCombination(Keys.ctl, Keys.a), {down: -> keydownInvoked = true})

  @eventManager.keydown(which:Keys.ctl)

  ok not keydownInvoked

  @eventManager.keydown(which:Keys.a)

  ok keydownInvoked






#test "test single key binding", ->
#  pressed = false
#  released = false
#  keyboard.reset()
#  key_bindings ->
#    @bind(@a).up(->
#        released = true
#    ).down ->
#      pressed = true
#
#  keyboard.key_down which: 65
#  ok pressed
#  keyboard.key_up which: 65
#  ok released

#test "test key combination binding", ->
#  pressed = false
#  released = false
#  keyboard.reset()
#  key_bindings ->
#    @bind(@shift, @a).up(->
#        released = true
#    ).down ->
#      pressed = true
#
#  keyboard.key_down which: 65
#  ok not pressed
#  keyboard.key_down which: 16
#  ok pressed
#
#test "test trigger key_down", ->
#  a = 0
#  shift_a = 0
#  c = 0
#  keyboard.reset()
#  key_bindings ->
#    @bind(@b).down ->
#      a++
#
#    @bind(@a).down ->
#      c++
#
#    @bind(@shift, @b).up(@redispatch).down ->
#      shift_a++
#
#  keyboard.key_down which: keys.shift
#  equal shift_a, 0
#  equal a, 0
#  keyboard.key_down which: keys.b
#  equal shift_a, 1
#  equal a, 0
#  keyboard.key_up which: keys.shift
#  equal shift_a, 1
#  equal a, 1