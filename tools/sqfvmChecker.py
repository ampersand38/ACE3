import os
import sys
import subprocess
import concurrent.futures

v_paths = [
    "D:\\Arma\\pDrive\\a3|\\a3",
    "D:\\Arma\\pDrive\\a3|\\A3",
    "F:\\DEV\\CBA_A3|\\x\\cba",
    "F:\\DEV\\ACE3|\\z\\ace",
    "F:\\DEV\\ACEX|\\z\\acex",
    "F:\\DEV\\acre2|\\idi\\acre",
]

basePath = os.path.join(os.path.dirname(os.getcwd()), "addons")


def processFile(filePath, skipA3Warnings=True):
    with open(filePath, "r", encoding="utf-8", errors="ignore") as file:
        content = file.read()
        if content.startswith("//pragma SKIP_COMPILE"):
            return False
    cmd = ["sqfvm.exe", "--input", filePath]
    for v in v_paths:
        cmd.append("-v")
        cmd.append(v)
    cmd.append("--parse-only")
    cmd.append("--automated")
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, universal_newlines=True)
    try:
        ret = proc.wait(6)
    except Exception as _e:
        print("sqfvm timed out: {}".format(filePath))
        return True

    keepReadingLines = True
    while keepReadingLines:
        line = proc.stdout.readline()
        if not line:
            keepReadingLines = False
        else:
            line = line.rstrip()
            if not (
                skipA3Warnings
                and line.startswith("[WRN]")
                and ("a3/" in line)
                and (("Unexpected IFDEF" in line) or ("defined twice" in line))
            ):
                print("  {}".format(line))
    return ret != 0


def main():
    error_count = 0
    arma_files = []
    for root, _dirs, files in os.walk(basePath):
        for file in files:
            if file.endswith(".sqf") or file == "config.cpp":
                filePath = os.path.join(root, file)
                arma_files.append(filePath)
    with concurrent.futures.ThreadPoolExecutor(max_workers=12) as executor:
        for fileError in executor.map(processFile, arma_files):
            if fileError:
                error_count += 1

    print("Checked {} files - errors: {}".format(len(arma_files), error_count))
    return error_count


if __name__ == "__main__":
    sys.exit(main())
