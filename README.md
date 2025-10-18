# Polybar Playing Track

Polybar module for displaying currently playing track using `playerctl`.

Features:
- Scrollable text for displaying track metadata
- Clickable control buttons
- Customizable output format

## Demo

Scrolling demo:

<img src="https://gist.githubusercontent.com/imbalet/0182832f565b3ebcd169e5d998a68ed5/raw/aead4d156cfdd06158152479444eb481c1857f95/scroll.gif" alt="gif" height=80px>


Audio control demo:

<img src="https://gist.githubusercontent.com/imbalet/0182832f565b3ebcd169e5d998a68ed5/raw/78acdeda9fc24fdff4e27c188079a7e359b00375/click.gif" alt="gif" height=80px>


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
```

## Config

You can set up script variables to configure output:

`LENGTH` - default `30`  
Maximum length (in characters) of track metadata to display. If the length of track metadata exceeds this limit, scrolling will be enabled.

`SLEEP_ON_SCROLL` - default `0.15`  
Time in seconds per symbol during scrolling.

`SLEEP_ON_START` - default `0.5`  
Additional delay in seconds when the scroll reaches the beginning of the metadata text. The final delay is `SLEEP_ON_START + SLEEP_ON_SCROLL`

`PLAY_ICON` - default `▶`  
Symbol for the play button.

`PAUSE_ICON` - default `‖`  
Symbol for the pause button.

`NEXT_ICON` - default `»`  
Symbol for the next track button.

`PREV_ICON` - default `«`  
Symbol for the previous track button.

`SCROLL_PADDING` - default `    `  
Separator text displayed between the end and start of scrolling text.
Use spaces or custom characters to create visual spacing during the scroll loop.

`OUTPUT_FORMAT` - default `'%scrolled_text% | %prev% %middle_icon% %next% | %padding%'`  
String for formatting the output.

`PLAY_BUTTON` - default `"%{A:playerctl play:}$PLAY_ICON%{A}"`  
`PAUSE_BUTTON` - default `"%{A:playerctl pause:}$PAUSE_ICON%{A}"`  
`NEXT_BUTTON` - default `"%{A:playerctl next:}$NEXT_ICON%{A}"`  
`PREV_BUTTON` - default `"%{A:playerctl previous:}$PREV_ICON%{A}"`  
Low-level control for the button text. Can be used to set up custom click action. `$PLAY_ICON`, `$PAUSE_ICON`, `$NEXT_ICON`, `$PREV_ICON` can be used inside these button definitions.  

You can specify custom actions using polybar formatting. Example:
```
%{A1:command:} clickable text %{A}
```
Learn more about polybar formatting in the wiki: [Formatting](https://github.com/polybar/polybar/wiki/Formatting).


You can set these variables on starting the script:
```ini
"LENGTH=40 SLEEP_ON_SCROLL=0.2 bash /path/to/script.sh"
```

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