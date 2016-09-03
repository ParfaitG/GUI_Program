import os
import csv, sqlite3
from tkinter import *
from tkinter import ttk

cd = os.path.dirname(os.path.abspath(__file__))

conn = sqlite3.connect(os.path.join(cd, 'DATA\\Vehicles.db'))
cur = conn.cursor()

class GUIapp():
    
    def __init__(self):
        self.root = Tk()
        self.buildControls()
        self.root.mainloop()

    def DBdata(self, sql, param):
        cur.execute(sql, (param,))
        dbdata = [str(row[0]) for row in cur.fetchall()]
        return(dbdata)

    def updateCombos(self, event):        
        self.modellist = self.DBdata("SELECT DISTINCT [Model] FROM vehicles WHERE [Make] = ? ORDER BY [Model];", self.makecbo.get())    
        self.modelcbo['values'] = [''] + self.modellist
        self.modelcbo.current(0)

        self.englist = self.DBdata("SELECT DISTINCT [engId] FROM vehicles WHERE [Make] = ? ORDER BY [engId];", self.makecbo.get())
        self.engcbo['values'] = [''] + self.englist        
        self.engcbo.current(0)

        self.translist = self.DBdata("SELECT DISTINCT [trany] FROM vehicles WHERE [Make] = ? ORDER BY [trany];", self.makecbo.get())
        self.transcbo['values'] = [''] + self.translist        
        self.transcbo.current(0)

        self.fuellist = self.DBdata("SELECT DISTINCT [fuelType] FROM vehicles WHERE [Make] = ? ORDER BY [fuelType];", self.makecbo.get())
        self.fuelcbo['values'] = [''] + self.fuellist        
        self.fuelcbo.current(0)
        

    def buildControls(self):        
        self.root.wm_title("Report Menu")
        self.guiframe = Frame(self.root, width=800, height=500, bd=1, relief=FLAT)
        self.guiframe.pack(padx=5, pady=5)

        # IMAGE
        self.photo = PhotoImage(file="IMG/CarIcon.png")
        self.imglbl = Label(self.guiframe, image=self.photo)
        self.imglbl.photo = self.photo
        self.imglbl.grid(row=0, sticky=W, padx=5, pady=5)
        self.imglbl = Label(self.guiframe, text="Vehicle Reports Menu", font=("Arial", 14)).\
                            grid(row=0, column=1, sticky=W, padx=5, pady=5)

        # MAKE
        self.makelbl = Label(self.guiframe, text="Make", font=("Arial", 10)).grid(row=1, sticky=W, padx=5, pady=5)
        self.makevar = StringVar()
        self.makecbo = ttk.Combobox(self.guiframe, textvariable=self.makevar, font=("Arial", 10), state='readonly')        
        self.makelist = self.DBdata("SELECT DISTINCT [Make] FROM vehicles WHERE ? ORDER BY [Make];", 1)    
        self.makecbo['values'] = [''] + self.makelist            
        self.makecbo.current(0)
        self.makecbo.grid(row=1, column=1, sticky=W, padx=5, pady=5)
        self.makecbo.bind("<<ComboboxSelected>>", self.updateCombos)
        
        # MODEL
        self.modellbl = Label(self.guiframe, text="Model", font=("Arial", 10)).grid(row=2, sticky=W, padx=5, pady=5)
        self.modelvar = StringVar()
        self.modelcbo = ttk.Combobox(self.guiframe, textvariable=self.modelvar, font=("Arial", 10),state='readonly')        
        self.modelcbo.grid(row=2, column=1, sticky=W, padx=5, pady=5)

        # YEAR START
        self.yearStartlbl = Label(self.guiframe, text="Year Start", font=("Arial", 10)).grid(row=3, sticky=W, padx=5, pady=5)
        self.yearStartvar = IntVar()
        self.yearStarttxt = Entry(self.guiframe, textvariable=self.yearStartvar, relief=SOLID, font=("Arial", 10), width=23).\
                                  grid(row=3, column=1, sticky=W, padx=5, pady=5)
        
        # YEAR END
        self.yearEndlbl = Label(self.guiframe, text="Year End", font=("Arial", 10)).grid(row=4, sticky=W, padx=5, pady=5)
        self.yearEndvar = IntVar()
        self.yearEndtxt = Entry(self.guiframe, textvariable=self.yearEndvar, relief=SOLID, font=("Arial", 10), width=23).\
                                grid(row=4, column=1, sticky=W, padx=5, pady=5)

        # ENGINE
        self.englbl = Label(self.guiframe, text="Engine", font=("Arial", 10)).grid(row=5, sticky=W, padx=5, pady=5)
        self.engvar = IntVar()
        self.engcbo = ttk.Combobox(self.guiframe, textvariable=self.engvar, font=("Arial", 10))
        self.engcbo.grid(row=5, column=1, sticky=W, padx=5, pady=5)

        # TRANSMISSION
        self.translbl = Label(self.guiframe, text="Transmission", font=("Arial", 10)).grid(row=6, sticky=W, padx=5, pady=5)
        self.transvar = StringVar()
        self.transcbo = ttk.Combobox(self.guiframe, textvariable=self.transvar, font=("Arial", 10))
        self.transcbo.grid(row=6, column=1, sticky=W, padx=5, pady=5)


        # FUEL TYPE
        self.fuellbl = Label(self.guiframe, text="Fuel Type", font=("Arial", 10)).grid(row=7, sticky=W, padx=5, pady=5)
        self.fuelvar = StringVar()
        self.fuelcbo = ttk.Combobox(self.guiframe, textvariable=self.fuelvar, font=("Arial", 10))
        self.fuelcbo.grid(row=7, column=1, sticky=W, padx=5, pady=5)

        # OUTPUT REPORT BUTTON 
        self.btnoutput = Button(self.guiframe, text="Output Report", font=("Arial", 10), width=15, command=self.outputReport).\
                                grid(row=8, column=1, sticky=W, padx=10, pady=5)

    def outputReport(self):
        strFilter = "1=1"
        params = []

        if self.makecbo.get() != "":            
            strFilter = strFilter + " AND [Make] = ?"
            params.append(self.makecbo.get())
                        
        if self.modelcbo.get() != "":            
            strFilter = strFilter + " AND [Model] = ?"
            params.append(self.modelcbo.get())
        
        if self.yearEndvar.get() > 0 and self.yearEndvar.get() > 0:            
            strFilter = strFilter + " AND [YEAR] BETWEEN ? and ?"
            params.append(self.yearStartvar.get())
            params.append(self.yearEndvar.get())

        if self.engcbo.get() != "":            
            strFilter = strFilter + " AND [engId] = ?"
            params.append(self.engcbo.get())
    
        if self.transcbo.get() != "":            
            strFilter = strFilter + " AND [trany] = ?"
            params.append(self.transcbo.get())
            
        if self.fuelcbo.get() != "":            
            strFilter = strFilter + " AND [fuelType] = ?"
            params.append(self.fuelcbo.get())
        
        strSQL = "SELECT Vehicles.Make, Vehicles.Model, Vehicles.Year," + \
                 " Vehicles.EngId, Vehicles.Trany, Vehicles.FuelType," + \
                 " Avg(Vehicles.barrels08) AS BarrelsAvg, Avg(Vehicles.city08) AS CityMPGAvg, " + \
                 " Avg(Vehicles.comb08) AS CombinedMPGAvg, Avg(Vehicles.highway08) AS HighwayMPGAvg, " + \
                 " Avg(Vehicles.fuelCost08) AS FuelCostAvg" + \
                 " FROM Vehicles" + \
                 " WHERE " + strFilter + \
                 " GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year," + \
                 "          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;"
        
        cur.execute(strSQL, params)

        tempcsv = os.path.join(cd, 'DATA', 'GUIData_PY.csv')
        with open(tempcsv, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow([i[0] for i in cur.description])
            for row in cur.fetchall():        
                writer.writerow(row)

        messagebox.showinfo("SUCCESFUL OUTPUT", "Successfully outputted query report to csv!")        
        

GUIapp()
cur.close()
conn.close()
