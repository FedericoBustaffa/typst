import argparse
import os
import pathlib
import subprocess as sp

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "path", default="notes", type=str, help="directory or file path to compile"
    )
    args = parser.parse_args()
    path = args.path

    subjects = os.listdir(path)

    for s in subjects:
        s = "notes/" + s
        print(os.listdir(s))
