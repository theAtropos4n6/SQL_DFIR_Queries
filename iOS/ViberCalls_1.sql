/*Checked on iOS  14.2 and Viber 14.2.0.1
Locate Contacts.data which holds the information of Viber Application. 

The first time a call is initiated, an entry will populate ZVIBERMESSAGE table. 
But, if no message is exchanged and the same person initiate another call again,
then no entry will be created in the ZVIBERMESSAGE table. This information is stored
in the ZRECENT table instead. 

This query will extract all the calls that reside
in ZRECENT table, can be correlated with a user contact and have a corresponding entry
in ZVIBERMESSAGE table. 

As always, please validate manually the results of the query. It is not a forensic software.
Its only purpose is to save you some time. Enjoy!
*/
SELECT
datetime(ZRECENT.ZDATE+ 978307200,'unixepoch','localtime') AS 'Date of Event (Localtime)',
datetime(ZRECENT.ZDATE+ 978307200,'unixepoch') AS 'Date of Event (UTC+00:00)',
ZPHONENUMBER.ZCANONIZEDPHONENUM AS 'Phone Number',
ZMEMBER.ZDISPLAYFULLNAME AS 'Full Name',
ZRECENT.ZDURATION AS 'Duration (in Seconds)',
CASE
WHEN ZRECENT.ZCALLTYPE = 'missed' THEN 'Missed Phone Call'
WHEN ZRECENT.ZCALLTYPE = 'missed_with_video' THEN 'Missed Video Call'
WHEN ZRECENT.ZCALLTYPE = 'outgoing_viber_with_video' THEN 'Outgoing Video Call'
WHEN ZRECENT.ZCALLTYPE = 'incoming_with_video' THEN 'Incoming Video Call'
WHEN ZRECENT.ZCALLTYPE = 'incoming' THEN 'Incoming Phone Call'
WHEN ZRECENT.ZCALLTYPE = 'outgoing_viber' THEN 'Outgoing Phone Call'
end  AS 'Call Type',
CASE
WHEN ZVIBERMESSAGE.ZSTATE = 'received' THEN 'Incoming'
WHEN ZVIBERMESSAGE.ZSTATE = 'send' THEN 'Outgoing'
end  AS 'Call State'
FROM ZVIBERMESSAGE
JOIN ZRECENT ON ZVIBERMESSAGE.Z_PK = ZRECENT.ZCALLLOGMESSAGE
JOIN ZPHONENUMBER ON ZVIBERMESSAGE.ZPHONENUMINDEX = ZPHONENUMBER.ZMEMBER
JOIN ZMEMBER ON ZVIBERMESSAGE.ZPHONENUMINDEX = ZMEMBER.Z_PK
ORDER BY 'Date of Event (Localtime)'
