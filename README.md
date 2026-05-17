[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/e0ipso/ddev-assistant-opencode/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/e0ipso/ddev-assistant-opencode/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/e0ipso/ddev-assistant-opencode)](https://github.com/e0ipso/ddev-assistant-opencode/commits)
[![release](https://img.shields.io/github/v/release/e0ipso/ddev-assistant-opencode)](https://github.com/e0ipso/ddev-assistant-opencode/releases/latest)

# DDEV Assistant Opencode

## Overview

This add-on integrates Assistant Opencode into your [DDEV](https://ddev.com/) project.

## Installation

```bash
ddev add-on get e0ipso/ddev-assistant-opencode
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev describe` | View service status and used ports for Assistant Opencode |
| `ddev logs -s assistant-opencode` | Check Assistant Opencode logs |
| `ddev exec -s assistant-opencode opencode` | Run OpenCode commands |
| `ddev ssh -s assistant-opencode` | Start an interactive shell |

## Configuration

The add-on mounts your host OpenCode configuration into the container:

| Host Path | Container Path | Purpose |
| --------- | -------------- | ------- |
| `~/.config/opencode` | `/home/node/.config/opencode` | OpenCode configuration |
| `~/.cache/opencode` | `/home/node/.cache/opencode` | OpenCode cache |
| `~/.local/share/opencode` | `/home/node/.local/share/opencode` | OpenCode data & auth |
| `~/.claude` | `/home/node/.claude` | Claude settings (if applicable) |
| `~/.gitconfig` | `/home/node/.gitconfig` | Git configuration |
| `~/.config/gh` | `/home/node/.config/gh` | GitHub CLI configuration |

These mounts are inspired by the [`.devcontainer`](.devcontainer/) setup, ensuring a consistent experience between local dev containers and DDEV projects.

## Credits

**Contributed and maintained by [@e0ipso](https://github.com/e0ipso)**
