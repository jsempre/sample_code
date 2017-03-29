#!/bin/bash
# Menu driven options for plansource operations 

. /app_2/scripts/psadmin_env_variables.sh

RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
pause(){
 read -p "Press [Enter] key to continue..." fackEnterKey
}

 
migrate_ui(){
 sh $UI_MIGRATION
 pause
}

migrate_app(){
 if [ $deploy_app == 'all' ]; then
  read -p "Enter sha1 revision string of desired benefits/utility release:" benefits_release_sha
  read -p "Enter sha1 revision string of desired broker release:" broker_release_sha
  read -p "Enter sha1 revision string of desired admin release:" admin_release_sha
 else
  read -p "Enter sha1 revision string of desired $deploy_app release:" release_sha
 fi

  read -p "Enter sha1 revision string of corrosponding ps_shared release:" ps_shared_sha
  read -p "Enter sha1 revision string of corrosponding ps_shared_assets release:" ps_shared_assets_sha

 if [ $deploy_app == 'all' ]; then
  cd /app_2/deploy/benefits/develop
  REVISION=$benefits_release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE deploy
  pause
  version_check
  echo "Migrating Utility next "
  pause
  REVISION=$benefits_release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE_UTIL deploy
  pause
  version_check
  echo "Migrating Broker next "
  pause
  cd /app_2/deploy/broker/develop
  REVISION=$broker_release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE deploy
  pause
  version_check
  echo "Migrating Admin next "
  pause
  cd /app_2/deploy/admin/develop
  REVISION=$admin_release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE deploy

 elif [ $deploy_app == 'benefits' ]; then
  cd /app_2/deploy/benefits/develop
  REVISION=$release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE deploy
  pause
  version_check
  echo "Migrating Utility next "
  REVISION=$release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE_UTIL deploy

 else
  cd /app_2/deploy/$deploy_app/develop

  REVISION=$release_sha PS_SHARED_VERSION=$ps_shared_sha PS_SHARED_ASSETS_VERSION=$ps_shared_assets_sha bundle exec cap -f $CAPFILE deploy
 
 fi

 pause
 version_check

}

version_check(){

 for i in $BENEFITS_SERVERS
  do
   echo "Benefits Version on $i"
   ssh $i "cat /app_2/filestore/benefitkey/rails/current/REVISION" 
 done

 for i in $BROKER_SERVERS
  do
   echo "Broker Version on $i"
   ssh $i "cat /app_2/filestore/broker/rails/current/REVISION"
 done

 for i in $ADMIN_SERVERS
  do
   echo "Admin Version on $i"
   ssh $i "cat /app_2/filestore/admin/rails/current/REVISION"
 done

 for i in $UTILITY_SERVERS
  do
   echo "Utility Version on $i"
   ssh $i "cat /app_2/filestore/util/rails/current/REVISION"
 done

 pause
}

deploy_gems(){

 for i in $BENEFITS_SERVERS
  do
   echo "Copying Benefits Gems to $i"
   scp -p /app_2/filestore/benefitkey/rails/shared/bundle.tar.gz "$i":/app_2/filestore/benefitkey/rails/shared/
   ssh $i "cd /app_2/filestore/benefitkey/rails/shared; tar zxvf bundle.tar.gz"
 done

 for i in $BROKER_SERVERS
  do
   echo "Copying Broker Gems to $i"
   scp -p /app_2/filestore/broker/rails/shared/broker_bundle.tar.gz "$i":/app_2/filestore/broker/rails/shared/
   ssh $i "cd /app_2/filestore/broker/rails/shared; tar zxvf broker_bundle.tar.gz"
 done

 for i in $ADMIN_SERVERS
  do
   echo "Copying Admin Gems to $i"
   scp -p /app_2/filestore/admin/rails/shared/admin_bundle.tar.gz "$i":/app_2/filestore/admin/rails/shared/
   ssh $i "cd /app_2/filestore/admin/rails/shared; tar zxvf admin_bundle.tar.gz"
 done

 for i in $UTILITY_SERVERS
  do
   echo "Copying Utility Gems to $i"
   scp -p /app_2/filestore/util/rails/shared/util_bundle.tar.gz "$i":/app_2/filestore/util/rails/shared/
   ssh $i "cd /app_2/filestore/util/rails/shared; tar zxvf util_bundle.tar.gz"
 done

 pause
}

 
select_servers(){
server_selection=$(whiptail --title "Select servers to $action" --checklist --separate-output \
  "Select servers to be restarted:" 22 76 16 \
  "${SERVER_MENU[@]}" \
  3>&1 1>&2 2>&3)
}

send_command(){

 command=$1
 component=$2
 wait_counter=0
 last_result=1

 if [ $component == 'apache' ]; then
  grep_command="[a]pache"
 elif [ $component == 'haproxy' ]; then
  grep_command="[h]aproxy.cfg"
 elif [ $component == 'proxy' ]; then
  grep_command="[o]din_proxy.rb"
 elif [ $component == 'redis' ]; then
  grep_command="[r]edis-server"
 elif [ $component == 'memcached' ]; then
  grep_command="[m]emcached -d"
 else
  echo "Error: unrecognized component $component passed to send_command"
 fi

 if [ $command == 'start' ]
  then
   running=1
 elif [ $command == 'stop' ]
  then
   running=0
 else
  echo "Error: variable action not defined"
 fi

 for i in $servers
  do
   echo "$1ing ${SERVICE_KEY[$app]} on $i"
   ssh $i $component'_'$command &
   update_cron $component $command $i
 done

 for j in $servers
  do
   while [ $last_result -ne $running ]
    do
     sleep 1
     ((wait_counter++))
     last_result=$(ssh "$j" ps -fu plnsc | grep $grep_command -c)
     if [ $last_result -gt 1 ]; then
      last_result=1
     fi
     echo "Waiting for ${SERVICE_KEY[$app]} to $command on all servers..."
     if [ "$wait_counter" -gt 120 ]; then
      echo "Could not $command ${SERVICE_KEY[$app]}."
      exit 1
      break
     fi
    done
   done
 pause
}

update_cron(){
 if [ "$1" == "apache" ] && [ "$2" == "start" ]; then
  ssh $3 "crontab -l | sed 's:#\*\/5 \* \* \* \* \/app_2\/scripts\/apache_watch.sh:\*\/5 \* \* \* \* \/app_2\/scripts\/apache_watch.sh:' | crontab -"
 elif [ "$1" == "apache" ] && [ "$2" == "stop" ]; then
  ssh $3 "crontab -l | sed 's:^\*\/5 \* \* \* \* \/app_2\/scripts\/apache_watch.sh:#\*\/5 \* \* \* \* \/app_2\/scripts\/apache_watch.sh:' | crontab -"
 elif [ "$1" == "haproxy" ] && [ "$2" == "start" ]; then
  ssh $3 "crontab -l | sed 's:#\*\/5 \* \* \* \* \/app_2\/scripts\/haproxy_watch.sh:\*\/5 \* \* \* \* \/app_2\/scripts\/haproxy_watch.sh:' | crontab -"
 elif [ "$1" == "haproxy" ] && [ "$2" == "stop" ]; then
  ssh $3 "crontab -l | sed 's:^\*\/5 \* \* \* \* \/app_2\/scripts\/haproxy_watch.sh:#\*\/5 \* \* \* \* \/app_2\/scripts\/haproxy_watch.sh:' | crontab -"
 elif [ "$1" == "redis" ] && [ "$2" == "start" ]; then
  ssh $3 "crontab -l | sed 's:#\*\/5 \* \* \* \* \/app_2\/scripts\/redis_watch.sh:\*\/5 \* \* \* \* \/app_2\/scripts\/redis_watch.sh:' | crontab -"
 elif [ "$1" == "redis" ] && [ "$2" == "stop" ]; then
  ssh $3 "crontab -l | sed 's:^\*\/5 \* \* \* \* \/app_2\/scripts\/redis_watch.sh:#\*\/5 \* \* \* \* \/app_2\/scripts\/redis_watch.sh:' | crontab -"
 elif [ "$1" == "memcached" ] && [ "$2" == "start" ]; then
  ssh $3 "crontab -l | sed 's:#\*\/5 \* \* \* \* \/app_2\/scripts\/memcached_watch.sh:\*\/5 \* \* \* \* \/app_2\/scripts\/memcached_watch.sh:' | crontab -"
 elif [ "$1" == "memcached" ] && [ "$2" == "stop" ]; then
  ssh $3 "crontab -l | sed 's:^\*\/5 \* \* \* \* \/app_2\/scripts\/memcached_watch.sh:#\*\/5 \* \* \* \* \/app_2\/scripts\/memcached_watch.sh:' | crontab -"
 elif [ "$1" == "util" ] && [ "$2" == "start" ]; then
  ssh $3 "crontab -l | sed 's:#\*\/5 \* \* \* \* \/app_2\/scripts\/proxy2_watch.sh:\*\/5 \* \* \* \* \/app_2\/scripts\/proxy2_watch.sh:' | crontab -"
 elif [ "$1" == "util" ] && [ "$2" == "stop" ]; then
  ssh $3 "crontab -l | sed 's:^\*\/5 \* \* \* \* \/app_2\/scripts\/proxy2_watch.sh:#\*\/5 \* \* \* \* \/app_2\/scripts\/proxy2_watch.sh:' | crontab -"
 fi
} 

# function to display menus
main_menu(){

 choice=$(whiptail --title "Select Plansource operation" --menu "Select Plansource Operation" 22 76 16 \
  "1" "Migration Menu" \
  "2" "Stop/Start/Restart Services" \
  "3" "Diagnostics" \
  "4" "Quit" \
  3>&1 1>&2 2>&3)
}

services_menu(){
 action=$(whiptail --title "Select Plansource operation" --menu "Select Plansource Operation" 22 76 16 \
  "stop" "" \
  "start" "" \
  "restart" "" \
  3>&1 1>&2 2>&3)

 app=$(whiptail --title "Select Plansource operation" --menu "Select Plansource Operation" 22 76 16 \
  "1" "$action Benefits" \
  "2" "$action Admin" \
  "3" "$action Broker" \
  "4" "$action Utility" \
  "5" "$action Web Apache" \
  "6" "$action Web HAproxy" \
  "7" "$action Redis" \
  "8" "$action Memcached" \
  "9" "Select Servers to $action" \
  "10" "$action entire Plansource $ENV environment" \
  3>&1 1>&2 2>&3)

 if [ $app == 9 ]; then
  select_servers
 fi

 if [ $app != 0 ]; then
  whiptail --yesno "Do you really want to $action ${SERVICE_KEY[$app]}?" --yes-button "Continue" --no-button "Cancel" 10 60 
 fi

 confirm=$?

  if [ $action == 'restart' ]
   then
    send_servers stop
    send_servers start
  else
   send_servers $action
  fi
}

send_servers(){
 if [ $confirm -eq 0 ]
 then
   case $app in
    1) servers=$BENEFITS_SERVERS; send_command $1 apache ;;
    2) servers=$ADMIN_SERVERS; send_command $1 apache ;;
    3) servers=$BROKER_SERVERS; send_command $1 apache ;;
    4) servers=$UTILITY_SERVERS; send_command $1 apache ;;
    5) servers=$WEB_SERVERS; send_command $1 apache ;;
    6) servers=$WEB_SERVERS; send_command $1 haproxy ;;
    7) servers=$REDIS_SERVERS; send_command $1 redis;;
    8) servers=$MEMCACHED_SERVERS; send_command $1 memcached;;
    9) servers=$server_selection; send_command $1 apache
       for i in $WEB_SERVERS
        do
        if [[ ${servers[*]} =~ $i ]]; then
         servers=("$i"); send_command $1 haproxy; servers=$server_selection
        fi
       done
       for i in $REDIS_SERVERS
        do
        if [[ ${servers[*]} =~ $i ]]; then
         servers=("$i"); send_command $1 redis; servers=$server_selection
        fi
       done 
       for i in $MEMCACHED_SERVERS
        do
        if [[ ${servers[*]} =~ $i ]]; then
         servers=("$i"); send_command $1 memcached; servers=$server_selection
        fi
       done;;

    10) servers=$BENEFITS_SERVERS' '$ADMIN_SERVERS' '$BROKER_SERVERS' '$UTILITY_SERVERS' '$WEB_SERVERS
       send_command $1 apache
       servers=$WEB_SERVERS
       send_command $1 haproxy
       servers=$REDIS_SERVERS
       send_command $1 redis
       servers=$MEMCACHED_SERVERS
       send_command $1 memcached;;
   esac
 else
  echo "Cancelling..."
 fi

}

migration_menu(){
 mig=$(whiptail --title "Select Migration Type" --menu "Select Migration Type" 22 76 16 \
  "1" "Deploy all code" \
  "2" "Deploy Benefits/Utility code" \
  "3" "Deploy Broker code" \
  "4" "Deploy Admin code" \
  "5" "$UI_TEXT" \
  "6" "Deploy Gems (Make sure they are in bundles on deploy server)" \
  3>&1 1>&2 2>&3)

 case $mig in
  1) deploy_app='all'; migrate_app ;;
  2) deploy_app='benefits'; migrate_app ;;
  3) deploy_app='broker'; migrate_app ;;
  4) deploy_app='admin'; migrate_app ;;
  5) migrate_ui ;;
  6) deploy_gems ;;
 esac

}

diagnostics_menu(){
  diag=$(whiptail --title "Select Diagnostic Operation" --menu "Select Diagnostic Operation" 22 76 16 \
  "1" "CPU/Memory Usage" \
  "2" "Filesystem Usage" \
  "3" "Passenger Usage" \
  "4" "Check Plansource Versions" \
  3>&1 1>&2 2>&3)

 case $diag in
  1) sh /app_2/scripts/diagnostics/resource_monitor.sh; pause ;;
  2) sh /app_2/scripts/diagnostics/daily_disk.sh; pause ;;
  3) sh /app_2/scripts/diagnostics/pstatus_all.sh; pause ;;
  4) version_check;;
 esac

}

read_options(){
 case $choice in
  1) migration_menu ;;
  2) services_menu ;;
  3) diagnostics_menu ;;
  4) exit 0;;
  *) echo -e "${RED}Error...${STD}" && sleep 2
 esac
}
 
# Main logic - infinite loop
while true
 do
  main_menu
  read_options
 done
