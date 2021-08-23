# Use this file to run your own startup commands
# See https://github.com/cmderdev/cmder/tree/master/config
## Add any folder containing EXE file to $PATH
echo -n "[+] Setting PATH and JAVA_HOME environment variables..."
cd ..
javaBinExePath=$(find . -type f -name "java.exe")
javaBinExePathFolder=$(dirname $(realpath $javaBinExePath))
javaHome=$(dirname $javaBinExePathFolder)
export JAVA_HOME=$javaHome
for p in $(find . -maxdepth 3 -type d)
do
	fullPath=$(realpath $p)
	export PATH=$PATH:$fullPath
done
echo "OK"
alias ll='ls --color=auto -rtl'
