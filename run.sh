echo "cloning repo..."
git clone SEU_REPO
echo "repo cloned."

cd ./setup

echo "installing configs"
chmod +x install.sh

./install.sh

echo "done."
