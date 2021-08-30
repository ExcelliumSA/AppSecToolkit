"""
Script to fix the following issue when a PSH/BASH shell is spawned via CMDER:

https://github.com/ExcelliumSA/AppSecToolkit/issues/1#issuecomment-900091304
"""
import sys

# List of python binary files to patch
binary_files = ["pip.exe", "http.exe", "https.exe"]
# Get binary file root folder
binary_home = sys.executable.replace("\\", "/").replace("python.exe", "Scripts")
# Bad python path searched
bad_python_path = "c:\\hostedtoolcache\\windows\\python\\3.7.9\\x64\\python.exe"
# Python runtime location
correct_python_path = sys.executable
# Process files
for f in binary_files:
    file_to_patch = f"{binary_home}/{f}"
    with open(file_to_patch, mode="rb") as file:
        content = file.read()
    content = content.replace(bad_python_path.encode(), correct_python_path.encode())
    with open(file_to_patch, mode="wb") as file:
        file.write(content)
