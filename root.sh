#!/bin/bash
clear
[[ "$(whoami)" != "root" ]] && {
	clear
	echo -e "\033[1;31mExecute usando o usuario root, antes de executar esse script rode no terminal... \033[1;32m(\033[1;33msudo -i\033[1;32m)\033[0m"
	exit
}
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
	echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
service ssh restart > /dev/null
clear && echo -ne "\033[1;32mDigite uma nova senha para o usuario root\033[1;37m: "; read senha
[[ -z "$senha" ]] && {
echo -e "\n\033[1;31mSenha Invalida, tente de novo...\033[0m"
exit 0
}
echo "root:$senha" | chpasswd
echo -e "\n\033[1;31m[ \033[1;33mSenha Alterada com sucesso! \033[1;31m]\033[1;37m - \033[1;32mFaça o logout da VPS e faça novamente o login usando o usuario root e senha definida...\033[0m"
