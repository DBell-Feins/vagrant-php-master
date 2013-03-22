name 'amp'
description 'Role to install AMP stack: apache2, mysql, php, and xml'

run_list 'recipe[apache2]',
          'recipe[apache2::mod_expires]',
          'recipe[apache2::mod_php5]',
          'recipe[apache2::mod_rewrite]',
          'recipe[mysql::server]',
          'recipe[php]',
          'recipe[php::module_curl]',
          'recipe[php::module_mysql]',
          'recipe[php::module_memcache]',
          'recipe[xml]',
          'recipe[phpplugins]',
          'recipe[phpapacheconf]'