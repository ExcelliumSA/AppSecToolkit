"""
Script to fix the following issue when a PSH/BASH shell is spawned via CMDER:

https://github.com/ExcelliumSA/AppSecToolkit/issues/1#issuecomment-900091304
"""
import sys
import platform

DEFAULT_ENCODING = "ansi"
# List of python binary files to patch
binary_files = ["pip.exe", "http.exe", "https.exe"]
# Get binary file root folder
binary_home = sys.executable.replace("\\", "/").replace("python.exe", "Scripts")
# Bad python path searched
python_version = platform.python_version()
bad_python_path = f"C:\\hostedtoolcache\\windows\\Python\\{python_version}\\x64\\python.exe"
# Python runtime location
correct_python_path = sys.executable
if len(correct_python_path) < len(bad_python_path):
    correct_python_path = correct_python_path.ljust(len(bad_python_path), "\x00")
else:
    print(f"Correct path is longer than bad path ({len(correct_python_path)} >= {len(bad_python_path)}).\nAborting to avoid corrupting binaries.")
    sys.exit(1)
# Process files
for f in binary_files:
    file_to_patch = f"{binary_home}/{f}"
    with open(file_to_patch, mode="rb") as file:
        content = file.read()    
    content = content.replace(bad_python_path.encode(DEFAULT_ENCODING), correct_python_path.encode(DEFAULT_ENCODING))
    with open(file_to_patch, mode="wb") as file:
        file.write(content)
