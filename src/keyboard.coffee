########################################################
# some basic collections
########################################################

next_oid = 0
get_oid = ->
  next_oid++

ObjectKeyAdapter =
  oid: (o)->
    o.m_oid = get_oid()  unless o.m_oid?
    o.m_oid
  hash: (o) ->
    @oid(o)
  equals: (o, other) ->
    oid(other) is @oid(o)

PrimitiveKeyAdapter =
  hash: (o) -> o.valueOf()
  oid: -> o.valueOf()
  equals: (o, other) ->
    o.valueOf is oid(other)

adapt = (o) ->
  type = typeof o
  if type is 'number' or type is 'string' or type is 'boolean'
    return PrimitiveKeyAdapter
  else
    return ObjectKeyAdapter

########################################################
# convenience functions for hashcode/equals
########################################################
oid = (o) -> if o.oid? then o.oid() else adapt(o).oid(o)
hash = (o) -> if o.hash? then o.hash() else adapt(o).hash(o)
equals = (o, other) -> if o.equals? then o.equals(other) else adapt(o).equals(o, other)



########################################################
# doesn't currently handle collisions, but for default
# implementation of hash() collisions aren't possible...
########################################################
class Set
  constructor: ->
    @coll = {}

  add: (obj) ->

    @coll[hash(obj)] = obj

  contains: (obj) ->
    @coll[hash(obj)]?

  remove: (obj) ->
    delete @coll[hash(obj)]

  values: ->
    ret = new Array()
    for key of @coll when @coll.hasOwnProperty(key) and @coll[key]?
      ret.push @coll[key]
    ret

  clear: ->
    @coll = {}

########################################################
# doesn't currently handle collisions, but for default
# implementation of hash() collisions aren't possible...
########################################################
class Map
  constructor: ->
    @coll = {}

  put: (key, value) ->
    @coll[hash(key)] = value

  get: (key) ->
    @coll[hash(key)]

OidSupport =
  hash: hash
  oid: oid
  equals: equals


########################################################
# key codes....
########################################################
Keys =
  backspace: 8
  tab: 9
  enter: 13
  shift: 16
  ctl: 17
  alt: 18
  brk: 19
  caps: 20
  esc: 27
  space: 32
  pg_up: 33
  pg_dwn: 34
  end: 35
  home: 36
  arw_left: 37
  arw_up: 38
  arw_right: 39
  arw_down: 40
  insert: 45
  dlt: 46
  0: 48
  1: 49
  2: 50
  3: 51
  4: 52
  5: 53
  6: 54
  7: 55
  8: 56
  9: 57
  a: 65
  b: 66
  c: 67
  d: 68
  e: 69
  f: 70
  g: 71
  h: 72
  i: 73
  j: 74
  k: 75
  l: 76
  m: 77
  n: 78
  o: 79
  p: 80
  q: 81
  r: 82
  s: 83
  t: 84
  u: 85
  v: 86
  w: 87
  x: 88
  y: 89
  z: 90

########################################################
# identify a combination of keystrokes
########################################################
class KeyCombination
  constructor: (args...) ->
    args = args[0] if args[0] instanceof Array
    args.sort()
    prime = 31
    @mHash = 1
    for arg in args
      @mHash = prime * @mHash + (if arg? then OidSupport.hash(arg) else 0)

  hash: -> @mHash

########################################################
# maps keystrokes to actions
########################################################
class KeyEventManager
  constructor: (@mappings, @element) ->
    @mappings = new Map() unless @mappings
    @focus()
    $(@element).focus(@focus).keydown(@keydown).keyup(@keyup)

  combo: ->
    new KeyCombination(@activeKeys.values())

  context: (key, target) ->
    key: key
    dispatcher: @
    keys: @activeKeys
    target: target

  focus: =>
      @activeKeys = new Set()

  keydown: (e) =>
    @activeKeys.add(e.which)
    mapping = @mappings.get(@combo())
    mapping.down.call(e.target, @context(e.which, e.target)) if mapping?.down?

  keyup: (e) =>
    @activeKeys.remove(e.which)
    mapping = @mappings.get(@combo())
    maping.up.call(e.target, @context(e.which, e.target)) if mapping?.up?


jQuery.fn.keyboard = plugin = (block) ->
  @.each ->
    mappings = new Map()
    block.apply(_.extend(Keys,
      bind:(keys...) ->
        combo = new KeyCombination(keys)
        mapping = {}
        mappings.put combo, mapping
        down: (fn) ->
          mapping.down = fn
        up: (fn) ->
          mapping.up = fn
    ))
    keyMan = new KeyEventManager(mappings, $(@))


# for testing...
plugin.Keys = Keys
plugin.KeyCombination = KeyCombination
plugin.KeyEventManager = KeyEventManager
plugin.commons =
  Set : Set
  Map : Map
  OidSupport : OidSupport

