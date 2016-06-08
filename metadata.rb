name             'storage'
maintainer       'EverTrue, Inc.'
maintainer_email 'eric.herot@evertrue.com'
license          'Apache v2.0'
description      'Installs/Configures storage'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.0.0'

supports 'ubuntu', '>= 12.04'
chef_version '~> 12.10'

depends 'ohai'
depends 'et_fog', '~> 4.0'
depends 'aws', '~> 3.3'
