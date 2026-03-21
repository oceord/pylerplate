# pylerplate

![Python](https://img.shields.io/badge/python-006d98?style=for-the-badge&logo=python&logoColor=ffc600)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=for-the-badge&logo=astral&logoColor=white)
![Ruff](https://img.shields.io/badge/ruff-D7FF64?style=for-the-badge&logo=ruff&logoColor=000000)
![Pyrefly](https://img.shields.io/badge/pyrefly-FF6B35?style=for-the-badge&logo=meta&logoColor=white)
![Nox](https://img.shields.io/badge/nox-4051B5?style=for-the-badge)
![pre-commit](https://img.shields.io/badge/pre--commit-FAB040?style=for-the-badge&logo=precommit&logoColor=black)
![Make](https://img.shields.io/badge/make-3e474a?style=for-the-badge&logo=gnu&logoColor=ffffff)
![VSCode](https://img.shields.io/badge/vscode-2c2c32?style=for-the-badge&logo=visualstudiocode&logoColor=22a8f1)

> A modern, minimal Python project boilerplate with batteries included

**pylerplate** eliminates the repetitive setup work when starting new Python projects.
It comes pre-configured with modern development tools, sensible defaults, and a clean structure—giving you a solid foundation to build upon immediately.

## Features

- **Modern Python tooling** - uv, Ruff, Pyrefly, Nox, and pre-commit configured out-of-the-box
- **Git Hooks** - Automated pre-commit checks to ensure code quality before every commit
- **Dependency management** - Fast, reliable dependency resolution with uv
- **Code quality** - Automatic formatting and comprehensive linting
- **Type checking** - Static analysis with Pyrefly
- **Testing framework** - Nox sessions for isolated test environments
- **Standards compliant** - Follows PEP standards and Python best practices
- **Makefile automation** - Common tasks accessible via simple make commands
- **VSCode optimized** - IDE settings included (works with any editor)
- **Minimal configuration** - Essential settings only, ready for customization

## Quick Start

### Prerequisites

- Python 3.12 or higher
- [uv](https://github.com/astral-sh/uv) (recommended) or pip
- make (optional, but recommended)

### Customization Checklist

Complete these steps to make the boilerplate your own:

#### 1. Rename your package

```bash
# Rename the package directory
mv src/mypackage src/yourpackage

# Find and replace throughout the codebase
# Search for: mypackage
# Replace with: yourpackage
```

#### 2. Update project metadata in pyproject.toml

```toml
[project]
name = "yourpackage"
version = "0.1.0"
description = "Your project description"
authors = [{ name = "Your Name", email = "your.email@example.com" }]
keywords = ["keyword1", "keyword2"]
```

#### 3. Choose a license

Update the `LICENSE` file and copyright information:

- Replace `Copyright (c) 2023 oceord` with your copyright notice
- Choose an appropriate license for your project

#### 4. Add dependencies

```bash
# Add runtime dependencies
uv add requests httpx

# Add development dependencies
uv add --dev pytest pytest-cov

# Or edit pyproject.toml directly
```

#### 5. Clean up and customize

- Search for `TODO` comments and address them
- Review and update `README.md` (replace this file)
- Adjust Ruff and Pyrefly settings as needed

### Setup

Clone the repository and set up your new project:

```bash
# Clone and prepare your project
git clone https://github.com/oceord/pylerplate.git myproject
cd myproject
rm -rf .git/

# Perform the Customization Checklist

# Initialize a new git repository
git init

# Set up the virtual environment and install git hooks
make dev

# Commit the initial state
git add .
git commit -m "Initial commit from pylerplate"
```

## Development

### Available Make Commands

```bash
make help              # Show all available commands
make format            # Format source code
make check             # Lint and static analysis
make test              # Run tests (via Nox)
make build             # Build distribution artifacts
```

### Manual Commands

If you prefer not to use Make:

```bash
# Format code
ruff format

# Lint code
ruff check
pyrefly check

# Run tests
nox

# Build distribution
uv build
```

### Project Structure

```text
pylerplate/
├── src/
│   └── mypackage/          # Main package directory
│       └── __init__.py
├── tests/                  # Test directory
│   └── __init__.py
├── Makefile               # Task automation
├── noxfile.py            # Nox test sessions
├── pyproject.toml        # Project configuration
├── LICENSE               # Project license
└── README.md            # This file
```

## Testing

This boilerplate uses Nox for testing, which creates isolated virtual environments for each test session:

```bash
# Run all test sessions
make test

# Or run specific sessions
nox -s lint      # Run linting only
nox -s typing    # Run type checking only
```

## Tools Included

| Tool           | Purpose                                                                | Documentation                              |
| -------------- | ---------------------------------------------------------------------- | ------------------------------------------ |
| **uv**         | Fast Python package installer and resolver                             | [docs](https://docs.astral.sh/uv/)         |
| **Ruff**       | Extremely fast Python linter and formatter                             | [docs](https://docs.astral.sh/ruff/)       |
| **Pyrefly**    | Modern type checker for Python                                         | [docs](https://pyrefly.org/en/docs/)       |
| **Nox**        | Flexible test automation                                               | [docs](https://nox.thea.codes/)            |
| **pre-commit** | Framework for managing and maintaining multi-language pre-commit hooks | [docs](https://pre-commit.com/)            |
| **Make**       | Task automation and workflow management                                | [docs](https://www.gnu.org/software/make/) |

## Usage Scenarios

**Use pylerplate if you:**

- Want modern development tools configured immediately
- Need a quick Python environment for experimentation
- Value clean, organized project structure
- Follow engineering best practices and standards
- Prefer minimal but sensible defaults

**Look elsewhere if you:**

- Prefer older, more established tooling (setuptools, black, etc.)

## Contributing

Contributions are welcome! Whether you've found a bug, have a feature suggestion, or want to improve the boilerplate:

1. **Open an issue** to discuss your idea
2. **Fork the repository** and create a feature branch
3. **Submit a pull request** with your improvements

Please ensure your contributions align with pylerplate's philosophy: **modern, minimal, and practical**.

## License

Distributed under the MIT License.
See [`LICENSE`](./LICENSE) for more information.

## Acknowledgements

- [AlexanderWillner](https://github.com/AlexanderWillner) for the elegant Makefile [example](https://github.com/AlexanderWillner/python-boilerplate/blob/master/Makefile)
- The teams behind [uv](https://docs.astral.sh/uv/), [Ruff](https://docs.astral.sh/ruff/), [Pyrefly](https://pyrefly.org/), [Nox](https://nox.thea.codes/en/stable/index.html), and [pre-commit](https://pre-commit.com/) for their excellent tools

## Support

If you encounter issues or have questions:

- [Report a bug](https://github.com/oceord/pylerplate/issues/new?labels=bug)
- [Request a feature](https://github.com/oceord/pylerplate/issues/new?labels=enhancement)
- [Start a discussion](https://github.com/oceord/pylerplate/discussions)

-----

**Happy coding!**
