# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix library called "wrappers" that creates wrapped executables via the module system. It provides a unified approach to package wrapping across different Nix platforms (NixOS, home-manager, nix-darwin, devenv).

## Core Architecture

### Main Components

- **`lib.nix`**: Core library functions implementing `wrapPackage` and `wrapModule`
- **`modules.nix`**: Dynamically imports all wrapper modules from the `modules/` directory
- **`modules/`**: Directory containing pre-built wrapper modules for specific packages (mpv, notmuch, rofi, nushell, helix, etc.)
- **`checks/`**: Test files for validating functionality

### Key Functions

1. **`wrapPackage`** (low-level): Wraps packages with flags, environment variables, and runtime dependencies
2. **`wrapModule`** (high-level): Creates reusable wrapper modules with type-safe configuration options using the NixOS module system

## Development Commands

### Build and Test
```bash
# Run all checks (includes formatting, functionality tests, and module tests)
nix flake check

# Format code
nix fmt

# Test specific module (replace 'mpv' with module name)
nix build .#checks.x86_64-linux.module-mpv
```

### Adding New Modules

When creating new wrapper modules:

1. Create directory: `modules/[package-name]/`
2. Add `module.nix` with the wrapper module definition
3. Add `check.nix` with tests for the module
4. Follow existing patterns in `modules/mpv/` or `modules/notmuch/`

### Module Structure

Each wrapper module should:
- Use `wlib.wrapModule` to define the module
- Provide custom options for package-specific configuration
- Set appropriate `meta.platforms` and `meta.maintainers`
- Include a corresponding `check.nix` for testing

## Important Patterns

### Flag Handling
- `flags` attribute set: `{ "--flag" = "value"; "--bool-flag" = {}; "--disabled" = false; }`
- `flagSeparator`: `" "` for `--flag value` or `"="` for `--flag=value`
- Auto-generates `args` list from `flags` unless explicitly provided

### File Management
- `filesToPatch`: Glob patterns for files needing path updates (default: desktop files)
- `filesToExclude`: Glob patterns for files to exclude from wrapped package
- Multi-output derivation support (preserves man pages, completions, etc.)

### Module System Integration
- Uses NixOS module evaluation with `lib.evalModules`
- Supports standard module features (imports, conditionals, mkIf, etc.)
- Provides `config` and `options` introspection
- Includes `apply` function for extending configurations

## Testing Philosophy

- Each module must have corresponding tests in `check.nix`
- Tests verify both successful builds and correct configuration application
- Platform-specific tests only run on supported platforms
- Checks include both functional tests and meta-information validation