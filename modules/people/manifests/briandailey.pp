class people::briandailey {
  notify { 'class people::briandailey declared': }
  include iterm2::dev
  include alfred
  include firefox
  include dropbox
  include libreoffice
  include spectacle
  include postgresapp
  include python
  include tmux

  git::config::global {
    'user.email': value => 'github@dailytechnology.net';
    'user.name': value => 'Brian Dailey';
    'push.default': value => 'current';
    'color.ui': value => 'auto';
    'core.autocrlf': value => 'input';
    'alias.lg': value => "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all";
  }

  $home     = "/Users/brian"
  $vimfiles = "${home}/.vim"

  repository { $vimfiles:
    source  => 'briandailey/vim-files',
  }

  package {
    [
        'bash-completion',
        'curl',
        'libevent',
        'tree',
        'sqlite',
        'gdbm',
        'cmake',
        'pkg-config',
        'readline',
        'python',
        'geos',
        'proj',
        'gdal'
      ]:
  }
  
  file { "${home}/.vimrc":
    ensure => 'link',
    target => "${vimfiles}/vimrc",
  }

  exec { 'pipinstallvirtualenvwrapper':
    command => 'pip install virtualenvwrapper'
  }

  exec { 'pipinstallflake8':
    command => 'pip install flake8'
  }

  include sysctl
  exec { 'pipinstallipython':
    command => 'pip install ipython'
  }

  exec { 'pipinstallnumpy':
    command => 'pip install numpy'
  }

  $my_homedir = "/Users/brian"

  # NOTE: Dock prefs only take effect when you restart the dock
  property_list_key { 'Hide the dock':
    ensure     => present,
    path       => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    key        => 'autohide',
    value      => true,
    value_type => 'boolean',
    notify     => Exec['Restart the Dock'],
  }

  property_list_key { 'Align the Dock Left':
    ensure     => present,
    path       => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    key        => 'orientation',
    value      => 'left',
    notify     => Exec['Restart the Dock'],
  }

  property_list_key { 'Lower Right Hotcorner - Screen Saver':
    ensure     => present,
    path       => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    key        => 'wvous-br-corner',
    value      => 10,
    value_type => 'integer',
    notify     => Exec['Restart the Dock'],
  }

  property_list_key { 'Lower Right Hotcorner - Screen Saver - modifier':
    ensure     => present,
    path       => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    key        => 'wvous-br-modifier',
    value      => 0,
    value_type => 'integer',
    notify     => Exec['Restart the Dock'],
  }

  exec { 'Restart the Dock':
    command     => '/usr/bin/killall -HUP Dock',
    refreshonly => true,
  }

  file { 'Dock Plist':
    ensure  => file,
    require => [
                 Property_list_key['Lower Right Hotcorner - Screen Saver - modifier'],
                 Property_list_key['Hide the dock'],
                 Property_list_key['Align the Dock Left'],
                 Property_list_key['Lower Right Hotcorner - Screen Saver'],
                 Property_list_key['Lower Right Hotcorner - Screen Saver - modifier'],
               ],
    path    => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    mode    => '0600',
    notify     => Exec['Restart the Dock'],
  }
}
