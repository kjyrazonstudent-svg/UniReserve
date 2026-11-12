# UniReserve – UA Facility Reservation System

An offline-capable, cross-platform PC desktop application for the **University of the Assumption (UA)**, built using **Electron** and **SQLite**.

---

## Overview

UniReserve allows university students and administrative personnel to browse campus venues, check timetable availability, submit facility reservation requests, and manage administrative approvals with complete offline persistence.

### Key Capabilities

- **Login Gatekeeper & Local Authentication**: Full-screen gatekeeper enforces authentication before granting access to facilities, timetables, reservations, or administrative controls. Supports Student Registration and Admin Sign In.
- **Admin Room & Facility Creation**: Administrators can dynamically add new campus rooms/facilities (custom room code, title, category, capacity, operating hours, equipment, description, and custom photo upload) as well as remove decommissioned venues.
- **Desktop Shell & Security**: Built on Electron 31 with strict Content Security Policy (CSP), single-instance lock, remembered window sizing/position, native application menu, and a secure `contextBridge` preload architecture (`contextIsolation: true`, `nodeIntegration: false`).
- **Local SQLite Storage**: Powered by `better-sqlite3` in write-ahead logging (WAL) mode located in the local OS user data directory. Eliminates browser `localStorage` size limits and enables database backup and restore directly from the application menu.
- **Double-Layer Overlap Prevention**: Interval conflict detection enforced both on the client UI and validated in the SQLite database layer. Bookings cannot overlap on the same date and facility unless cancelled or rejected.
- **Role-Based Workflows**:
  - **Student**: Browse venue specifications, inspect hourly schedules, submit reservation requests (with automatic 1-hour time advancement), filter/search personal bookings, edit pending submissions, and print official UA Reservation Slips.
  - **Administrator**: Full request queue review with one-click **Approval** or **Rejection** (with optional administrative remarks), dynamic room/facility creation & deletion, venue metadata editing, custom venue image replacement from disk, blackout/maintenance dates manager, and CSV report exports.
  - **Default Admin Account**: Seeded with username `admin` and default password `admin123`. Initial login enforces a mandatory password update.
- **Interactive Timetable**: Visual monthly calendar view per facility highlighting approved bookings, pending requests, and institution blackout dates.
- **Native Notifications & Official Slips**: Native OS desktop notifications on booking status changes, plus clean `@media print` reservation slips formatted for physical printing or saving as PDF.
- **Turnover Distribution Package**: Includes standalone portable executable (`UniReserve 1.0.0.exe`), Windows NSIS installer (`UniReserve Setup 1.0.0.exe` + `.blockmap`), and an automated unblocker script (`Unblock-And-Run.bat`) that clears Windows Zone.Identifier (MOTW) to prevent Smart App Control / SmartScreen blocking on turnover PCs.

---

## Directory Structure

```
UniReserve/
├── package.json                    # Application metadata, scripts, electron-builder config
├── .eslintrc.json                  # Strict ESLint configuration
├── README.md                       # System documentation and instructions
├── build/
│   ├── icon.ico                    # Windows application & installer icon
│   └── icon.png                    # Multi-resolution icon asset
├── scripts/
│   └── ensure-sqlite-binary.js     # Native binary downloader for Electron
├── tests/
│   ├── validation.test.js          # Input and operating hours validation tests
│   └── overlap.test.js             # Booking time collision & interval overlap tests
└── src/
    ├── main/
    │   ├── main.js                 # Electron process entry, window lifecycle, CSP, single-instance
    │   ├── preload.js              # Secure contextBridge API bridge (uniReserveAPI)
    │   ├── db.js                   # SQLite schema, migrations, and seed data initialization
    │   ├── ipc.js                  # IPC handlers (Auth, Bookings, Facilities, Blackout, Export, Print)
    │   ├── menu.js                 # Native OS menu (File, Backup, Restore, Edit, View, Help)
    │   └── validation.js           # Shared booking validation and interval collision logic
    └── renderer/
        ├── index.html              # Single-page application shell
        ├── style.css               # UA branding (--yellow: #f4c542, dark theme #101114)
        ├── renderer.js             # Hash router, UI state controller, timetable, modals
        └── assets/
            ├── ua.jpg              # Official university photo
            └── facilities/         # AVR, Gymnasium, Covered Court, Auditorium images
```

---

## Setup & Installation

### Prerequisites
- [Node.js](https://nodejs.org/) (v18, v20, v22, or v24)
- npm (v9+)

### Installation
Clone or navigate to the project directory and install dependencies:
```bash
cd UniReserve
npm install
```

---

## Running the Application

### Development Mode
To launch the desktop application with Developer Tools enabled:
```bash
npm run dev
```

### Normal Desktop Launch
```bash
npm start
```

---

## Running Tests & Quality Checks

### Run Unit Tests
Executes Jest test suites covering time-overlap detection, edge collision bounds, operating hours checks, and input validation:
```bash
npm test
```

### Run ESLint
Runs static code analysis across `src/` and `tests/`:
```bash
npm run lint
```

---

## Packaging & Distributables

UniReserve uses `electron-builder` to bundle installable binaries for Windows (and cross-platform targets).

### Windows Installer (NSIS) & Portable Executable
To produce both the Windows NSIS Setup executable (`UniReserve Setup 1.0.0.exe` + `.blockmap`) and the standalone Portable `.exe` (`UniReserve 1.0.0.exe`):
```bash
npm run dist
```
The output installers will be located in the `dist/` directory.

### Turnover Package (Bypasses Smart App Control & SmartScreen)
To automatically organize the standalone files, NSIS installer, and one-click unblock launcher into a turnover-ready package:
```bash
npm run dist:turnover
```
This prepares `dist/UniReserve-Turnover-Package/` and `dist/UniReserve-Turnover-Package.zip` containing:
- `UniReserve 1.0.0.exe` (Standalone portable application)
- `UniReserve Setup 1.0.0.exe` (Windows NSIS installer)
- `UniReserve Setup 1.0.0.exe.blockmap`
- `Unblock-And-Run.bat` (Automatically clears Mark-of-the-Web to prevent Smart App Control blocks on turnover PCs)
- `TURNOVER_README.txt` (Clear user and turnover guide)

### Portable Build Only
```bash
npm run dist:portable
```

---

## Local Data & Storage Location

All SQLite data, user accounts, and uploaded facility photos are stored in the user data folder:

- **Windows**: `%APPDATA%\unireserve\unireserve.db`
  *(e.g., `C:\Users\<Username>\AppData\Roaming\unireserve\unireserve.db`)*
- **Linux**: `~/.config/unireserve/unireserve.db`
- **macOS**: `~/Library/Application Support/unireserve/unireserve.db`

### Backup & Restore
- **Backup**: Select **File → Back Up Database...** (or press `Ctrl+B`) to export a timestamped `.sqlite` backup anywhere on your machine.
- **Restore**: Select **File → Restore Database...** (or press `Ctrl+Shift+R`) to restore from a previously saved SQLite backup file.
- **Inspect Data Folder**: Select **Help → Open Data Folder...** to quickly open the data folder in Windows File Explorer.
