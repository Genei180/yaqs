# yags – Yet Another Quickshell Setup

**yags** is my personal configuration for [Quickshell](https://quickshell.org/), a flexible Wayland shell replacement.
I try to focuses on simplicity, modularity, and a clean user experience — without pretending to be the “final word” in shell configs (because it isn’t).

An Additonally Goal of mine is to make it Mobile Friendly so i can use it with mobile Nix.
(Or Atleast make some Parts Reusable)

---

## Screenshots

![Screenshot](./Screenshot.png)

Screenshot of the current MainBar

---

## ✨ Features

* I Dont know yet, we will see what i can come up with
* End Goal is to make it Packageable with Nix and Home Manager
* Additionally it should allow to Reuse Parts or all for it for Mobile Nix.

---

## 📦 Requirements

Placeholder Text:
* [Quickshell](https://quickshell.dev/docs/) (latest build recommended)
* A Wayland compositor with layer-shell support (tested on Hyprland)
* `notify-send` for system notifications

* This Section needs to be re-done...

---

## 🚀 Setup

Clone into your Quickshell config directory:

```sh
git clone https://github.com/Genei180/yaqs.git ~/.config/quickshell
```

Run Quickshell:

```sh
cd ~/.config/quickshell
quickshell -p .
```

Or add it to your compositor autostart.

---

## 🛠️ Structure

```
modules/
  bar/         # Main Horizontal Bar
  sidebar/     # hover-based sidebar
  widgets/     # reusable QML widgets
shell.qml      # entrypoint
```

---

## 📌 Notes

* This is **not** Finished yet. It’s a starting point.
* Expect rough edges. If something doesn’t work, it might be “a feature.”
* Contributions welcome, but keep it simple.

---

## Inspired by

And maybe a little Copy Pasted to get Started learning qml from:
* [ryzendew](https://github.com/ryzendew/Reborn-Quickshell)
* [soramane](https://github.com/caelestia-dots/shell/tree/main)
* [end-4](https://github.com/end-4/dots-hyprland)

