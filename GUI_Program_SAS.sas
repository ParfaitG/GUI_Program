
** ASSIGN CATALOG LIBRARY;
libname GUIprog "D:\Freelance Work\Sandbox\GUI_PROGRAM";

** CONNECT DATABASE;
libname vehicles odbc complete = "Driver={SQLite3 ODBC Driver}; Database=D:\Freelance Work\Sandbox\GUI_PROGRAM\DATA\Vehicles.db";

** LAUNCH FRAME;
proc display CATALOG=GUIprog.Catalog.Gui_program.frame;
run;

