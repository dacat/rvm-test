source "$rvm_path/scripts/rvm"

rvm remove  2.4.0-ntest --gems

## without gemsets

rvm install 2.4.0-ntest --skip-gemsets --disable-binary
# status=0
# match!=/Already installed/
# match=/Skipped importing default gemsets/
## match=/WARNING: Please be aware that you just installed a ruby that/
## match=/for a list of maintained rubies visit:/

rvm install 2.4.0-ntest
# status=0; match=/Already installed/

rvm 2.4.0-ntest do which gem
# match=/2.4.0-ntest/

rvm 2.4.0-ntest do gem env

rvm 2.4.0-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/rubygems-bundler/

rvm 2.4.0-ntest do ruby -v
# match=/2.4.0/

rvm remove  2.4.0-ntest --gems
# status=0; match=/[Rr]emoving/


## default/global gemsets

mkdir -p $rvm_path/gemsets/ruby/2.4.0/
printf "gem-wrappers\nhaml\n" > $rvm_path/gemsets/ruby/2.4.0/default.gems
printf "gem-wrappers\ntf\n"   > $rvm_path/gemsets/ruby/2.4.0/global.gems

rvm install 2.4.0-ntest
# status=0
# match!=/Already installed/
# match=/importing.*gemset/
## match=/WARNING: Please be aware that you just installed a ruby that/
## match=/for a list of maintained rubies visit:/

rvm 2.4.0-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]=/haml/
# match[stdout]=/tf/

rvm 2.4.0-ntest@global do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/haml/
# match[stdout]=/tf/

## Cleanup

rvm remove 2.4.0-ntest --gems
# status=0; match=/[Rr]emoving/

rm -rf $rvm_path/gemsets/ruby/2.4.0/

ls -1d $rvm_path/environments/*2.4.0-ntest*   # status!=0
ls -1d $rvm_path/wrappers/*2.4.0-ntest*       # status!=0
ls -1d $rvm_path/gems/*2.4.0-ntest*           # status!=0
ls -1d $rvm_path/bin/*2.4.0-ntest*            # status!=0

