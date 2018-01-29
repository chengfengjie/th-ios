
cd th-ios
find . -name "*.swift" |xargs grep -v "^$"|wc -l
cd ..
