module "Set",
  setup: ->
    @set = new jQuery.fn.keyboard.commons.Set

test "test contains", ->

  obj1 = {foo: 'foo'}
  obj2 = {foo: 'bar'}
  obj3 = {foo: 'baz'}

  @set.add(obj1)
  @set.add(obj2)

  ok(@set.contains(obj1))
  ok(@set.contains(obj2))
  ok(not @set.contains(obj3))

test "custom hashcode/equals methods", ->

  class Doofer
    constructor: (@name) ->
    hash: ->  @name
    equals: (other) -> other.name == @name
    oid: -> @name

  obj1 = new Doofer("foo")
  obj2 = new Doofer("bar")
  obj3 = new Doofer("foo")

  @set.add(obj1)
  @set.add(obj2)

  ok(@set.contains(obj1))
  ok(@set.contains(obj2))
  ok(@set.contains(obj3))


