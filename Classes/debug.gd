extends Node

## Used to store data on a game
class_name DebugLog

## How many spaces to use per indent
var INDENT: String = '    '
## Whether or not logging is enabled at all
var enabled: bool = false
## If this list is non-empty, only objects that match a name in this
## list will be logged.
var whitelist: Array[String] = []
## Any object whose name is in this list will not be logged.
var blacklist: Array[String] = []
## Dictionary which determines where to send log information.
var output_dict: Dictionary = {}
## Default file to send log information to.
## Can write to it using store_string if it is not null.
## null is interpreted as stdout.
var default_file = null
## Determines the indent level of a log.
## Allows functions and such to format the log file better.
var indent_level = 0


## Logs a message.
func log(object: String, message: String):
    if not enabled:
        return
    # Checks if the object is blacklisted, or not whitelisted
    if object in blacklist:
        return
    elif whitelist and object not in whitelist:
        return
    # Checks where to send the message
    var output = default_file
    if object in output_dict:
        output = output_dict[object]
    # Prints the message
    if output == null:
        print('(%s) %s' % [object, message])
    else:
        var indent: String = INDENT.repeat(indent_level)
        output.store_string('%s(%s) %s' % [indent, object, message])