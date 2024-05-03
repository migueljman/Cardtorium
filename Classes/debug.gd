extends Node

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
## Empty string defaults to stdout.
var default_filepath: String = ''
## Default location to send information to.
## null defaults to stdout.
var default_output = null
## Determines the indent level of a log file.
## Allows functions and such to format the log file better.
var indent_levels: Dictionary = {'': 0}
## Stores what files have been opened.
var open_files: Dictionary = {'': null}

## Increments the indent level for some file.
func indent(object: String):
    if object in output_dict:
        var filepath = output_dict[object]
        indent_levels[filepath] += 1
    else:
        indent_levels[default_filepath] += 1

## Decrements the indent level for some file.
func dedent(object: String):
    if object in indent_levels:
        var filepath = output_dict[object]
        indent_levels[filepath] = max(0, indent_levels[filepath] - 1)
    else:
        indent_levels[default_filepath] = max(0, indent_levels[default_filepath] - 1)

## Sets the output file for some object. If filepath is the empty string,
## sends output to the console. If object is the empty string, sets the
## default output.
func set_output(object: String = '', filepath: String = ''):
    var file = null
    # Opens the file if the filepath exists
    if filepath in open_files:
        file = open_files[filepath]
    elif filepath != '':
        open_files[filepath] = FileAccess.open(filepath, FileAccess.WRITE)
        indent_levels[filepath] = 0
        file = open_files[filepath]
    # Adds the file as output for some object
    if object != '':
        output_dict[object] = filepath
    else:
        default_filepath = filepath
        default_output = file

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
    var output = default_output
    var filepath = default_filepath
    if object in output_dict:
        filepath = output_dict[object]
        output = open_files[filepath]
    # Prints the message
    if output == null:
        print('(%s) %s' % [object, message])
    else:
        var indent_level = indent_levels[filepath]
        var indent_string: String = INDENT.repeat(indent_level)
        output.store_string('%s(%s) %s\n' % [indent_string, object, message])