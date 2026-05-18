[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/e0ipso/ddev-assistant-opencode/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/e0ipso/ddev-assistant-opencode/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/e0ipso/ddev-assistant-opencode)](https://github.com/e0ipso/ddev-assistant-opencode/commits)
[![release](https://img.shields.io/github/v/release/e0ipso/ddev-assistant-opencode)](https://github.com/e0ipso/ddev-assistant-opencode/releases/latest)

# DDEV Assistant Opencode

## Overview

This add-on integrates Assistant Opencode into your [DDEV](https://ddev.com/) project's web container.

## Installation

```bash
ddev add-on get e0ipso/ddev-assistant-opencode
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev exec opencode` | Run OpenCode commands inside the web container |


## Configuration

The add-on mounts your host OpenCode configuration into the web container:

| Host Path | Container Path | Purpose |
| --------- | -------------- | ------- |
| `~/.config/opencode` | `~/.config/opencode` | OpenCode configuration |
| `~/.cache/opencode` | `~/.cache/opencode` | OpenCode cache |
| `~/.local/share/opencode` | `~/.local/share/opencode` | OpenCode data (including auth) |

On first `ddev restart`, the add-on:
1. Installs OpenCode into the web container image at `/usr/local/bin/opencode`
2. Ensures all mounted directories are owned by the web user (not root)

## Credits

**Contributed and maintained by [@e0ipso](https://github.com/e0ipso)**
