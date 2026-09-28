#!/usr/bin/env python3
"""Cek aset ilustrasi Wister Lite.

Aturan:
- Setiap SVG < 8 KB dan XML valid.
- assets/illustrations/** hanya memakai warna dari kontrak palet
  (di-remap ke token tema saat runtime) dan tanpa fitur yang tidak didukung.
- Ikon kategori assets/uil_*.svg hanya memakai #FFFFFF (di-tint via srcIn).
- assets/lottie/*.json adalah JSON Lottie yang valid secara struktur.

Jalankan dari root repo: python3 tool/check_illustrations.py
"""
import glob
import json
import os
import re
import sys
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAX = 8 * 1024
PALETTE = {"#1B2430", "#0E8C7F", "#CDEFE9", "#FFB547", "#FFE7C2",
           "#FFFFFF", "#1E9E5A", "#F0634A", "#F2A7B5"}
BANNED_TAGS = {"style", "linearGradient", "radialGradient", "filter", "mask",
               "text", "image", "font", "clipPath", "use", "foreignObject"}
COLOR_ATTRS = ("fill", "stroke", "stop-color", "color")
errors = []


def check_svg(path, allowed):
    rel = os.path.relpath(path, ROOT)
    size = os.path.getsize(path)
    if size >= MAX:
        errors.append(f"{rel}: {size} B (maks {MAX})")
    try:
        tree = ET.parse(path)
    except ET.ParseError as e:
        errors.append(f"{rel}: XML tidak valid ({e})")
        return
    for el in tree.iter():
        tag = el.tag.split("}")[-1]
        if tag in BANNED_TAGS:
            errors.append(f"{rel}: elemen <{tag}> tidak diizinkan")
        if "style" in el.attrib:
            errors.append(f"{rel}: atribut style tidak diizinkan")
        for a in COLOR_ATTRS:
            v = el.attrib.get(a)
            if v is None or v in ("none", "currentColor"):
                continue
            if not re.fullmatch(r"#[0-9A-F]{6}", v):
                errors.append(f"{rel}: {a}='{v}' harus hex 6 digit huruf besar")
            elif v not in allowed:
                errors.append(f"{rel}: warna {v} di luar kontrak")
    return size


def check_lottie(path):
    rel = os.path.relpath(path, ROOT)
    if os.path.getsize(path) >= MAX:
        errors.append(f"{rel}: lebih dari 8 KB")
    try:
        d = json.load(open(path))
    except ValueError as e:
        errors.append(f"{rel}: JSON tidak valid ({e})")
        return
    for k in ("v", "fr", "ip", "op", "w", "h", "layers"):
        if k not in d:
            errors.append(f"{rel}: kunci '{k}' tidak ada")
    for i, layer in enumerate(d.get("layers", [])):
        for k in ("ty", "ks", "ip", "op"):
            if k not in layer:
                errors.append(f"{rel}: layer {i} tanpa '{k}'")
        if layer.get("ty") == 4 and not layer.get("shapes"):
            errors.append(f"{rel}: shape layer {i} tanpa shapes")


def main():
    rows = []
    for p in sorted(glob.glob(os.path.join(ROOT, "assets/illustrations/**/*.svg"), recursive=True)):
        rows.append((p, check_svg(p, PALETTE)))
    icons = sorted(glob.glob(os.path.join(ROOT, "assets/uil_*.svg")))
    if len(icons) != 9:
        errors.append(f"ikon kategori harus 9 file, ada {len(icons)}")
    for p in icons:
        rows.append((p, check_svg(p, {"#FFFFFF"})))
    for p in sorted(glob.glob(os.path.join(ROOT, "assets/lottie/*.json"))):
        check_lottie(p)
        rows.append((p, os.path.getsize(p)))
    for p, s in rows:
        print(f"{s or 0:>6} B  {os.path.relpath(p, ROOT)}")
    if errors:
        print("\nGAGAL:")
        for e in errors:
            print("  - " + e)
        sys.exit(1)
    print(f"\nOK: {len(rows)} file lolos.")


if __name__ == "__main__":
    main()
