English | [简体中文](./README.md)

# DayZ Mod Development & Debugging Toolkit

This repository helps you quickly develop and debug DayZ client/server mods locally with a consistent directory layout and helper scripts.

## Project Structure
```text
DayZDevelopmentTool/
├── .vscode/                      # VS Code debug configuration
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── bin/                          # Third‑party binaries (PBO tooling)
│   ├── PBOConsole.exe
│   └── PBOLib.DLL
├── build/                        # Development build output
│   ├── @ClientMod/
│   │   └── Addons/               # Client mod PBO output
│   └── @ServerMod/
│       └── Addons/               # Server mod PBO output
├── data/                         # Mods and mission resources
│   ├── Battleye/                 # Battleye configs (auto‑mapped on start)
│   ├── Mod/
│   │   ├── client/
│   │   └── server/
│   ├── Profiles/                 # Profiles
│   │   ├── client/
│   │   └── server/
│   └── Mpmissions/               # Missions (auto‑mapped on start)
│       ├── dayzOffline.chernarusplus/
│       ├── dayzOffline.enoch/
│       └── dayzOffline.sakhal/
├── src/                          # Mod source code
│   ├── CLIENT_MOD/               # Client mod source
│   └── SERVER_MOD/               # Server mod source
├── config.json                   # Tool configuration
├── killAll.ps1                   # Kill all DayZ processes
└── run.ps1                       # Launch DayZServer and DayZ client
```

## Prerequisites
- Install complete versions of `DayZ` and `DayZServer`, and ensure `DayZServer` contains the `mpmissions` directory.
- If you installed `DayZServer` via SteamCMD, `mpmissions` is not included by default. Download missions from the official repo and place them under `DayZServer/mpmissions`:
  - Repo: [BohemiaInteractive/DayZ-Central-Economy](https://github.com/BohemiaInteractive/DayZ-Central-Economy)
  - Download the three official offline missions and place them in `DayZServer/mpmissions` (important).

## Configuration
- Clone this repository and set your paths without Chinese characters, spaces, or hyphens (`-`).
- Edit `config.json` and set your local `DayZ` and `DayZServer` installation paths; also avoid Chinese characters, spaces, or hyphens (`-`).

## Adding Mods
- Client‑side mods: copy third‑party mods (e.g., `@CF`) to `./data/Mod/client/`.
- Server‑side mods: copy server mods to `./data/Mod/server/`.

## Build & Run
- In VS Code, press `F5` to run `run.ps1`. The script builds all mods into `./build/`.
- This project is for testing only. Built `pbo` files are unsigned; avoid using them in production.
- For production releases, use official DayZ Tools to build and sign PBOs before distribution.

## Notes
- Do not enable mod verification in test environments; the default `serverDZ.cfg` disables mod verification.
- To switch missions, use VS Code's debug tasks; no need to edit `serverDZ.cfg`.
- To add additional missions for debugging:
  - Edit `./.vscode/launch.json` following the existing entries.
  - Place mission files under `./data/Mpmissions/`.
- Server configuration samples (e.g., `serverDZ*.cfg`) can be kept under `./data/ServerDZ_Cfg/` if needed.

## Enable PowerShell Script Execution on Windows
- Open PowerShell as Administrator (or PowerShell 7 `pwsh`).
- Check current policy: `Get-ExecutionPolicy -List`
- Recommended for the current user (allow local scripts):
  - `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Temporarily allow in the current session (one-off):
  - `Set-ExecutionPolicy Bypass -Scope Process -Force`
- If the script was downloaded from the internet, unblock the file:
  - `Unblock-File -Path .\run.ps1`
- Run a script once without changing the global policy:
  - `powershell -ExecutionPolicy Bypass -File .\run.ps1`
  - or `pwsh -NoProfile -ExecutionPolicy Bypass -File .\run.ps1`
- The error "running scripts is disabled on this system" usually indicates a strict execution policy; adjust using the steps above.