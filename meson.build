project('sigtool', 'cpp', default_options : ['cpp_std=c++17'])
libcrypto = dependency('openssl', modules : ['crypto'])
inc = include_directories('vendor')
commonSrcs = ['macho.cpp', 'signature.cpp', 'hash.cpp', 'commands.cpp', 'der.cpp']
sigtool = executable('sigtool', 'main.cpp', commonSrcs, include_directories : inc, dependencies : libcrypto, install : true)
codesign = executable('codesign', 'codesign.cpp', commonSrcs, include_directories : inc, dependencies : libcrypto, install : true)
if build_machine.system() == 'darwin' and get_option('buildtype').startswith('debug')
  dsymutil = find_program('dsymutil')
  custom_target('sigtool.dSYM', input : sigtool, output : 'sigtool.dSYM', command : [dsymutil, '@INPUT@'], install : true, install_dir : 'bin')
  custom_target('codesign.dSYM', input : codesign, output : 'codesign.dSYM', command : [dsymutil, '@INPUT@'], install : true, install_dir : 'bin')
endif