Scripts I use to do more with my domotics setup. The content of this git goes into domoticz/scripts/lua.


Variable scripts receive this from Domoticz:
- otherdevices
- otherdevices_lastupdate
- otherdevices_svalues
- uservariables
- uservariables_lastupdate
- uservariablechanged

Time scripts this:
- otherdevices
- otherdevices_lastupdate
- otherdevices_svalues
- uservariables
- uservariables_lastupdate

Device scripts receive this:
- devicechanged['yourdevicename'] = state
- devicechanged['svalues'] = svalues string