# sql-wasm
Proof of concept using sql-wasm with AppStudio.

This sample is a proof of concept showing how to use sql-wasm 
in an AppStudio project.

It uses Sql-js from https://github.com/Sql-js/Sql.js/

Download latest version here:
https://github.com/Sql-js/Sql.js/releases

The code within is taken from the Sql-js repo with minimal changes
so it runs as an AppStudio project.

The only output is to the console.

The sample does not currently persist the data.
It will get wiped out when you exit the sample.
You can save the data for next time by writing it to IndexedDB or localStorage.
The sample exports the database to a variable named `binaryArray`.
You can write that as a single record to IndexedDB,
then read it in again next time you run the sample.

Feel free to reuse the code for your own purposes.
If you would like to enhance it and share your work,
please do so. We'd love to update this.

### Prerequisite

You'll need to install [AppStudio](http://www.appstudio.dev). 
You can then open and run the project.

### Background - sql.js

sql.js is a javascript SQL database. 
It allows you to create a relational database and query it entirely in the browser. 
It uses a virtual database file stored in memory, 
and thus doesn't persist the changes made to the database. 
However, it allows you to import any existing sqlite file, 
and to export the created database as a JavaScript typed array.

sql.js uses emscripten to compile SQLite to [webassembly](https://en.wikipedia.org/wiki/WebAssembly)
(or to javascript code for compatibility with older browsers). 
It includes contributed math and string extension functions.

The libraries add about 1.1 megs to your project.
