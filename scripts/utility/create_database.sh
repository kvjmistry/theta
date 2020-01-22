# This is for a first time setup

# USAGE: source create_database.sh <your database name>  

# Load Balsam -- make sure you check that this is the right version of balsam you want to use, if you want to use the most up-to-date version then omit the version.
#module load balsam/0.3.5.1

# For modified balsam version
module load cray-python/3.6.1.1; 
source /lus/theta-fs0/projects/uboone/env2/bin/activate;

balsam_database=$1

# Create a balsam databse called uboone_balsam
balsam init /lus/theta-fs0/projects/uboone/balsam_databases/$balsam_database

# Set some permissions for the database so all users can use it
find $balsam_database/ -type d -exec chmod g+rwx {} \;
find $balsam_database/ -type f -exec chmod  g+rw {}   \;
find $balsam_database/ -executable -type f -exec chmod g+x {} \;
chmod 700 $balsam_database/balsamdb/

# Actvate the database
. balsamactivate $balsam_database

# Now we should add the additional users who are going to user the database
balsam server --add-user andrzej
balsam server --add-user cadams
balsam server --add-user elenag

# Set permissions so that other users can modify the folders you create from balsam 
umask g=rwx

# Set the stripe of the balsam data folder (this is where your output files will go)
lfs setstripe -c 56 $balsam_database/data/
