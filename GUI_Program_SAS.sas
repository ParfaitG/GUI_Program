
** ASSIGN CATALOG LIBRARY;
libname GUIprog "C:\Path\To\Working\Directory";

** CONNECT DATABASE;
libname vehicles odbc complete = "Driver={SQLite3 ODBC Driver}; Database=C:\Path\To\Working\Directory\DATA\Vehicles.db";

** LAUNCH FRAME;
proc display CATALOG=GUIprog.Catalog.Gui_program.frame;
run;

