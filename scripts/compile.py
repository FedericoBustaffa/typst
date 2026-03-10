import os
import pathlib
import subprocess as sp

if __name__ == "__main__":
    subjects = os.listdir("notes")

    for s in subjects:
        s = "notes/" + s
        files = os.listdir(s)

        files = [f for f in files if f"{s}/{f}".endswith(".typ")]
        for f in files:
            exit_code = sp.call(["typst", "compile", f"{s}/{f}"])
