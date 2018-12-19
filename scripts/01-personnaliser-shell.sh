#!/bin/bash
#
# 01-personnaliser-shell.sh

# Exécuter en tant que root
if [ $EUID -ne 0 ] ; then
  echo "::"
  echo ":: Vous devez être root pour exécuter ce script."
  echo "::"
  exit 1
fi

# Répertoire courant
CWD=$(pwd)

# Interrompre en cas d'erreur
set -e

# Couleurs
VERT="\033[01;32m"
GRIS="\033[00m"

# Pause entre les opérations
DELAY=1

# ... [OK]
function ok () {
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
}

# Personnalisation du shell Bash pour root
echo
echo -e ":: Configuration du shell Bash pour l'administrateur... \c"
sleep $DELAY
cat $CWD/../config/bash/root-bashrc > /root/.bashrc
ok

# Personnalisation du shell Bash pour les utilisateurs
echo "::"
echo -e ":: Configuration du shell Bash pour les utilisateurs... \c"
sleep $DELAY
cat $CWD/../config/bash/user-alias > /etc/skel/.alias
if [ ! -z "$(ls -A /home)" ]; then
  for UTILISATEUR in $(ls /home); do
    cat $CWD/../config/bash/user-alias > /home/$UTILISATEUR/.alias
    chown $UTILISATEUR:users /home/$UTILISATEUR/.alias
  done
fi
ok

# Quelques options pratiques pour Vim
echo "::"
echo -e ":: Configuration de Vim... \c"
sleep $DELAY
cat $CWD/../config/vim/vimrc > /etc/vimrc
ok

# Configuration du terminal graphique
echo "::"
echo -e ":: Configuration du terminal graphique... \c"
sleep $DELAY
cat $CWD/../config/xterm/Xresources > /root/.Xresources
cat $CWD/../config/xterm/Xresources > /etc/skel/.Xresources
if [ ! -z "$(ls -A /home)" ]; then
  for UTILISATEUR in $(ls /home); do
    cat $CWD/../config/xterm/Xresources > /home/$UTILISATEUR/.Xresources
    chown $UTILISATEUR:users /home/$UTILISATEUR/.Xresources
  done
fi
ok

echo

exit 0
