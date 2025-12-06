import nox
from nox import Session


@nox.session
def lint(session: Session) -> None:
    session.install("ruff")
    session.run("ruff", "check")


@nox.session
def typing(session: Session) -> None:
    session.install("pyrefly")
    session.run("pyrefly", "check")
