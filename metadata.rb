name             'storage'
maintainer       'EverTrue, Inc.'
maintainer_email 'eric.herot@evertrue.com'
license          'Apache v2.0'
description      'Installs/Configures storage'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.1'

supports 'ubuntu', '>= 12.04'

depends 'ohai'
depends 'et_fog', '~> 2.0'
depends 'aws', '~> 3.3'
