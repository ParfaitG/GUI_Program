library(RSQLite)
library(gWidgets2)
library(gWidgets2tcltk)

setwd("C:\\Path\\To\\Working\\Directory")

dbData <- function(strSQL, param){
  df <- dbGetPreparedQuery(conn, strSQL, bind.data=data.frame(p = param))
  datalist <- c('', df[[1]])
  return(datalist)
}

mainWindow <- function(makelist){
      win <- gWidgets2::gwindow("Reports Menu", height = 350, width = 300)
      
      tbl <- glayout(cont=win, spacing = 5)
      
      tbl[1,1] <- gimage(filename = "..\\IMG\\CarIcon.gif", 
                         dirname = getwd(), container = tbl)
      
      tbl[1,2] <- glabel("Vehicle Reports Menu", container = tbl)
      font(tbl[1,2]) <- list(size=14, family="Arial")
      
      # MAKE
      tbl[2,1] <- glabel("Make", container = tbl)
      tbl[2,2] <- makecbo <- gcombobox(makelist, selected = 1, editable = TRUE, container = tbl)
      font(tbl[2,1]) <- font(tbl[2,2]) <- list(size=10, family="Arial")
      
      # MODEL
      tbl[3,1] <- glabel("Model", container = tbl)
      tbl[3,2] <- modelcbo <-gcombobox(c("", "CE", "FE", "GE", "LE", "SE"), 
                                       selected = 1, editable = TRUE, container = tbl)
      font(tbl[3,1]) <- font(tbl[3,2]) <- list(size=10, family="Arial")
      
      # YEAR START
      tbl[4,1] <- glabel("Year Start", container = tbl)
      tbl[4,2] <- yearStartxt <- gedit(text="", height = 1, container=tbl)
      font(tbl[4,1]) <- font(tbl[4,2]) <- list(size=10, family="Arial")
      
      # YEAR END
      tbl[5,1] <- glabel("Year End", container = tbl)
      tbl[5,2] <- yearEndtxt <- gedit(text="", height = 1, container=tbl)
      font(tbl[5,1]) <- font(tbl[5,2]) <- list(size=10, family="Arial")
      
      # ENGINE
      tbl[6,1] <- glabel("Engine", container = tbl)
      tbl[6,2] <- engcbo <- gcombobox(c("", 1, 2, 3, 4, 5),
                          selected = 1, editable = TRUE, container = tbl)
      font(tbl[6,1]) <- font(tbl[6,2]) <- list(size=10, family="Arial")
      
      # TRANSMISSION
      tbl[7,1] <- glabel("Transmission", container = tbl)
      tbl[7,2] <- transcbo <- gcombobox(c("", "Automatic - 2 speed", "Automatic - 4 speed", 
                                          "Manual - 2 speed", "Manual - 4 speed"),
                            selected = 1, editable = TRUE, container = tbl)
      font(tbl[7,1]) <- font(tbl[7,2]) <- list(size=10, family="Arial")
      
      # FUEL TYPE
      tbl[8,1] <- glabel("Fuel Type", container = tbl)
      tbl[8,2] <- fuelcbo <- gcombobox(c("", "Regular", "Premium", "Diesel"),
                                       selected = 1, editable = TRUE, container = tbl)
      font(tbl[8,1]) <- font(tbl[8,2]) <- list(size=10, family="Arial")
      
      tbl[9,2] <- btnoutput <- gbutton("Output Report", container = tbl)
      font(tbl[9,2]) <- list(size=10, family="Arial")
      
      addHandlerChanged(makecbo, handler=function(...)  {
        modelcbo[] <- dbData(paste0("SELECT DISTINCT [Model] FROM vehicles",
                                    " WHERE [Make] = ?", 
                                    " ORDER BY [Model]"), svalue(makecbo))
        engcbo[] <- dbData(paste0("SELECT DISTINCT [engId] FROM vehicles",
                                  " WHERE [Make] = ?", 
                                  " ORDER BY [engId]"), svalue(makecbo))
        transcbo[] <- dbData(paste0("SELECT DISTINCT [trany] FROM vehicles",
                                    " WHERE [Make] = ?", 
                                    " ORDER BY [trany]"), svalue(makecbo))
        fuelcbo[] <- dbData(paste0("SELECT DISTINCT [fuelType] FROM vehicles",
                                   " WHERE [Make] = ?", 
                                   " ORDER BY [fuelType]"), svalue(makecbo))
      })
      
      addHandlerChanged(btnoutput, handler=function(...){
        strFilter <- "1 = 1"
        dfparams <-  data.frame(make = c(NA), model = c(NA), yearStart = c(NA), yearEnd = c(NA),
                                engine = c(NA), trans = c(NA), fuel = c(NA))
        
        if (length(svalue(makecbo)) > 0) {
          strFilter <- paste0(strFilter, " AND Make = ?")
          dfparams$make <- svalue(makecbo)
        } 
        
        if (length(svalue(modelcbo)) > 0) {
          strFilter <- paste0(strFilter, " AND Model = ?")
          dfparams$model <- svalue(modelcbo)
        } 
        
        if (svalue(yearStartxt) != "" & svalue(yearEndtxt) != "" ) {
          strFilter <- paste0(strFilter, " AND Year BETWEEN ? AND ?")
          dfparams$yearStart <- svalue(yearStartxt)
          dfparams$yearEnd <- svalue(yearEndtxt)
        } 
        
        if (length(svalue(engcbo)) > 0) {
          strFilter <- paste0(strFilter, " AND Engine = ?")
          dfparams$engine <- svalue(engcbo)
        }
        
        if (length(svalue(transcbo)) > 0) {
          strFilter <- paste0(strFilter, " AND trany = ?")
          dfparams$trans <- svalue(transcbo)
        }
        
        if (length(svalue(fuelcbo)) > 0) {
          strFilter <- paste0(strFilter, " AND fuelType = ?")
          dfparams$fuel <- svalue(fuelcbo)
        }
        
        strSQL <- paste0("SELECT Vehicles.Make, Vehicles.Model, Vehicles.Year,",
                        " Vehicles.EngId, Vehicles.Trany, Vehicles.FuelType,",
                        " Avg(Vehicles.barrels08) AS BarrelsAvg, Avg(Vehicles.city08) AS CityMPGAvg, ",
                        " Avg(Vehicles.comb08) AS CombinedMPGAvg, Avg(Vehicles.highway08) AS HighwayMPGAvg, ",
                        " Avg(Vehicles.fuelCost08) AS FuelCostAvg",
                        " FROM Vehicles",
                        " WHERE ", strFilter,
                        " GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year,",
                        "          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;")
        
        df <- dbGetPreparedQuery(conn, strSQL, bind.data=dfparams)
        write.csv(df, "GUIData_R.csv", row.names = FALSE)
        
        gmessage("Successfully exported query data to csv!", title = "SUCCESSFUL OUTPUT", icon = c("info"), parent = win)
      })
}

conn <- dbConnect(SQLite(), dbname = "Vehicles.db")
makelist <- dbData("SELECT DISTINCT [Make] FROM vehicles ORDER BY [Make];", NA)
mainWindow(makelist)

dbDisconnect(conn)
