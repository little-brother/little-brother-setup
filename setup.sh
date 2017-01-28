set -e

echo "*************************************************"
echo "*** Welcome to Little brother DCIM installer! ***"
echo "*************************************************"
SETUP_DIR="$(pwd)"

echo -n Set install location: 
read install_dir

if [ ! -d "$install_dir" ];
    then 
	echo -n PRESS ENTER TO CREATE $install_dir
	read dummy
	mkdir -p $install_dir
    else
	echo -n PRESS ENTER TO CLEAR $install_dir
	read dummy
	if [ "$install_dir" = "/" ]
		then exit 1	
	fi

	rm -rf $install_dir
	mkdir -p $install_dir
fi

cd -P $install_dir

echo Start download...
node "$SETUP_DIR"/cli/download https://github.com/little-brother/little-brother-dcim/archive/master.zip sources.zip
node "$SETUP_DIR"/cli/unzip sources.zip .

source="$install_dir"/little-brother-dcim-master

cd $source
find . -maxdepth 1 -exec mv {} .. \; 2> /dev/null
cd ..
rm -df  $source
rm -f sources.zip

echo Install modules...
npm i

echo Start download local agent...
mkdir agent
cd agent
node "$SETUP_DIR"/cli/download https://github.com/little-brother/little-brother-dcim-agent/archive/master.zip sources.zip
node "$SETUP_DIR"/cli/unzip sources.zip .

source="$install_dir"/agent/little-brother-dcim-agent-master

cd $source
find . -maxdepth 1 -exec mv {} .. \; 2> /dev/null
cd ..
rm -df  $source
rm -f sources.zip

echo Install modules...
npm i

cd -P $install_dir

# patch PATH in package.json
node "$SETUP_DIR"/cli/patch-json package.json scripts.start "NODE_PATH=.:./models:./tools:./services:./include && node app.js"

echo "*************************************************"
echo "***      PRESS ENTER TO RUN APPLICATION       ***"
echo "***      and open login page in browser       ***" 
echo "***        Use admin/admin to log in          ***" 
echo "*************************************************"
read dummy
#start cmd /k npm start
sleep 5
python -mwebbrowser http://127.0.0.1:2000