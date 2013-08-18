
Use (don't run this without checking what the script does!)

	cd
	bash < <( curl https://raw.github.com/danmichaelo/dotfiles/master/bootstrap.sh )

If xmlint is missing

	apt-get install libxml2-utils

If ruby is missing

	\curl -L https://get.rvm.io | bash -s stable
	source ~/.rvm/scripts/rvm
	rvm install 1.9.3
