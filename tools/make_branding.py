#!/usr/bin/env python3
"""Builds the app branding assets from assets/branding/logo-source.jpg.

The source is a 1024x1024 rounded-square app icon (gradient + mascot) whose
transparent area is a baked-in checkerboard. The mascot cannot be cut out
cleanly (blue on blue), so the whole rounded square is used and the outside is
filled with the brand gradient. Replace the source with a transparent mascot
PNG to get a proper adaptive foreground + monochrome icon.

Usage: python3 tools/make_branding.py app/assets/branding
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

out = Path(sys.argv[1])
src = Image.open(out / "logo-source.jpg").convert("RGB")
W, H = src.size


def is_blue(p):
    r, g, b = p
    return b > 150 and b - r > 60


row = [is_blue(src.getpixel((x, H // 2))) for x in range(W)]
col = [is_blue(src.getpixel((W // 2, y))) for y in range(H)]
x0, x1 = row.index(True), W - 1 - row[::-1].index(True)
y0, y1 = col.index(True), H - 1 - col[::-1].index(True)
side = min(x1 - x0, y1 - y0)
# stay clear of the rounded corners (checkerboard behind them)
inset = int(side * 0.045)
square = src.crop((x0 + inset, y0 + inset, x0 + side - inset, y0 + side - inset))
side = square.size[0]
radius = int(side * 0.14)
mask = Image.new("L", (side, side), 0)
ImageDraw.Draw(mask).rounded_rectangle((0, 0, side - 1, side - 1), radius=radius, fill=255)


def patch_color(cx, cy, r=12):
    px = [square.getpixel((x, y)) for x in range(cx - r, cx + r) for y in range(cy - r, cy + r)]
    return tuple(sum(p[i] for p in px) // len(px) for i in range(3))


m = radius
corners = {
    "tl": patch_color(m, m), "tr": patch_color(side - m, m),
    "bl": patch_color(m, side - m), "br": patch_color(side - m, side - m),
}


def gradient(size):
    """Bilinear blend of the logo's corner colors (matches its own gradient)."""
    small = Image.new("RGB", (2, 2))
    small.putpixel((0, 0), corners["tl"])
    small.putpixel((1, 0), corners["tr"])
    small.putpixel((0, 1), corners["bl"])
    small.putpixel((1, 1), corners["br"])
    return small.resize((size, size), Image.BILINEAR)


def full_bleed(size, scale):
    """Square image: gradient background + logo square (soft edge) scaled to `scale`."""
    canvas = gradient(size)
    s = int(size * scale)
    soft = Image.new("L", (s, s), 0)
    f = max(4, s // 14)
    ImageDraw.Draw(soft).rounded_rectangle((f, f, s - 1 - f, s - 1 - f), radius=int(s * 0.14), fill=255)
    soft = soft.filter(ImageFilter.GaussianBlur(f / 2))
    canvas.paste(square.resize((s, s), Image.LANCZOS), ((size - s) // 2, (size - s) // 2), soft)
    return canvas


# mascot tile for the UI (rounded corners transparent)
tile = square.resize((512, 512), Image.LANCZOS).convert("RGBA")
tile.putalpha(mask.resize((512, 512), Image.LANCZOS))
tile.save(out / "mascot.png")

# legacy launcher icon (Android < 8): full square
full_bleed(1024, 0.94).save(out / "icon-legacy.png")
# adaptive foreground: content scaled into the 66/108 safe zone over the gradient,
# so the visible circle/squircle shows the full mascot
full_bleed(1024, 0.70).save(out / "icon-foreground.png")
# splash (Android 12 shows the icon inside a circle of 2/3 size)
logo = square.resize((768, 768), Image.LANCZOS).convert("RGBA")
logo.putalpha(mask.resize((768, 768), Image.LANCZOS))
logo.save(out / "splash.png")
a12 = Image.new("RGBA", (1152, 1152), (0, 0, 0, 0))
a12.paste(logo, (192, 192), logo)
a12.save(out / "splash-android12.png")
# store / F-Droid icon 512x512
full_bleed(512, 0.94).save(out / "store-icon.png")
print("bounds", x0, y0, side, "corners", corners)
