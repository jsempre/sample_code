#!/usr/bin/env python
import gdata.apps.service

service = gdata.apps.service.AppsService(email="jkoch01@test.hamline.edu", domain="test.hamline.edu", password="not_really_my_password")
service.ProgrammaticLogin()

username="testaccount"

currentUserAtt=service.RetrieveUser(username)

currentUserAtt.login.password = 'newpassword'
try:
    service.UpdateUser(username, currentUserAtt)
except Exception, e:
        # error handling
    pass
    
#Debug code/verification
print currentUserAtt.login.password
