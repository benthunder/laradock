#!/bin/bash

# This shell to quick command create a site in nginx and apache
echo 'Enter your site name (name of project root)? : '; 
read site_name;

parent_dir=$(dirname $PWD);
# Check exist file in project root
if [ ! -d "$parent_dir/$site_name" ]; then
    mkdir $parent_dir/$site_name;
    # Add to hosts
    echo 'coppy to this to C\:\\Windows\\System32\\drivers\\etc\\hosts';
    echo "127.0.0.1 $site_name.local";
    echo "::1       $site_name.local";

else
    echo 'Folder Exist';
fi
# Create site in apache
cp apache2/sites/sample.conf.example apache2/sites/$site_name.conf;

sed -i "s/sample.test/$site_name.local/g" apache2/sites/$site_name.conf;
sed -i "s/\/var\/www\/sample\/public\//\/var\/www\/$site_name\//g" apache2/sites/$site_name.conf;

# Create site in nginx

cp nginx/sites/app.conf.example nginx/sites/$site_name.conf;

sed -i "s/server_name app.test/server_name $site_name.local/g" nginx/sites/$site_name.conf;
sed -i "s/root \/var\/www\/app/root \/var\/www\/$site_name/g" nginx/sites/$site_name.conf;
sed -i "s/app_error.log/$site_name\_error.log/g" nginx/sites/$site_name.conf;
sed -i "s/app_access.log/$site_name\_access.log/g" nginx/sites/$site_name.conf;

echo "Site Name: $site_name.local";
echo "Dir Path: $parent_dir/$site_name";
echo "Run docker compose\n";
code $parent_dir/$site_name
exit 1;