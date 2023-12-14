# pylerplate

![Python](https://img.shields.io/badge/python-006d98?style=for-the-badge&logo=python&logoColor=ffc600)
![Make](https://img.shields.io/badge/make-3e474a?style=for-the-badge&logo=gnu&logoColor=ffffff)
![Docker](https://img.shields.io/badge/docker-2496ed?style=for-the-badge&logo=docker&logoColor=ffffff)
![VSCode](https://img.shields.io/badge/vscode-2c2c32?style=for-the-badge&logo=visualstudiocode&logoColor=22a8f1)

## What is pylerplate?

`pylerplate` is a *boilerplate* for quick-starting new Python projects and environments.
Development-wise, this project contains only the necessary *tools*, *settings*, and *scripts* to keep it simple and easy.
Project-specific *configurations* contain the essential attributes, with most of them blank.
Docker *containerization* is heavily used, and almost everything is built around it.
The *devcontainer*, *Dockerfile*, and *Makefile* include the base for development and production.
*VSCode* is the IDE of choice, but any other can be used.

### Why?

Whenever I wanted to start a new project from the ground up or simply wanted to have a new development environment, I found myself doing the repetitive task of analysing and configuring the tools to use, configuring the project, setting up the devcontainer, etc.
There were other boilerplates out-there, but none met my specific needs neither for the environment setup nor for the tools to use out-of-the-box.
That being said, I decided to create this boilerplate, keeping it abstract/simple enough for general use.

Reasons to use this boilerplate (or not):

- You need a boilerplate with the most recent and finest development tools;
- You just want a simple Python environment to play around or do some testing;
- You want a foundation for your new project that contains the basic/common development, testing, and production workflows;
- You like things tidy, real tidy;
- You rely on containerization;
- You like to follow CI/CD pipelines workflows;
- You like to follow good engineering practices and patters, even in metaproject-related activities such as dependency installation;
- You want to follow Python standards.

## Getting started

To use this boilerplate simply download it, remove the .git/ folder, and launch it in VSCode.
Here is the command I commonly use:

```console
git clone https://github.com/oceord/pylerplate.git && \
  rm -rf pylerplate/.git/ && \
  code pylerplate
```

### Steps

- [ ] Give the project a name
  - Rename the main source module
  - Replace the `mypackage` expression throughout the source-code
- [ ] Choose a proper LICENSE (or just replace `2023 oceord`)
- [ ] Update setup.cfg
- [ ] Choose a Python version and lock it throughout the source-code
  - Search for `MAJOR.MINOR`
  - NOTE: Debian is used as the base distribution for everything docker-related
    - To change this:
      1. Replace the expression `-bookworm` in Dockerfile
      2. Replace the base image of devcontainer.json
      3. Replace all the `apt` commands (if required)
- [ ] Decide wether to use a src-layout or flat-layout
  - More information [here](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/)
  - If a flat-layout is chosen, move the project main module to the root and update Makefile > `SRC`
- [ ] Generate Pipenv.lock with `pipenv lock`
- [ ] Pin dependencies in ./scripts/install_meta_packages.sh with their versions
- [ ] Set up the devcontainer and launch it
- [ ] Replace this README

And that's it.
Happy hacking!

## Contributing

If you have any suggestion to improve this boilerplate, you can either open an issue or submit a pull request.
Either one of those will be analyzed (once I have the time to do so) and provided with feedback.
Please do keep in mind that any modification should be in line this project's reasoning described in the [*What is pylerplate?*](#what-is-pylerplate) section above.

## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.

## Acknowledgements

- [AlexanderWillner](https://github.com/AlexanderWillner)'s approach to the `help` target in his [Makefile](https://github.com/AlexanderWillner/python-boilerplate/blob/master/Makefile#L9-L16);
- [Snyk](https://snyk.io/)'s [best practices](https://snyk.io/blog/best-practices-containerizing-python-docker/) for Python containerization.
