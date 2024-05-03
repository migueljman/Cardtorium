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
## Minimum level of a log message that should be printed.
var log_level: DebugLevel = DebugLevel.LOG
## Allows overriding specific files with other debug levels
var file_log_levels: Dictionary = {}
## Stores the string form of each debug level
var level_strings: Array[String] = [
    "DEBUG", "LOG", "WARNING", "ERROR"
]



## Debug levels
enum DebugLevel {
    ## Very detailed, specific information.
    DEBUG,
    ## Only the important runtime information. Used to declutter log files.
    LOG,
    ## Something went sort of wrong.
    WARNING,
    ## Something went very wrong.
    ERROR
}

## Loads logging settings from a json configuration file.
## Returns whether or not the parsing was successful.
func from_json(filepath: String) -> bool:
    var json_file = FileAccess.open(filepath, FileAccess.READ)
    var json_string: String = json_file.get_as_text(true)
    json_file.close()
    var settings = JSON.parse_string(json_string)
    if settings == null:
        print("Invalid settings file")
        return false
    # Parses the settings dictionary
    for key in settings:
        var value = settings[key]
        # Checks for enabled key
        if key == 'enabled':
            if not value is bool:
                print('"enabled" must correspond to a boolean')
                return false
            enabled = value
        # Checks for default_output
        elif key == "default_output":
            add_output('', value)
        # Checks for whitelist
        elif key == "whitelist":
            if not value is Array:
                print('"whitelist" must be a string array')
                return false
            for item in value:
                if not item is String:
                    print('"whitelist" must be a string array')
                    return false
                whitelist.append(item)
        # Checks for blacklist
        elif key == "blacklist":
            if not value is Array:
                print('"blacklist" must be a string array')
                return false
            for item in value:
                if not item is String:
                    print('"blacklist" must be a string array')
                    return false
                blacklist.append(item)
        # Checks for output map
        elif key == "output":
            if not value is Dictionary:
                print('"output" must be a dictionary')
                return false
            for tag in value:
                var paths = value[tag]
                if not paths is Array:
                    print('"output[%s]" must be a list of filepaths' % tag)
                    return false
                output_dict[tag] = []
                for path in paths:
                    if not path is String:
                        print('"output[%s]" must be a list of filepaths' % tag)
                        return false
                    if path == 'stdout':
                        path = ''
                    add_output(tag, path)
        # Checks for debug levels
        elif key == "levels":
            var level_map = {
                "LOG": DebugLevel.LOG,
                "DEBUG": DebugLevel.DEBUG,
                "ERROR": DebugLevel.ERROR,
                "WARNING": DebugLevel.WARNING
            }
            if not value is Dictionary:
                print('"levels" must be a dictionary')
                return false
            for path in value:
                var level = value[path]
                if not level is String:
                    print('"levels[%s]" must be a debug level' % path)
                    return false
                var d_level = level_map.get(level)
                if d_level == null:
                    print('%s is not a valid debug level' % level)
                    return false
                if path == 'stdout':
                    path = ''
                file_log_levels[path] = d_level
        # Checks for invalid key
        else:
            print('"%s" is not a valid key' % key)
            return false
    return true
    

## Increments the indent level for each file corresponding to some object.
func indent(object: String):
    if object in blacklist:
        return
    elif whitelist and object in whitelist:
        return
    if object in output_dict:
        for filepath in output_dict[object]:
            indent_levels[filepath] += 1
    else:
        indent_levels[default_filepath] += 1

## Decrements the indent level for each file corresponding to some object.
func dedent(object: String):
    if object in blacklist:
        return
    elif whitelist and object in whitelist:
        return
    if object in output_dict:
        for filepath in output_dict[object]:
            indent_levels[filepath] = max(0, indent_levels[filepath] - 1)
    else:
        indent_levels[default_filepath] = max(0, indent_levels[default_filepath] - 1)

## Adds an output file for some object. If the object is the empty string,
## sets the default filepath instead. An empty string for filepath is
## interpreted as stdout.
func add_output(object: String = '', filepath: String = ''):
    # Opens the file
    var file = _open_file(filepath)
    # Adds the file as output for some object
    if object != '':
        if object not in output_dict:
            output_dict[object] = []
        elif filepath in output_dict[object]:
            return
        output_dict[object].append(filepath)
    else:
        default_filepath = filepath
        default_output = file

## Returns an open file from a filepath. If the path has not been seen yet,
## adds it to the open_files dictionary.
func _open_file(filepath: String):
    if filepath in open_files:
        return open_files[filepath]
    elif filepath != '':
        open_files[filepath] = FileAccess.open(filepath, FileAccess.WRITE)
        indent_levels[filepath] = 0
        return open_files[filepath]
    else:
        return null

## Sets the log level for some file. If the file is the empty string,
## sets the default log level.
func set_log_level(level: DebugLevel, file: String = ''):
    if file == '':
        log_level = level
    else:
        file_log_levels[file] = level

## Core functionality for sending a message.
## It's probably easier to just use [method log], [method debug],
## [method warning] and/or [method error].
func _send_message(object: String, message: String, level: DebugLevel):
    if not enabled:
        return
    # Checks if the object is blacklisted, or not whitelisted
    if object in blacklist:
        return
    elif whitelist and object not in whitelist:
        return
    # Checks where to send the message
    var outputs = [default_output]
    var filepaths = [default_filepath]
    if object in output_dict:
        outputs = []
        filepaths = []
        for path in output_dict[object]:
            filepaths.append(path)
            outputs.append(open_files[path])
    # Prints the message
    for i in range(len(outputs)):
        var output = outputs[i]
        var filepath = filepaths[i]
        if level < file_log_levels.get(filepath, log_level):
            continue
        if output == null:
            if level == DebugLevel.WARNING:
                print_rich('[color=yellow]WARNING (%s):[/color] %s' % [object, message])
            elif level == DebugLevel.ERROR:
                print_rich('[color=red]ERROR (%s):[/color] %s' % [object, message])
            else:
                print('(%s) %s' % [object, message])
        else:
            var indent_level = indent_levels[filepath]
            var indent_string: String = INDENT.repeat(indent_level)
            output.store_string('%s%s (%s): %s\n' % [indent_string, level_strings[level], object, message])

## Logs a message.
func log(object: String, message: String):
    _send_message(object, message, DebugLevel.LOG)

## Sends a debug message
func debug(object: String, message: String):
    _send_message(object, message, DebugLevel.DEBUG)

## Sends a warning.
func warning(object: String, message: String):
    _send_message(object, message, DebugLevel.WARNING)

## Sends an error.
func error(object: String, message: String):
    _send_message(object, message, DebugLevel.ERROR)