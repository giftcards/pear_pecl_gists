define phpbox::pecl_package (
  $package = $name,
  $ensure = 'installed',
) {

  if $ensure == 'installed' and $package != undef {
    exec { "pecl_${package}":
      command => "yes '' | pecl install ${package}",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      unless  => "pecl list ${package}",
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
    exec { "pecl_${package}":
      command => "yes '' | pecl uninstall ${package}",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      onlyif  => "pecl list ${package}",
      notify  => Service[$phpbox::services],
      require => Package[$phpbox::packages],
    }
  }
}
