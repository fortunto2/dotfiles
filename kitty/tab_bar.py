from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

HINTS = "⌘D:│ ⌘⇧D:─ ⌘W:close ⌘K:claude ⌘E:files ^Tab:switch │ nvim: y=path Y=name"

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Tab colors
    if tab.is_active:
        screen.cursor.bg = as_rgb(0x3d3528)
        screen.cursor.fg = as_rgb(0xe8b059)
    else:
        screen.cursor.bg = as_rgb(0x2d2820)
        screen.cursor.fg = as_rgb(0xc4b495)

    # Draw tab
    title = f" {index}:{tab.title[:12]} "
    screen.draw(title)

    # Separator
    screen.cursor.bg = as_rgb(0x1a1610)
    screen.cursor.fg = as_rgb(0x4a4235)
    screen.draw(" ")

    # Hints after last tab
    if is_last:
        remaining = screen.columns - screen.cursor.x - len(HINTS) - 1
        if remaining > 0:
            screen.draw(" " * remaining)
        screen.cursor.fg = as_rgb(0x6a6255)
        screen.draw(HINTS)

    return screen.cursor.x
