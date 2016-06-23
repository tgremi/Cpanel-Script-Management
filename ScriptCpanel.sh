#!/bin/bash

  ####################################################################################################
  #|"Script feito para aprimorar análise e agilizar atendimento no suporte técnico a Revenda cPanel" #
  #|"LWRev Version 1.0                                                                               #
  #|"Thalles W. Gremi thallesgremi@gmail.com                                                         #
  #|"                                                                                                #
  ####################################################################################################

  insert=9
  no="n"
  yes="y"


  Menu(){

    echo "                             Selecione a operação desejada:             "
    echo -e "\033[44;1;37m      1 - Verificar Local Mail Exchanger                                  \033[0m"
    echo -e "\033[44;1;37m      2 - Criar contas de email                                           \033[0m"
    echo -e "\033[44;1;37m      3 - Deletar contas de email                                         \033[0m"
    echo -e "\033[44;1;37m      4 - Acessar FTP                                                     \033[0m"
    echo -e "\033[44;1;37m      5 - Fila de email Exim                                              \033[0m"
    echo -e "\033[44;1;37m      6 - Ranking da fila de Exim (por domínio)                           \033[0m"
    echo -e "\033[44;1;37m      7 - Deletar zona de DNS (KillDNS)                                   \033[0m"
    echo -e "\033[44;1;37m      8 - Consultar Zona de DNS                                           \033[0m"
    echo -e "\033[44;1;37m      9 - Consultar IP                                                    \033[0m"
    echo -e "\033[44;1;37m      10 - Gerenciar suspensao de email                                   \033[0m"
    echo -e "\033[44;1;37m      11 - Gerenciar suspensao de usuario                                 \033[0m"
    echo -e "\033[44;1;37m      0 - Encerrar programa                                               \033[0m"
    read insert

    case "$insert" in

      1) LocalMailConsult  ;;
      2) CreateEmailAccount ;;
      3) DeleteEmailAccount ;;
      4) FtpAccess ;;
      5) VerifyQueueEmail ;;
      6) RankingQueueEmail ;;
      7) ZoneDNSDelete    ;;
      8) DnsZoneConsult ;;
      9) IpConsult ;;
      10) VerifySupendAccountUser ;;
      11) VerifySuspendEmailAccount ;;

    esac
  }

###########################################################################################################################################

###########################################################################################################################################
  LocalMailConsult(){

    echo "Digite o dominio (subdominio) que deseja conultar:"
    read consult
    echo "***********************************************************"
    verify=`sudo grep -hi $consult /etc/localdomains | wc -l`
    verify1=`sudo grep -hi $consult /etc/localdomains`

    if [ "$verify" -gt 0 ]
      then
      echo "Domínio está como Servidor de e-mail Local:"
      echo ""
      echo "$verify1 "
      echo ""
      echo "***********************************************************"
    fi

    if [ "$verify" -eq 0 ]
      then
      echo " Domínio não está como Servidor de e-mail Local"
      echo ""
      echo "$verify1"
      echo ""
      echo "***********************************************************"

    fi
  }

  ###########################################################################################################################################

  ###########################################################################################################################################

  CreateEmailAccount (){
    echo ""
    echo "Digite a conta de e-mail que deseja criar:"
    read account
    echo -e "\033[1;32m***********************************************************\033[0m"
    echo ""
    echo "Digite a senha para a conta de email:"
    read pass
    echo -e "\033[1;32m***********************************************************\033[0m"
    echo ""
    echo "Digite a quota de disco da conta de e-mail (mb):"
    read quot
    echo -e "\033[1;32m***********************************************************\033[0m"
    echo ""
    echo -e "\033[1;33m      Confira os dados  abaixo:         \033[0m "
    echo -e "\033[1;33m______________________________________________\033[0m "
    echo    "   Conta:    "   $account
    echo -e "\033[1;33m______________________________________________\033[0m "
    echo    "   Senha:    "   $pass
    echo -e "\033[1;33m______________________________________________\033[0m "
    echo    "Cota de disco:"  $quot "Mb"
    echo -e "\033[1;33m______________________________________________\033[0m "
    echo "Prosseguir com a criação da conta? "
    echo -e "\033[1;33m______________________________________________\033[0m "
    echo "Digite y para sim ou n para não:"
    read selec

    if [ "$selec" == "$yes" ]
    then
    sudo /scripts/addpop --email=$account --password=$pass --quota=$quot
    fi
    if [ "$selec" == "$no" ]
    then
    echo -e "\033[41;1;37m  Operação cancelada!   \033[0m";
    fi
  }

  ###########################################################################################################################################

  ###########################################################################################################################################

  DeleteEmailAccount(){
  echo "Digite a conta de email que deseja deletar:"
  read deleteAccount
  echo "***********************************************************"
  echo ""
  echo "Deseja realmente excluir a conta? \n" $deleteAccount
  echo "Digite y para sim ou n para não:"
  echo ""
  read selec

  if [ "$selec" == "$yes" ]
  then
  echo -e "\033[41;1;37m #################################################################  \033[0m"
  sudo /scripts/delpop --email=$deleteAccount
  echo -e "\033[41;1;37m #################################################################  \033[0m"
  fi
  if [ "$selec" == "$no" ]
  then
  echo -e "\033[41;1;37m #################################################################  \033[0m"
  echo "Operação cancelada!"
  echo -e "\033[41;1;37m #################################################################  \033[0m"
  fi
  }

###########################################################################################################################################

###########################################################################################################################################

  FtpAccess(){
    echo "Insira o usuario que deseja acessar o FTP:"
    read userDomain
    verify=`sudo ls -l /home | grep $userDomain | wc -l`

    if [ "$verify" -eq 1 ]
      then
      echo $verify
      echo ""
      echo "Usuario existente"
      echo ""
      echo "Acessar? y - Sim | n - Nao"
      read selc
      echo ""

      if [ "$selec" == "$yes" ]
        then
        echo ""
        echo -e "\033[41;1;37m !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \033[0m"
        echo -e "\033[41;1;37m !         Digite cd para ir para home do usuario.               ! \033[0m"
        echo -e "\033[41;1;37m !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \033[0m"
        sudo su $userDomain -s /bin/bash
        echo ""
      fi

      if [ "$selec" == "$no" ]
        then
        echo "Operação cancelada!"
      fi

    else
      echo "Usuario inexistente!"
    fi


  }

###########################################################################################################################################

###########################################################################################################################################

  VerifyQueueEmail (){
    verify=`sudo exim -bpc`

    if [ "$verify" -gt 1 ]
      then
      echo ""
      echo -e "\033[41;1;37m !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \033[0m"
      echo -e "\033[41;1;37m !                    Fila de email: " $verify "                 ! \033[0m"
      echo -e "\033[41;1;37m !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \033[0m"
      echo ""
    else
      echo -e "\033[42;1;37m***********************************************************\033[0m"
      echo -e "\033[42;1;37m*                 Fila de email zerada!                   *\033[0m"
      echo -e "\033[42;1;37m***********************************************************\033[0m"
    fi

  }

###########################################################################################################################################

###########################################################################################################################################

  RankingQueueEmail () {
    echo ""
    echo "***********************************************************"
    echo "Ranking por dominios: "
    echo "***********************************************************"
    echo ""
    sudo exim -bp | grep "<" | awk '{print $4}' | awk -F@ '{print $2}' | sort | uniq -c | sort -n | sed 's/>//g;' | tail -n 5 | tac
  }



  ZoneDNSDelete (){
    echo "Deletar zona DNS"
    echo "Digite o domínio que deseja deletar a zona:"
    read verify
    echo ""
    echo -e "\033[41;1;37m ################################################################# \033[0m"
    echo "Deseja realmente deletar o domínio:? " $verify
    echo -e "\033[41;1;37m ################################################################# \033[0m"

    echo "Digite y - SIM ou n - NAO:"
    read selec
    echo ""
    if [ "$selec" == "$yes" ]
      then
      echo -e "\033[41;1;37m ################################################################# \033[0m"
      sudo /scripts/killdns $verify
      echo -e "\033[41;1;37m ################################################################# \033[0m"
      echo ""
    fi

    if [ "$selec" == "$no" ]
      then
      echo -e "\033[41;1;37m ################################################################# \033[0m"
      echo "Operação cancelada!"
      echo -e "\033[41;1;37m ################################################################# \033[0m"
      echo ""
    fi

  }

###########################################################################################################################################

###########################################################################################################################################

  DnsZoneConsult () {
    echo "Digite o domínio que deseja consultar o DNS: "
    read selectDomain
    verify1=`sudo ls -l /var/named/ | grep $selectDomain.db | wc -l`

    if [ "$verify1" -eq 1 ]
      then
      sudo cat /var/named/$selectDomain.db | awk {'print "\033[1;32m" $1  "\033[0m" "\t" "\t" $2 "\t""\t" $3"\t""\t" "\033[1;32m \t" $4 "\033[0m" "\t""\t" "\033[1;32m \t" $5"\t""\t"$6 "\t""\t"$7 "\033[0m" '}

    else
      echo -e "\033[41;1;37m ################################################################# \033[0m"
      echo -e "\033[41;1;37m #               Domínio " $selectDomain " inexistente           #\033[0m"
      echo -e "\033[41;1;37m ################################################################# \033[0m"
    fi
  }

###########################################################################################################################################

###########################################################################################################################################

  IpConsult (){
    insert2=9

    while [ $insert2 -gt 3 ]
    do


      echo "                             Selecione a operação desejada:             "
      echo -e "\033[44;1;37m      1 - Verificar Log do cphulk.log                                   \033[0m"
      echo -e "\033[44;1;37m      2 - Retirar bloqueio de um IP                                     \033[0m"
      echo -e "\033[44;1;37m      3 - Retornar menu anterior                                        \033[0m"
      read insert2



      case "$insert2" in
        1)

        echo "Digite o IP do cliente: "
        echo -e  "\033[41;1;37m Inserir como o exemplo(com ponto para separar os numeros): 111.111.111 \033[0m"
        read ip
        verify1=`sudo cat /usr/local/cpanel/logs/cphulkd.log | grep "$ip" | wc -l`

        if [ "$verify1" -gt 0 ]
          then
          verify=`sudo cat /usr/local/cpanel/logs/cphulkd.log | grep "$ip"`
          echo -e "\033[41;1;37m ################################################################# \033[0m"
          echo -e "\033[41;1;37m #               IP " $ip " consta em log                        # \033[0m"
          echo -e "\033[41;1;37m ################################################################# \033[0m"
          echo -e "\033[41;1;37m _________________________________________________________________ \033[0m"
          echo -e "\033[41;1;37m                   $verify                                         \033[0m"
          echo -e "\033[41;1;37m _________________________________________________________________ \033[0m"
        else
          echo -e "\033[42;1;37m ################################################################# \033[0m"
          echo -e "\033[42;1;37m #               IP " $ip " não consta em log                    # \033[0m"
          echo -e "\033[42;1;37m ################################################################# \033[0m"
        fi
        ;;

        2)

        echo "Digite o IP do cliente: "
        echo -e  "\033[41;1;37m Inserir como o exemplo(com ponto para separar os numeros): 111.111.111 \033[0m"
        read ip
        verify=`sudo whmapi1 flush_cphulk_login_history_for_ips ip=$ip`
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[42;1;37m #           $ip | Confira o log abaixo                          # \033[0m"
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        echo -e "\033[1;33m                   $verify                                         \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        ;;

      esac
    done
  }

###########################################################################################################################################

###########################################################################################################################################

  VerifySupendAccountUser(){
    insert2=9
    while [ $insert2 -gt 3 ]
    do


      echo "                             Selecione a operação desejada:             "
      echo -e "\033[44;1;37m      1 - Suspender usuário                                   \033[0m"
      echo -e "\033[44;1;37m      2 - Retirar suspensao de usuario                                     \033[0m"
      echo -e "\033[44;1;37m      3 - Retornar menu anterior                                        \033[0m"
      read insert2

      case "$insert2" in
        1)
        echo "Digite o usuario de cPanel que deseja retirar suspensao: "
        read suspendUser

        verify=`sudo /scripts/suspendacct $suspendUser`
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[42;1;37m #           $suspendUser | Confira o log abaixo                          # \033[0m"
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        echo -e "\033[1;33m                   $verify                                         \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        ;;

        2)
        echo "Digite o usuario de cPanel que deseja retirar suspensao: "
        read suspendUser

        verify=`sudo /scripts/unsuspendacct $suspendUser`
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[42;1;37m #           $suspendUser | Confira o log abaixo                          # \033[0m"
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        echo -e "\033[1;33m                   $verify                                         \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        ;;

      esac
    done
  }

###########################################################################################################################################

###########################################################################################################################################

  VerifySuspendEmailAccount(){
    insert2=9
    while [ $insert2 -gt 3 ]
    do


      echo "                             Selecione a operação desejada:             "
      echo -e "\033[44;1;37m      1 - Suspender servico de email                                   \033[0m"
      echo -e "\033[44;1;37m      2 - Retirar suspensao do Servico de email                                     \033[0m"
      echo -e "\033[44;1;37m      3 - Retornar menu anterior                                        \033[0m"
      read insert2

      case "$insert2" in
        1)
          echo "Digite o usuario de cPanel do domínio: "
          read userDomain
          verify=`/usr/sbin/whmapi1 suspend_outgoing_email user=$userDomain`
          echo -e "\033[42;1;37m ################################################################# \033[0m"
          echo -e "\033[42;1;37m #           $userDomain | Confira o log abaixo                          # \033[0m"
          echo -e "\033[42;1;37m ################################################################# \033[0m"
          echo -e "\033[1;33m _________________________________________________________________ \033[0m"
          echo -e "\033[1;33m                   $verify                                         \033[0m"
          echo -e "\033[1;33m _________________________________________________________________ \033[0m"

        ;;

        2)
        echo "Digite o usuario de cPanel do domínio: "
        read userDomain
        verify=`/usr/sbin/whmapi1 unsuspend_outgoing_email user=$userDomain`
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[42;1;37m #           $userDomain | Confira o log abaixo                          # \033[0m"
        echo -e "\033[42;1;37m ################################################################# \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        echo -e "\033[1;33m                   $verify                                         \033[0m"
        echo -e "\033[1;33m _________________________________________________________________ \033[0m"
        ;;
      esac
    done
  }

###########################################################################################################################################

###########################################################################################################################################


  while [ $insert -gt 0 ]
  do
    Menu
  done
