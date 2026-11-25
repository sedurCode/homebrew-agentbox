# sedurcode/agentbox

The Homebrew tap for [agentbox](https://github.com/sedurCode/agentbox): profiles, scoped credentials and host
tools for AI agents in Docker Sandboxes.

```bash
brew install --cask docker/tap/sbx && sbx login     # if you don't have Docker Sandboxes yet
brew install sedurcode/agentbox/agentbox             # the full name also trusts the formula
agentbox setup                                      # once, and after each upgrade
agentbox doctor
```

Upgrade with `brew upgrade agentbox`, then run `agentbox setup` again.

Problems with agentbox itself: https://github.com/sedurCode/agentbox/issues. This repo only holds the formula.

## Releasing

After tagging `vX.Y.Z` in agentbox, update `url` and `sha256` in `Formula/agentbox.rb`
(`curl -sL <url> | shasum -a 256`) in a PR; CI installs, tests and audits it.
