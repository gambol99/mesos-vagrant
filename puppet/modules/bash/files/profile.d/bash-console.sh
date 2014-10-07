#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2013-07-29 16:26:58 +0100 (Mon 29 Jul 2013)
#  $LastChangedBy$
#  $LastChangedDate$
#  $Revision$
#  $URL$
#  $Id$
#

case $- in
   *i*) ;;
     *) return 0;;
esac

tty=`tty`
case $tty in
    /dev/tty*)   :;;
            *)   return 0;;
esac

export TMOUT=600
setterm -blank 0
