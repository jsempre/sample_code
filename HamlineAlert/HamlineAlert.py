#Authored by Jordan Sempre
#3/14/11

#import RSS parsing support
import feedparser

#import time interpretation
import time

#import ability to make system calls
from subprocess import Popen

#initialize variable to check for new or modified alerts
currentAlert = " " 

#Always process RSS feed check
while 1:
    
    #Parse E2Campus Hamline RSS feed
    alert = feedparser.parse("http://rss.omnilert.net/2e887b4b72ad4b118d5752912562ab70")

    #Check for an alert different from a previously displayed one
    if(len(alert.entries) > 0 and currentAlert != alert.entries[0].description):
    
        #Display message text on remote computers using powershell (HamlineAlert.ps1) 
        Popen(["powershell.exe", "-noexit", "C:\HamlineAlert\HamlineAlert.ps1", "-alertBrand", '"' + alert.feed.title + '"', "-alertTitle", '"' + alert.entries[0].title + '"', "-alertDescription", '"' + alert.entries[0].description + '"'])

        #Once displayed, prevent from displaying again
        currentAlert = alert.entries[0].description

    #If there is no new message, keep processing
    else:
        pass

    #Wait 60 seconds before looping back
    time.sleep(60)
