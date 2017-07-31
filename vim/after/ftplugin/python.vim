""let b:git_remote_name=split(system('git remote show origin -n | grep "Fetch URL:"'),'/')[-1]
let b:git_remote_name=fnamemodify(system('git remote show origin -n | grep "Fetch URL:"'),':t:s?\n??')
if b:git_remote_name!=#'ExMachina.git'
  " Return python ftplugin to 2 spaces
  setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
endif
"
