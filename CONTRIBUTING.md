# Contributing to Rux

Thank you for your interest in contributing to the Rux programming language!

## Ways to Contribute

- Report bugs via [GitHub Issues](https://github.com/rux-lang/Rux/issues)
- Propose language features in [GitHub Discussions](https://github.com/rux-lang/Rux/discussions)
- Submit pull requests for bug fixes or approved features
- Improve documentation

## Getting Started

1. Fork the repository at <https://github.com/rux-lang/Rux/fork>
2. Clone your fork and create a feature branch:
   ```sh
   git checkout -b my-feature
   ```
3. Make your changes, then commit:
   ```sh
   git commit -am "Short description of change"
   ```
4. Push your branch and open a Pull Request against `dev`.

> Note: All contributions should target the `dev` branch. Changes are reviewed and tested there before being merged into `main` for releases.

## Pull Request Guidelines

- Keep PRs focused — one logical change per PR.
- Reference the relevant issue (e.g., `Fixes #42`) in the PR description.
- Ensure existing tests pass before submitting.
- Add tests for any new behavior.

## Commit Messages

Use short imperative sentences: `Fix parser crash on empty block`, not `Fixed the parser`.

## Code Style

Follow the conventions already present in the codebase. Consistency matters more than personal preference.

## Build Targets

The compiler's backend is **host-driven**: `rux build` emits code for the
architecture and OS it runs on. Cross-compiling to a foreign target is not
supported yet, so a build's `--target` must match the host.

Recognized target triples: `linux-x64`, `windows-x64`, `macos-arm64`,
`macos-x64`.

On macOS the output architecture matches the host automatically:

- **Apple Silicon (arm64)** → native arm64 Mach-O (a minimal dynamic image —
  the form Apple Silicon's kernel requires — that still performs all OS
  interaction through the linker's built-in syscall thunks).
- **Intel (x86-64)** → static x86-64 Mach-O.

When touching the backend, keep the two macOS paths in sync: codegen lives in
`Source/Rcu.cpp` (`Arm64CodeGen` and the x86-64 `RcuCodeGen`) and executable
emission in `Source/Linker.cpp` (`LinkMachO64`, which branches on the object's
arch). Building and running the `Tests/Pow`, `Tests/Io`, and `Tests/Echo`
packages on each host architecture you can reach is the quickest backend
sanity check.

## Reporting Bugs

Include:

- Rux version / commit hash
- Minimal reproducer (source file or snippet)
- Expected vs. actual behavior

## Community

Join the discussion on [Discord](https://discord.com/invite/uvSHjtZSVG) or [GitHub Discussions](https://github.com/rux-lang/Rux/discussions) if you have questions before diving in.

## License

By contributing you agree that your work will be licensed under the [MIT License](LICENSE).
