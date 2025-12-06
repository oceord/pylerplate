# pylerplate

![Python](https://img.shields.io/badge/python-006d98?style=for-the-badge&logo=python&logoColor=ffc600)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=for-the-badge&logo=astral&logoColor=white)
![Ruff](https://img.shields.io/badge/ruff-D7FF64?style=for-the-badge&logo=ruff&logoColor=000000)
![Pyrefly](https://img.shields.io/badge/pyrefly-FF6B35?style=for-the-badge&logo=meta&logoColor=white)
![Make](https://img.shields.io/badge/make-3e474a?style=for-the-badge&logo=gnu&logoColor=ffffff)
![VSCode](https://img.shields.io/badge/vscode-2c2c32?style=for-the-badge&logo=visualstudiocode&logoColor=22a8f1)

## What is pylerplate?

**pylerplate** is a modern Python project boilerplate designed to eliminate the repetitive setup work when starting new projects.
It comes pre-configured with essential development tools, sensible defaults, and minimal boilerplate—giving you a clean foundation to build upon.

### Key Features

- **Modern tooling**: Pre-configured with the latest Python development tools
- **Minimal configuration**: Essential settings only, most left intentionally blank for customization
- **VSCode optimized**: IDE settings included (though any editor works)
- **CI/CD ready**: Basic workflows for development, testing, and production
- **Standards-compliant**: Follows Python community best practices

### Why pylerplate?

Starting a new Python project often means repeating the same setup tasks: configuring linters, formatters, test runners, dependency management, and more.
Existing boilerplates were either too opinionated or missing key modern tools.

**pylerplate** strikes a balance—it's opinionated enough to get you started quickly, but flexible enough to adapt to your needs.

#### Use this boilerplate if you

- ✅ Want modern development tools configured out-of-the-box
- ✅ Need a quick Python environment for experimentation or testing
- ✅ Value clean, organized project structure
- ✅ Follow CI/CD workflows and engineering best practices
- ✅ Prefer standards-based Python development

## Getting Started

Clone the repository, remove the git history, and open in VSCode:

```bash
git clone https://github.com/oceord/pylerplate.git mypackage && \
  rm -rf mypackage/.git/ && \
  code mypackage
```

### Setup Checklist

After cloning, customize the boilerplate for your project:

- [ ] **Name your project**
  - Rename the `mypackage` directory to your package name
  - Find and replace `mypackage` throughout the codebase
- [ ] **Update `LICENSE`**
  - Choose an appropriate license
  - Update copyright holder (currently `2023 oceord`)
- [ ] **Configure `pyproject.toml`**
  - Add project metadata (name, description, author, etc.)
  - Specify dependencies
- [ ] **Review TODOs**
  - Search for `TODO` comments and address them
- [ ] **Replace this README**
  - Document your actual project

**That's it!**
Happy hacking! 🚀

## Contributing

Contributions are welcome! Whether you've found a bug, have a feature suggestion, or want to improve the boilerplate:

- **Open an issue** to discuss your idea
- **Submit a pull request** with your improvements

All contributions will be reviewed with feedback.
Please ensure suggestions align with pylerplate's philosophy of being a simple, modern, and minimally-opinionated boilerplate (see [What is pylerplate?](#what-is-pylerplate)).

## License

Distributed under the MIT License.
See [`LICENSE`](./LICENSE) for more information.

## Acknowledgements

- [AlexanderWillner](https://github.com/AlexanderWillner)'s elegant `help` target implementation in his [Makefile](https://github.com/AlexanderWillner/python-boilerplate/blob/master/Makefile#L9-L16)
