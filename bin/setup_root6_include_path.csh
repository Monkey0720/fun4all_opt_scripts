#! /bin/csh -f -x
unsetenv ROOT_INCLUDE_PATH
setenv EVT_LIB $ROOTSYS/lib
set first=1
set offline_main_done=0
# make sure our include dirs come first in ROOT_INCLUDE_PATH, 
# use OFFLINE_MAIN only if it comes in the list of arguments, flag it as used
if ($#argv > 0) then
  foreach arg ($*)
    if ($arg =~ *"$OFFLINE_MAIN"*) then
      set offline_main_done=1
    endif
    if (-d $arg) then
      foreach incdir (`find $arg/include -maxdepth 1 -type d -print`)
        if (-d $incdir) then
          if ($first == 1) then
            setenv ROOT_INCLUDE_PATH $incdir
            set first=0
          else
            if ($incdir !~ {*CGAL} && $incdir !~ {*Vc} && $incdir !~ {*rave}) then
              setenv ROOT_INCLUDE_PATH ${ROOT_INCLUDE_PATH}:$incdir
            endif
          endif
        endif
      end
    endif
  end
endif  
# add OFFLINE_MAIN include paths by default if not already done
if ($offline_main_done == 0) then
  if ($first == 1) then
    setenv ROOT_INCLUDE_PATH $OFFLINE_MAIN/include
  else
    setenv ROOT_INCLUDE_PATH ${ROOT_INCLUDE_PATH}:$OFFLINE_MAIN/include
  endif
  foreach incdir (`find $OFFLINE_MAIN/include -maxdepth 1 -type d -print`)
    if (-d $incdir) then
      if ($incdir !~ {*CGAL} && $incdir !~ {*Vc} && $incdir !~ {*rave}) then
        setenv ROOT_INCLUDE_PATH ${ROOT_INCLUDE_PATH}:$incdir
      endif
    endif
  end
endif
# add G4 include path
setenv ROOT_INCLUDE_PATH ${ROOT_INCLUDE_PATH}:$G4_MAIN/include
#echo $ROOT_INCLUDE_PATH
