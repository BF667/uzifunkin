<div align='center'>

# 🎤 FNF: Uzi Funkin Engine

**An optimized Friday Night Funkin' engine built for low-end devices, featuring a built-in launcher with Gameplay & Modding modes.**

Based on [Friday Night Funkin'](https://github.com/FunkinCrew/Funkin) by FunkinCrew, rebuilt and enhanced for performance and modding accessibility.

</div>

---

<div align='center'>
<table>
  <tr>
    <td><img src="docs/readme_images/Title_Card.gif" alt="Title Screen" width="350"/></td>
    <td><img src="docs/readme_images/Menu.png" alt="Main Menu" width="350"/></td>
  </tr>
</table>
</div>

## ✨ What is Uzi Funkin Engine?

FNF: Uzi Funkin Engine is a custom-built FNF engine designed to run smoothly on low-end hardware while preserving the full Friday Night Funkin' experience. It includes a dedicated launcher that lets you choose between **Gameplay Mode** (for playing songs and weeks) and **Modding Mode** (for charting, importing mods, and creative tools).

Whether you're playing on a potato PC or creating the next hit mod, this engine has you covered.

## 🚀 Key Features

### 🎮 Launcher with Dual Modes
- **Gameplay Mode** — Jump straight into playing songs, weeks, and story mode. A clean, no-distraction experience optimized for performance.
- **Modding Mode** — Access charting tools, mod management, and editing features. Import, enable/disable, and organize your mods all from the launcher.

### ⚡ Low-End Optimizations
- Aggressive garbage collection and memory management
- Reduced particle effects and trail rendering for better frame rates
- Optional low-quality mode that disables expensive shaders and post-processing
- Optimized note rendering and strumline drawing
- Reduced animation overhead on stage boppers and characters
- Configurable quality preferences (low quality, reduced animations, etc.)

### 🛠️ Modding Support
- Built-in mod import system from the launcher
- Browse, enable, and disable mods without restarting
- Charting editor accessible directly from Modding Mode
- Full compatibility with standard FNF mod formats

### 🖥️ Windows Build Support
- One-click build scripts for Windows `.exe` output
- Build scripts located in `scripts/` directory

## 📥 Getting Started

### Prerequisites

To compile the engine from source, you'll need:

- [Haxe](https://haxe.org/) (4.3.x or later)
- [HaxeFlixel](https://haxe-flixel.com/) and its dependencies
- [Lime](https://github.com/openfl/lime) (7.9.0+)
- A C++ compiler (for native builds)

### Quick Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/BF667/uzifunkin.git
   cd uzifunkin
   ```

2. Install Haxe dependencies:
   ```bash
   haxelib install hmm
   haxelib run hmm install
   ```

3. Build for Windows:
   ```bash
   # Using the included build script
   scripts\build-windows.bat

   # Or manually
   lime build windows
   ```

4. Run the game — the launcher will appear first, letting you choose your mode.

For detailed compilation instructions, see the [Compiling Guide](/docs/COMPILING.md).

## 🎯 Launcher Modes

When you launch the engine, you'll see the **Uzi Funkin Launcher** with two options:

| Mode | Description |
|------|-------------|
| **🎮 Gameplay Mode** | Play songs, freeplay, story mode. Optimized for performance. No editor tools loaded. |
| **🛠️ Modding Mode** | Full access to charting editor, mod import/export, preferences, and development tools. |

The launcher also provides:
- **Mod Manager** — Import mods from folders, browse installed mods, toggle them on/off
- **Engine Settings** — Configure quality, audio, and performance options before launching
- **Quick Launch** — Remember your last mode and skip the launcher next time

## ⚙️ Performance Settings

The engine includes several options to tune performance for your hardware:

| Setting | Description | Default |
|---------|-------------|---------|
| Low Quality Mode | Disables shaders, reduces visual fidelity | Off |
| Reduced Animations | Limits background character animations | Off |
| Aggressive GC | More frequent garbage collection passes | On |
| Disable Trail Effects | Removes note/character trail effects | Off |
| Optimized Rendering | Batch rendering for notes and strumline | On |

These can be changed in the launcher or in-game preferences menu.

## 📁 Project Structure

```
uzifunkin/
├── source/
│   └── funkin/
│       ├── ui/launcher/      # Launcher & mode selection
│       ├── play/             # Gameplay states (PlayState, notes, etc.)
│       ├── ui/               # Menus, options, title screen
│       ├── save/             # Save data & preferences
│       ├── util/             # Utilities, constants, plugins
│       └── effects/          # Visual effects (trails, etc.)
├── scripts/                  # Build scripts (Windows .exe, etc.)
├── docs/                     # Documentation
├── assets/                   # Game assets
└── project.hxp              # Haxe project configuration
```

## 🔧 Building

### Windows (.exe)
```bash
scripts\build-windows.bat
```

The output will be in `export/windows/bin/` as a standalone `.exe` with all required DLLs.

### Other Platforms
```bash
lime build mac      # macOS
lime build linux    # Linux
lime build html5    # Web browser
```

Refer to the [Compiling Guide](/docs/COMPILING.md) for detailed platform-specific instructions.

## 🤝 Credits

### Uzi Funkin Engine
- **[BF667](https://github.com/BF667)** — Engine optimization, launcher system, modding tools, low-end improvements

### Original Friday Night Funkin' (FunkinCrew)
- [ninjamuffin99](https://twitter.com/ninja_muffin99) — Lead Programmer
- [EliteMasterEric](https://twitter.com/EliteMasterEric) — Programmer
- [MtH](https://twitter.com/emmnyaa) — Charting and Additional Programming
- [GeoKureli](https://twitter.com/Geokureli/) — Additional Programming
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) — Artist and Animator
- [Evilsk8r](https://twitter.com/evilsk8r) — Art
- [Kawaisprite](https://twitter.com/kawaisprite) — Musician

Full credits available in-game and in `credits.json`.

### Special Thanks
- The FunkinCrew for creating Friday Night Funkin'
- The HaxeFlixel community
- All mod creators and contributors

## 📜 License

This project is based on Friday Night Funkin' by FunkinCrew. Please refer to the original repository for license information.

---

<div align='center'>

**FNF: Uzi Funkin Engine** — Play hard. Mod easy. Run anywhere.

</div>
