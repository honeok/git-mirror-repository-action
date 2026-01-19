# git-mirror-action

> [!TIP]
> The GitHub Action for mirroring repositories for the 80% use case.

[![Build Status](https://img.shields.io/github/actions/workflow/status/honeok/git-mirror-action/build.yaml?branch=master&logo=github)](https://github.com/honeok/git-mirror-action)
[![GitHub Release](https://img.shields.io/github/release/honeok/git-mirror-action.svg?logo=github)](https://github.com/honeok/git-mirror-action/releases/latest)
[![GitHub License](https://img.shields.io/github/license/honeok/git-mirror-action.svg?logo=github)](https://github.com/honeok/git-mirror-action)

A GitHub Action to mirror your repository commits, branches, and tags to another remote repository such as GitLab, Bitbucket, Gitea, or even another GitHub repository.

This project is a modernized and extended fork of [yesolutions/mirror-action][1].

## Features

- Mirror all branches, tags, and refs to a secondary remote
- Supports SSH (recommended) and HTTPS (PAT / password) authentication
- Optional dry-run mode for safe testing
- Customizable `git push` behavior
- Works with monorepos and large repositories
- Minimal assumptions: does not modify history locally

## Usage

### Mirror via SSH (Recommended)

This is the most secure and reliable approach.

```yaml
name: Mirror to GitLab

on:
  push:
    branches: [master, main]
  workflow_dispatch:

jobs:
  mirror:
    runs-on: ubuntu-latest
    steps:
      - name: "Checkout repository"
        uses: actions/checkout@v6
        with:
          fetch-depth: 0

      - name: "Mirror to gitlab"
        uses: honeok/git-mirror-action@v1
        with:
          REMOTE: "ssh://git@gitlab.com/${{ github.repository }}.git"
          GIT_SSH_PRIVATE_KEY: ${{ secrets.GIT_SSH_PRIVATE_KEY }}
          GIT_SSH_KNOWN_HOSTS: ${{ secrets.GIT_SSH_KNOWN_HOSTS }}
```

### Mirror via HTTPS (Username / Token)

Useful when SSH keys are not an option. Typically paired with a Personal Access Token.

```yaml
jobs:
  mirror:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6
        with:
          fetch-depth: 0

      - name: Mirror to GitLab
        uses: honeok/git-mirror-action@v1
        with:
          REMOTE: "https://gitlab.com/${{ github.repository }}.git"
          GIT_USERNAME: ${{ github.repository_owner }}
          GIT_PASSWORD: ${{ secrets.GIT_PASSWORD }}
```

## Inputs

|          Input           |                            Description                             | Required |         Default          |
| :----------------------: | :----------------------------------------------------------------: | :------: | :----------------------: |
|         `REMOTE`         |               Target repository URL (HTTPS or SSH).                |   Yes    |           N/A            |
|      `REMOTE_NAME`       |               Local name for the remote repository.                |    No    |         `mirror`         |
|  `GIT_SSH_PRIVATE_KEY`   |            Private SSH key used for SSH authentication.            |    No    |           N/A            |
|  `GIT_SSH_KNOWN_HOSTS`   |     Contents of `known_hosts` file for SSH host verification.      |    No    |           N/A            |
|   `GIT_SSH_PUBLIC_KEY`   |                 Public SSH key (rarely required).                  |    No    |           N/A            |
| `GIT_SSH_NO_VERIFY_HOST` |             Skip SSH host verification (**insecure**).             |    No    |         `false`          |
|      `GIT_USERNAME`      |                 Username for HTTPS authentication.                 |    No    |          `git`           |
|      `GIT_PASSWORD`      |    Password or Personal Access Token for HTTPS authentication.     |    No    |           N/A            |
|     `PUSH_ALL_REFS`      | Push all branches and refs (`refs/remotes/origin/*:refs/heads/*`). |    No    |          `true`          |
|     `GIT_PUSH_ARGS`      |               Custom arguments passed to `git push`.               |    No    | `--tags --force --prune` |
|        `DRY_RUN`         |          Perform a trial run without pushing any changes.          |    No    |         `false`          |
|         `DEBUG`          |                   Enable verbose debug logging.                    |    No    |         `false`          |

## Advanced Usage

Validate configuration without pushing anything:

```yaml
with:
  REMOTE: "..."
  DRY_RUN: "true"
```

Mirror Current Branch Only

By default, all refs are mirrored. To mirror only the checked-out branch:

```yaml
with:
  REMOTE: "..."
  PUSH_ALL_REFS: "false"
```

Skip SSH Host Verification (Not Recommended)

```yaml
with:
  REMOTE: "git@gitlab.com:${{ github.repository }}.git"
  GIT_SSH_PRIVATE_KEY: ${{ secrets.GIT_SSH_PRIVATE_KEY }}
  GIT_SSH_NO_VERIFY_HOST: "true"
```

> Warning: This weakens security and exposes you to man-in-the-middle attacks.

## Credits

- Original project: [yesolutions/mirror-action][1]

[1]: https://github.com/yesolutions/mirror-action
