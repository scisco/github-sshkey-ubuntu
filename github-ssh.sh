#!/bin/sh

## Author: scisco

echo "Please enter the github usernames separating them by comma and no spaces."
echo "For example: user1,user2,user3"
echo ""
read users


##############################
## ADD SSH KEYS
##############################

## Convert Users into array
IFS=',' read -a user_array <<< "$users"

counter=0

## Grab SSH keys from Github for specified users
for user in "${user_array[@]}"; do
	keys=$(curl -s https://api.github.com/users/$user/keys | jq '.[]' | jq -r '.key')

	## Convert SSH Keys into Bash Array
	while IFS= read -r line; do
	  key_array[$counter]="$line"
	  let counter=counter+1
	done <<< "$keys"
done


## Add them to authorized_keys
for key in "${key_array[@]}"; do
	echo $key >> $setup_dir/.ssh/authorized_keys
done

## Fix authorized_keys permission
chmod 644 $setup_dir/.ssh/authorized_keys

echo ""
echo "$counter public SSh keys were added"
exit 1
