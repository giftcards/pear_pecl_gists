define phpbox::pear_package (
  $package = $name,
  $ensure = 'installed',
) {

  if $ensure == 'installed' and $package != undef {
    exec { "pear_${package}":
      command => "yes '' | pear install ${package}",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      unless  => "pear list ${package}",
      require => [
        Package[$phpbox::packages],
        Package['gcc'],
      ],
      notify  => Service[$phpbox::services],
    }

    if ! defined(Package['gcc']) {
      package { 'gcc': ensure => installed, }
    }
  }

  if $ensure == 'absent' and $package != undef {
    exec { "pear_${package}":
      command => "yes '' | pear uninstall ${package}",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      onlyif  => "pear list ${package}",
      notify  => Service[$phpbox::services],
      require => Package[$phpbox::packages],
    }
  }
}
