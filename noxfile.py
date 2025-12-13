import nox
from nox import Session


@nox.session
def lint(session: Session) -> None:
    session.install("ruff")
    session.run("ruff", "check")


@nox.session(python=["3.12", "3.13"])
def typing(session: Session) -> None:
    session.install(".")
    session.install("--group", "dev")
    session.install("pyrefly")
    session.run("pyrefly", "check")
