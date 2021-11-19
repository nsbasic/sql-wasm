'This sample shows how to access SQLite from NS Basic/App Studio.
'It also shows how to copy an SQLite database into a JSON string for uploading.
'See Tech Note 15 for more information

Dim databaseSize  'number of records in the database
Dim DB            'the database itself
Dim startTime     'used for timer
Dim lastSQL       'the last SQL statement. Useful for debugging.
Dim total         'use to total sales from customers   
Dim DBRecords     'the last set of records selected from DB
Dim count         'the number of records counted
Dim DBjson        'JSON form of database

databaseSize=200

'***************** Button Handlers *********************
function btnCreate_onclick()
  total=0
  initDB
End function

function btnCount_onclick()
  'This function goes through all the rows in the database
  'and totals up the "sales" column. It's useful to see how quickly
  'each of the items on the database can be accessed.
  
  total=0
  startTime=SysInfo(10)
  if TypeName(DBRecords)="null" Then
    MsgBox "Database not created"
    Exit function
  End if
  
  for i=0 To DBRecords.rows.length-1
    total=total + DBRecords.rows.item(i)["sales"]
  Next
  txtMessage.value = "Total of " & DBRecords.rows.length & " recs is " & total & " in " & (SysInfo(10)-startTime) & " milliseconds."
End function

function btnRandom_onclick()
  'This function does random selections on the database - not sequential.
  'It does this by making an array with one entry for each selection,
  'then passing the entire array to be processed.
  'As each selection is completed,
  '  Random_Total is called to add the sales for the selected row.
  'When all the entries are completed,
  '  Random_Complete is called to give the total. 
  'This is useful to see how fast lots of small selections are.
  Dim sqlList
  startTime=SysInfo(10)
  total=0
  count=0
  sqlList = []
  
  for j=0 To databaseSize-1
    'Random_Total is called as each selection is completed.
    sqlList.push(["SELECT * FROM customerData WHERE name=?", "Customer" & Fix(Rnd * databaseSize), Random_Total])
  Next
  
  'Execute all the commands)
  Sql(DB, sqlList)
End function

function Random_Total(transaction, results)
  'called as random selections are completed.
  total=total + results.rows.item(0)["sales"]
  count=count+1
  if count=databaseSize Then
    txtMessage.value =  "Total of " & databaseSize & " random recs is " & total & " in " & (SysInfo(10)-startTime) & " milliseconds."
  End if
End function

function btnSQLExport_onclick()
  if typeof(DB)="undefined" Then
    MsgBox "Use the Create button to create a database"
  else
    NSB.ShowProgress("Exporting database...")
    DBjson=SQLExport(DB, "customer.db", exportComplete)
  End if
End function

function exportComplete()
  NSB.ShowProgress(False)
  txtMessage.value=JSON.stringify(DBjson)
End function

function btnSQLImport_onclick()
  if typeof(DBjson)="undefined" Then
    MsgBox "Use the SQLExport button to create a data to import"
  else
    SQLImport(DBjson, DB, importComplete)
  End if
End function

function importComplete(s)
  console.log("importComplete() called. " + s)
  'refresh the selection
  sqlList=Array(["SELECT * from customerData ORDER BY name;", dataHandler])
  Sql(DB, sqlList)
  txtMessage.value="Import completed."
End function

function btnClear_onclick()
  Dim sqlList
  sqlList=[]
  sqlList.push(["DROP TABLE customerData;",clearExec,clearError])
  Sql(DB, sqlList)
End function

function clearExec(transaction, result)
  DBRecords = undefined
  txtMessage.value="customer data cleared."
End function

function clearError
  MsgBox "error in clear statement"
End function

'***************** Functions to do the work *********************
function initDB()
  'This function creates the database if it does not exist already.
  'If it does exist, it clears out all the data
  'It then populates it with random data.
  Dim sqlList
  DB = SqlOpenDatabase("customer.db")
  startTime=SysInfo(10)
  
  sqlList=[]
  sqlList.push(["DROP TABLE customerData;",,skipError])
  Sql(DB, sqlList)
  
  sqlList=[]
  sqlList.push(["CREATE TABLE IF NOT EXISTS " & "customerData('name', 'address1', 'address2', 'age', 'sales', PRIMARY KEY('name') )"])
  
  'Add commands to the array to add rows to it.
  'Each row is a fresh array entry.
  for i = 0 To databaseSize-1
    Name    = "Customer" & i 
    Address1= i & " Winding River Lane"
    Address2= "Anytown USA " & 10000+i 
    Age     = CInt(Rnd * 100)
    Sales   = CInt(Rnd * 100000)
    args = [Name, Address1, Address2, Age, Sales]
    sqlList.push(["INSERT INTO customerData (name, address1, address2, age, sales) VALUES (?,?,?,?,?);", args])
  Next
  
  'Finally, put a command at the end to select all the rows.
  sqlList.push(["SELECT * from customerData ORDER BY name;", dataHandler])
  
  'Now, execute all the commands!
  Sql(DB, sqlList)
  
End function

function dataHandler(transaction, results)
  'Called On completion of Sql command
  DBRecords = results
  txtMessage.value =  "Recs created: " & DBRecords.rows.length & " in " & (SysInfo(10)-startTime) & " milliseconds."
End function

function skipError(transaction, results)
  'Called On failure of Sql command
End function

function btnDelete_onclick()
  Dim SQList
  SQList=[]
  'Note no success or fail callbacks!
  SQList.push(["DELETE FROM customerData"])
  SQList.push(["SELECT * from customerData ORDER BY name;", dataHandler])
  Sql(DB, SQList)
  txtMessage.value = "All rows deleted."
End function