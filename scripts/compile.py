import argparse
import pathlib
import subprocess as sp

if __name__ == "__main__":
    curr_dir = pathlib.Path(".")
    print(curr_dir)
    sp.call("ls")
