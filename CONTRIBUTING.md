# Contributing to docker-ansible

Thank you for your interest in contributing!

## How to Contribute

1. **Fork** this repository.
2. **Create a branch**: `git checkout -b fix/description` or `feat/description`
3. **Make your changes** — see guidelines below.
4. **Open a Pull Request** using the PR template.

## Dockerfile Guidelines

- Base images must be pinned to a specific version (not `latest`).
- Minimize layers — combine related `RUN` commands.
- Clean up package manager caches in the same `RUN` step.
- Use `ARG` for version pins so they can be overridden at build time.
- Do not embed secrets, tokens, or credentials.

## Testing Locally

```bash
docker build -t test-image .
docker run --rm test-image
```

## Reporting Issues

Use the issue templates:
- **Bug report** — something is broken or behaves unexpectedly.
- **Feature request** — suggest an improvement.

## Code of Conduct

By contributing, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).
