import os
import contextlib


@contextlib.contextmanager
def working_directory(path):
    """A context manager which changes the working directory to the given
    path, and then changes it back to its previous value on exit."""
    prev_cwd = os.getcwd()
    if not os.path.exists(path):
        os.mkdir(path)
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(prev_cwd)
