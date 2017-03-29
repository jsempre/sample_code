#!/bin/bash

DT=`date +%m%d%y`
LOG_DIR=/app_2/scripts/logs
LOG=${LOG_DIR}/apache_watch_${DT}.log
ALERT_FILE=${LOG_DIR}/alert_sent.txt
MAIL_LIST="jordan_sempre@optum.com"

printf "`date`: Running apache watch on `hostname`\n" >> ${LOG}
APACHE_STATUS=`ps -fu plnsc | grep -c "[P]assengerWatchdog"`

if [ $APACHE_STATUS -eq 0 ]
  then
    if [ -f ${ALERT_FILE} ]
      then
        printf "`date`: Apache is down, alert has previously been sent\n" >> ${LOG}
        printf "===================================\n" >> ${LOG}
        exit 1
      else
        printf "`date`: Apache is down, attempting to restart\n" >> ${LOG}
        sh /app_2/apache/bin/apachectl start >> ${LOG} 2>&1
        sleep 10
        APACHE_STATUS=`ps -fu plnsc | grep -c "[P]assengerWatchdog"`
        if [ $APACHE_STATUS -eq 0 ]
          then
            printf "`date`: Could not start apache, sending alert\n" >> ${LOG}
            mailx -s "ERROR: Plansource Apache DOWN on `hostname`" ${MAIL_LIST} < /dev/null
            touch ${ALERT_FILE}
          else
            printf "`date`: Successfully restarted apache\n" >> ${LOG}
            mailx -s "NOTICE: Plansource Apache was restarted on `hostname`" ${MAIL_LIST} < /dev/null
          fi
        printf "===================================\n" >> ${LOG}
      fi
  else
    printf "`date`: Apache is up and running\n" >> ${LOG}
    if [ -f ${ALERT_FILE} ]
      then
        printf "`date`: Apache has been started since last monitoring, sending all clear\n" >> ${LOG}
        mailx -s "CLEAR: Plansource Apache on `hostname` was restarted" ${MAIL_LIST} < /dev/null
        rm ${ALERT_FILE}
      fi
    printf "===================================\n" >> ${LOG}
  fi


