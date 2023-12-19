if [ ! -f /etc/pam.d/sudo_local ]; then
	cat <<- EOF > /tmp/sudo_local
		# sudo_local: local config file which survives system update and is included for sudo
		# uncomment following line to enable Touch ID for sudo
		auth       sufficient     pam_tid.so
EOF

	sudo chown root:wheel /tmp/sudo_local
	sudo chmod 444 /tmp/sudo_local
	sudo mv /tmp/sudo_local /etc/pam.d/sudo_local
fi
