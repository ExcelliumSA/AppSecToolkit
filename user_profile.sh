# Use this file to run your own startup commands
# See https://github.com/cmderdev/cmder/tree/master/config
## Add any folder containing EXE file to $PATH
echo -n "[+] Setting PATH and JAVA_HOME environment variables..."
cd ..
javaBinExePath=$(find . -type f -name "java.exe")
javaBinExePathFolder=$(dirname $(realpath $javaBinExePath))
javaHome=$(dirname $javaBinExePathFolder)
export JAVA_HOME=$javaHome
for p in $(find $(pwd) -maxdepth 5 -type f -name "*.exe")
do
	fullPath=$(dirname $p)
	if [ $(echo $PATH | grep -cF $fullPath) -lt 1 ]
	then
		export PATH=$PATH:$fullPath	
	fi
done
echo "OK"
alias ll='ls --color=auto -rtl'
