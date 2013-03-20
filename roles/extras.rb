name 'extras'
description 'Role to install extra packages: lesscss and uglifyjs'

run_list 'recipe[lesscss]',
          'recipe[uglifyjs]'