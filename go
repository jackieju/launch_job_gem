rm *.gem
echo build..
gem build launch_job.gemspec
echo install..
gem install --local *.gem
sudo gem install --local *.gem
