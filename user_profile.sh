# Use this file to run your own startup commands
# See https://github.com/cmderdev/cmder/tree/master/config
## Add important EXE to $PATH
echo -n "[+] Setting environment variables..."
cd ..
javaBinExePath=$(find . -type f -name "java.exe")
javaBinExePathFolder=$(dirname $(realpath $javaBinExePath))
javaHome=$(dirname $javaBinExePathFolder)
export JAVA_HOME=$javaHome
export PATH=$javaBinExePathFolder:$PATH
pythonBinExePath=$(find . -type f -name "python.exe")
pythonBinExePathFolder=$(dirname $(realpath $pythonBinExePath))
export PYTHONHOME=$pythonBinExePathFolder
export PATH=$pythonBinExePathFolder:$PATH
pipBinExePath=$(find . -type f -name "pip.exe")
pipExePathFolder=$(dirname $(realpath $pipBinExePath))
export PATH=$pipExePathFolder:$PATH
export PATH=$(pwd):$PATH
echo "OK"
alias ll='ls --color=auto -rtl'
