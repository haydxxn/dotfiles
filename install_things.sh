echo "Free Things 3"
echo "Removing current Thing 3 and its files..."

osascript -e 'quit app "things"'

rm -rf /Applications/Things3.app
rm -rf ~/Library/Caches/com.culturedcode.ThingsMac
rm -rf ~/Library/Containers/com.culturedcode.ThingsMac
rm -rf ~/Library/Preferences/com.culturedcode.ThingsMac.plist

echo "Downloading new Things 3 from the website"
curl -L http://culturedcode.com/things/download/ -o ~/Downloads/Things3.zip

echo "Unzipping..."
unzip -o ~/Downloads/Things3.zip -d ~/Downloads

echo "Moving to Application folder and delete zip file..."
mv ~/Downloads/Things3.app /Applications/
rm -rf ~/Downloads/Things3.zip

echo "Done!"
open -a Things3
