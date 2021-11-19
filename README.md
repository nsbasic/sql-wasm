# sql-wasm
Proof of concept using sql-wasm with AppStudio

This sample is a proof of concept showing how to use sql-wasm 
in an AppStudio project.

It uses Sql-js from https://github.com/Sql-js/Sql.js/

Download latest version here:
https://github.com/Sql-js/Sql.js/releases

The code within is taken from the repo with minimal changes
so it runs as an AppStudio project.

The only output is to the console.

The sample does not currently persist the data.
It will get wiped out when you exit the sample.
You can save the data for next time by writing it to IndexedDB or localStorage.
The sample exports the database to a variable called binaryArray.
You can write that as a single record to IndexedDB,
then read it in again next time you run the sample.

Feel free to reuse the code for your own purposes.
If you would like to enhance it and share your work,
please do so. We'd love to update this.

### Prerequisite

You'll need to install [AppStudio](http://www.appstudio.dev). 
You can then open and run the project.