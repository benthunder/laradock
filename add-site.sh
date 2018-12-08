#!/bin/bash


#   get project_name
#   get type of project
#
#   validate project_name
#       if [ has name ] - don't edit hosts file
#   validate project_name_dir
#       if [ has dir ] - don't creat
#   coppy file host by type
#   replace text in file
#   create coppy hosts file
#   
#   create project_root_dir
#   create project_error_dir
#   

# This shell to quick command create a site in nginx and apache

#   Get file name
echo 'Enter your site name (name of project root)? : ';
read -r site_name;

#   Get file type
site_type_list=("symfony" "laravel" "normal")
site_type_list_length=${#site_type_list[*]}
for (( i=0; i<=$(( site_type_list_length -1 )); i++ ))
do 
    printf "%s.%s\n" "$(( i+1 ))" "${site_type_list[${i}]}"; 
done

read -r site_type_number;
site_type_number=$site_type_number-1;
site_type_select="${site_type_list[$site_type_number]}";

#   Validate site type
if [[ -z $site_type_select ]]; then
    printf "Please ! enter valid site type\n"; exit 1
fi
printf "%s\n" "${site_type_select}";

#   Validate site name
site_host_name="127.0.0.1   ${site_name}.local"
if grep -Fxq "${site_host_name}" /etc/hosts; then
    printf "%s is exists\n" "${site_host_name}"
else
    sudo cp /etc/hosts /etc/hosts.bak
    echo "${site_host_name}" | sudo tee - a /etc/hosts
    printf "%s\n"   "${site_host_name}"
fi

parent_dir=$(dirname "$PWD")
if [ -d "$parent_dir/$site_name" ]; then
    printf 'Folder %s is Exist\n' $site_name;
else
    mkdir "$parent_dir/$site_name"
    printf "project root %s\n"   "$parent_dir/$site_name"
fi

if [ ! -f "apache2/sites/$site_name.conf" ]; then
    cp "apache2/sites/${site_type_select}.conf.example" "apache2/sites/$site_name.conf"
    sed -i "s/project_name/${site_name}/g"  "apache2/sites/$site_name.conf"
else
    printf "%s is exist\n"   "apache2/sites/$site_name.conf"
fi

if [ ! -f "nginx/sites/$site_name.conf" ]; then
    cp "nginx/sites/${site_type_select}.conf.example" "nginx/sites/$site_name.conf"
    sed -i "s/project_name/${site_name}/g"  "nginx/sites/$site_name.conf"
else
    printf "%s is exist\n"   "nginx/sites/$site_name.conf"
fi

#   Create error
if [ ! -f "../log/nginx/${site_name}.error.log" ]; then
    touch "../log/nginx/${site_name}.error.log"
else
    printf "%s is exist\n"   "../log/nginx/${site_name}.error.log"
fi

if [ ! -f "../log/apache2/${site_name}.error.log" ]; then
    touch "../log/apache2/${site_name}.error.log"
else
    printf "%s is exist\n"   "../log/apache2/${site_name}.error.log"
fi

echo 'Done , restart docker apache or nginx container and happy coding :)'
read -r
exit 1