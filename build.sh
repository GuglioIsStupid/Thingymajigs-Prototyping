makelove --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "makelove not found. Please install it with 'pip install makelove'."
    exit 1
fi

cd src/ && makelove && cd ..
if [ $? -ne 0 ]; then
    echo "Failed to build the game."
    exit 1
fi

echo "Press any key to continue..."
read -n 1

exit 0