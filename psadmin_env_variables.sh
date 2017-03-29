ENV='stage'

SERVER_MENU=("apsrs1715" "Benefits" OFF \
  "apsrs1716" "Benefits" OFF \
  "apsrs1718" "Benefits" OFF \
  "apsrs1719" "Benefits" OFF \
  "apsrs1723" "Benefits" OFF \
  "apsrs1726" "Benefits" OFF \
  "apsrs1743" "Benefits" OFF \
  "apsrs1744" "Benefits" OFF \
  "apsrs1745" "Admin" OFF \
  "apsrs1757" "Broker" OFF \
  "apsrs1714" "Utility" OFF \
  "apsrs1720" "Utility" OFF \
  "apsrs1721" "Utility" OFF \
  "apsrs1722" "Utility" OFF \
  "apsrs1725" "Utility" OFF \
  "apsrs1727" "Utility" OFF \
  "apsrs1746" "Utility" OFF \
  "apsrs1747" "Utility" OFF \
  "apsrs1748" "Utility" OFF \
  "apsrs1749" "Utility" OFF \
  "apsrs1750" "Utility" OFF \
  "apsrs1751" "Utility" OFF \
  "apsrs1730" "Redis\Memcached" OFF \
  "webrs0313" "Web" OFF \
  "webrs0314" "Web" OFF \
  )

#For below lists, use only one set of quotes per variable and seperate server names by spaces.
ADMIN_SERVERS=("apsrs1745")

## Updated with full 20 benefits servers
#BENEFITS_SERVERS=("apsrs1714 apsrs1720 apsrs1721 apsrs1722 apsrs1725 apsrs1727 apsrs1746 apsrs1747 apsrs1748 apsrs1749 apsrs1750 apsrs1751")
#BENEFITS_SERVERS=("apsrs1715 apsrs1716 apsrs1718 apsrs1719 apsrs1723 apsrs1726 apsrs1743 apsrs1744")
BENEFITS_SERVERS=("apsrs1715 apsrs1716 apsrs1718 apsrs1719 apsrs1723 apsrs1726 apsrs1743 apsrs1744 apsrs1714 apsrs1720 apsrs1721 apsrs1722 apsrs1725 apsrs1727 apsrs1746 apsrs1747 apsrs1748 apsrs1749 apsrs1750 apsrs1751")

BROKER_SERVERS=("apsrs1757")

REDIS_SERVERS=("apsrs1730")

MEMCACHED_SERVERS=("apsrs1730")

#UTILITY_SERVERS=("apsrs1714 apsrs1720 apsrs1721 apsrs1722 apsrs1725 apsrs1727 apsrs1746 apsrs1747 apsrs1748 apsrs1749 apsrs1750 apsrs1751 apsrs1723 apsrs1726 apsrs1743 apsrs1744")
UTILITY_SERVERS=("apsrs1723 apsrs1726 apsrs1743 apsrs1744 apsrs1714 apsrs1720 apsrs1721 apsrs1722 apsrs1725 apsrs1727 apsrs1746 apsrs1747 apsrs1748 apsrs1749 apsrs1750 apsrs1751")

WEB_SERVERS=("webrs0313 webrs0314")

#For SERVICE_KEY list use quotes around each element seperated by space.
declare -a SERVICE_KEY=("Cancel" "Benefits" "Admin" "Broker" "Utility" "Web Apache" "Web HAproxy" "Redis" "Memcached" "Services" "Entire Environment")

CAPFILE='capfile-staging-optum'
CAPFILE_UTIL='capfile-staging-utility-optum'

UI_MIGRATION='/app_2/scripts/migration/deployUIcode.sh'
UI_TEXT='Migrate UI from test to stage environment'
