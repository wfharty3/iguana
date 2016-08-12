-- This short script maps specific patient data to an external SQLite database.
-- See http://help.interfaceware.com/v6/hl7-to-database
-- The same APIs can be used to write to other common database types like
-- MySQL, Microsoft SQL Server, Oracle, Maria DB etc. etc.
-- PLEASE READ THE TODO statement on line 38 and follow it.


-- This is the main entry point in the translator, Data contains the HL7 message from sample data
function main(Data)
   -- By default the SQLite database is stored in iguana.workingDir()
   DB = db.connect{api=db.ORACLE_OCI, name= 'localdb' , user='TDRUN', password='Smrt600' }

   -- Parse incoming raw message with hl7.parse
   local MsgIn = hl7.parse{vmd='demo.vmd', data=Data}

   -- clone message into out variable
   local MsgOut = hl7.message{vmd='demo.vmd', name='ADT'}
   MsgOut:mapTree(MsgIn)   
   
   -- transform message here
   
   -- write to database using stored procedure
   local PatId = MsgOut.PID[3][1][1]:S()
   local VisitNum = MsgOut.PID[18][1]:S()
   local MsgOutStr = MsgOut:S()
   local SQL = "CALL td_iguana_pkg.insert_iguana_queue('ADT',".. DB:quote(MsgOutStr)..","..DB:quote(PatId)..","..DB:quote(VisitNum)..")"
   trace(SQL)
   DB:execute(SQL)
   
   DB:close()
   
end

