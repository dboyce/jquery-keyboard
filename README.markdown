# jquery-keyboard

## About

A simple jQuery plugin for easily binding keyboard shortcuts.

Example here: http://dboyce.github.com/jquery-keyboard/sample/

## Usage

```coffee
$('input.my-input').keyboard ->
  @bind(@ctl, @enter).down ->
    alert('you pressed control and enter!')
  @bind(@ctl, @shift).down ->
    alert('you pressed control and shift')    
```
It's worth noting that event handlers are not directly bound to selected events, but rather, delegate events are used;
this means that elements inserted after this code has run will still inherit the behaviour.

## Dependencies

Requires jQuery and underscore (to be removed)

```html
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/underscore-min.js"></script>
    <script type="text/javascript" src="js/jquery-keyboard.js"></script>
```



