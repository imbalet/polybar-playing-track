# Polybar Playing Track

Polybar module for displaying currently playing track using `playerctl`.

Features:
- Scrollable text for displaying track metadata
- Clickable control buttons
- Customizable output format
- Support for multiple sources

## Demo

Scrolling demo:

<img src="https://gist.githubusercontent.com/imbalet/0182832f565b3ebcd169e5d998a68ed5/raw/aead4d156cfdd06158152479444eb481c1857f95/scroll.gif" alt="gif" height=80px>


Audio control demo:

<img src="https://gist.githubusercontent.com/imbalet/0182832f565b3ebcd169e5d998a68ed5/raw/78acdeda9fc24fdff4e27c188079a7e359b00375/click.gif" alt="gif" height=80px>

Config:

```ini
[module/track]
type = custom/script
tail = true
format = %{F#BD93F9}%{T3}<label>%{F-}
exec = "OUTPUT_FORMAT='󰎇 %track_metadata%%padding% | %prev_icon% %middle_icon% %next_icon% |' LENGTH=40 PLAY_ICON= PAUSE_ICON= NEXT_ICON=󰒭 PREV_ICON=󰒮 bash /home/imbalet/repos/mine/polybar-playing-track/script.sh"
click-right = "kill -USR1 %pid%"
```

The font `JetBrainsMono Nerd Font Propo` was used to display icons.

## Dependencies

- [playerctl](https://github.com/altdesktop/playerctl)


## Installing

0. Make sure you have installed `playerctl` in your system.

1. Clone the repo:

   ```bash
   git clone https://github.com/imbalet/polybar-playing-track
   ```

   Or download the script directly:

   ```bash
   wget https://raw.githubusercontent.com/imbalet/polybar-playing-track/refs/heads/main/script.sh
   ```

   or use curl:

   ```bash
   curl -O https://raw.githubusercontent.com/imbalet/polybar-playing-track/refs/heads/main/script.sh
   ```

2. Make the script executable:

   ```bash
   # Go to the script directory:
   cd polybar-playing-track

   # Make it executable
   chmod +x script.sh
   ```

3. Put [example config](#example-configuration) in your `polybar.ini`. The full path should be something like `~/.config/polybar/config.ini`  
    Use `realpath ./script.sh` to get the full path to the script to use in polybar config.



## Example configuration

```ini
[module/track]
type = custom/script
exec = "bash /path/to/script.sh"
tail = true
click-right = "kill -USR1 %pid%"
```

## Changing source

Changing sources is implemented via right-click on the module in the bar. You can specify your custom action, such as `click-(left|middle|right)` or `scroll-(up|down)`.

## Config

You can set these variables on starting to configure script parameters:
```ini
exec = "LENGTH=40 SLEEP_ON_SCROLL=0.2 bash /path/to/script.sh"
```

Available parameters:

`LENGTH`  
default `30`  
Maximum length (in characters) of track metadata to display. If the length of track metadata exceeds this limit, scrolling will be enabled.

`SLEEP_ON_SCROLL`  
default `0.15`  
Time in seconds per symbol during scrolling.

`SLEEP_ON_START`  
default `0.5`  
Additional delay in seconds when the scroll reaches the beginning of the metadata text. The final delay is `SLEEP_ON_START + SLEEP_ON_SCROLL`

`PLAY_ICON`  
default `▶`  
Symbol for the play button.

`PAUSE_ICON`  
default `‖`  
Symbol for the pause button.

`NEXT_ICON`  
default `»`  
Symbol for the next track button.

`PREV_ICON`  
default `«`  
Symbol for the previous track button.

`SCROLL_PADDING`  
default `    `  
Separator text displayed between the end and start of scrolling text.
Use spaces or custom characters to create visual separation between the end and start of the scrolling text.

`OUTPUT_FORMAT`  
default `'%scrolled_text% | %prev% %middle_icon% %next% | %padding%'`  
String for formatting the output.

`EMPTY_OUTPUT_FORMAT`  
default `'Not playing | %prev_icon% %middle_icon% %next_icon% | %padding%'`  
String for formatting the empty output. 


## Formatting

The module supports output formatting using format strings.

Supported placeholders:

`%track_metadata%` - A string with track metadata in the format `<artist> - <track_name>`. 
If the length of track metadata is greater than the LENGTH parameter, scrolling will be enabled. The length of this string is always less than or equal to the `LENGTH` parameter.

`%padding%` - A string of spaces added to make the total length equal to the `LENGTH` parameter.

`%prev_icon%` - Previous track button.

`%middle_icon%` - Play/pause button.

`%next_icon%` - Next track button.



You can combine these placeholders. Example:

```
'%track_metadata% | %prev_icon% %middle_icon% %next_icon% | %padding%'
```

```
'Artist - title | « ▶ » |       '
```

Another example:

```
'%track_metadata%%padding%| %prev_icon% %middle_icon% %next_icon% |'
```

```
'Artist - title      | « ▶ » |'
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.