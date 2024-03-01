set -ex

vagrant box add --force my-box generic-redos-virtualbox-.box
export VAGRANT_DEFAULT_PROVIDER=virtualbox
vagrant init my-box
vagrant up

#rpm -qa --queryformat '%10{size} - %-25{name} \t %{version}\n' | sort -n
#repoquery -q --installed --whatrequires libX11
#rpm -q --whatrequires libX11
