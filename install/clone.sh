rm -rf /home/pet/spm-db/spm-db/Gemfile.lock
cd /home/pet/spm-db/spm-db/
sudo chmod -R 777 /home/pet/spm-db/spm-db/
echo " "
echo "********************"
echo "   GIT OPERATIONS   "
echo "********************"
git reset --hard
git pull
echo "  "
echo "***********************************"
echo "  Modification de 'database.yaml'  "
echo "***********************************"
cp /home/pet/spm-db/spm-db/install/orga_clone_material/database.yml /home/pet/spm-db/spm-db/config/database.yml
sudo chmod -R 777 /home/pet/spm-db/spm-db/
echo "  "
echo "********************"
echo "  Update des GEM's  "
echo "********************"
bundle install
sudo bundle update
echo "  "
echo "**************"
echo "  Migrations  "
echo "**************"
rails db:migrate
