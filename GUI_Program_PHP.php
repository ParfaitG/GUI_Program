<?php

function dbData($sql, $param) {
    $cbolist = []; 
    try{        
        $conn = new PDO("sqlite:D:/Freelance Work/Sandbox/GUI_PROGRAM/DATA/vehicles.db");        
        
        $STH = $conn->prepare($sql);
        $STH->bindParam(1, $param, PDO::PARAM_STR, 100);
        $STH->execute();
        
        while($row = $STH->fetch()) {
            $cbolist[] = $row[0];  
        }
        
    }
    catch(PDOException $e) {  
        echo $e->getMessage();  
    }

    $conn = null;
    unset($conn);
    
    return($cbolist);
}

class mainWindow extends GtkWindow {    
    
    function __construct($makelist, $parent = null) {
        parent::__construct();
        
        $num = 0;
        
        //$window = new GtkWindow();
        $this->set_title('Reports Menu');
        $this->connect_simple('destroy', array( 'Gtk', 'main_quit'));
        $this->set_size_request(375,350);
        
        $tbl = new GtkTable(9, 2);
        //$tbl->set_homogeneous(True);
        $this->add($tbl);
        
        // IMAGE
        $img = GtkImage::new_from_file('IMG/CarIcon.png');
        $tbl->attach($img, 0, 1, 0, 1);
        
        $menulbl = new GtkLabel('Vehicles Report Menu');
        $menulbl->modify_font(new PangoFontDescription('Arial 14'));
        $tbl->attach($menulbl, 1, 2, 0, 1);
        
        // MAKE
        $makelbl = new GtkLabel('Make');
        $makelbl->modify_font(new PangoFontDescription('Arial 10'));
        $makealign = new GtkAlignment(0.25, 0.5, 0, 0);
        $makealign->add($makelbl);
        $tbl->attach($makealign, 0, 1, 1, 2);
        
        $makecbo = GtkComboBox::new_text();        
        foreach ($makelist as $item){
            $makecbo->append_text($item);
        }        
        $tbl->attach($makecbo, 1, 2, 1, 2);
        
                
        // MODEL
        $modellbl = new GtkLabel('Model');
        $modellbl->modify_font(new PangoFontDescription('Arial 10'));
        $modelalign = new GtkAlignment(0.25, 0.5, 0, 0);
        $modelalign->add($modellbl);
        $tbl->attach($modelalign, 0, 1, 2, 3);
        
        $modelcbo = GtkComboBox::new_text();       
        $tbl->attach($modelcbo, 1, 2, 2, 3);
        
                
        // YEAR START
        $yearStartlbl = new GtkLabel('Year Start');
        $yearStartlbl->modify_font(new PangoFontDescription('Arial 10'));
        $yearStartalign = new GtkAlignment(0.35, 0.5, 0, 0);
        $yearStartalign->add($yearStartlbl);
        $tbl->attach($yearStartalign, 0, 1, 3, 4);
        
        $yearStarttxt = new GtkEntry();        
        $yearStarttxt->set_max_length(4);
        $tbl->attach($yearStarttxt, 1, 2, 3, 4);
        
        
        // YEAR END
        $yearEndlbl = new GtkLabel('Year End');
        $yearEndlbl->modify_font(new PangoFontDescription('Arial 10'));
        $yearEndalign = new GtkAlignment(0.3, 0.5, 0, 0);
        $yearEndalign->add($yearEndlbl);
        $tbl->attach($yearEndalign, 0, 1, 4, 5);
        
        $yearEndtxt = new GtkEntry();
        $yearEndtxt->set_max_length(4);
        $tbl->attach($yearEndtxt, 1, 2, 4, 5);
        
        
        // ENGINE
        $englbl = new GtkLabel('Engine');
        $englbl->modify_font(new PangoFontDescription('Arial 10'));
        $engalign = new GtkAlignment(0.25, 0.5, 0, 0);
        $engalign->add($englbl);
        $tbl->attach($engalign, 0, 1, 5, 6);
        
        $engcbo = GtkComboBox::new_text();
        $tbl->attach($engcbo, 1, 2, 5, 6);
        
        
        // TRANSMISSION
        $translbl = new GtkLabel('Transmission');
        $translbl->modify_font(new PangoFontDescription('Arial 10'));
        $transalign = new GtkAlignment(0.7, 0.5, 0, 0);
        $transalign->add($translbl);
        $tbl->attach($transalign, 0, 1, 6, 7);
        
        $transcbo = GtkComboBox::new_text();
        $tbl->attach($transcbo, 1, 2, 6, 7);
        
        
        // FUEL TYPE
        $fuellbl = new GtkLabel('Fuel Type');
        $fuellbl->modify_font(new PangoFontDescription('Arial 10'));
        $fuelalign = new GtkAlignment(0.35, 0.5, 0, 0);
        $fuelalign->add($fuellbl);
        $tbl->attach($fuelalign, 0, 1, 7, 8);
        
        $fuelcbo = GtkComboBox::new_text();        
        $tbl->attach($fuelcbo, 1, 2, 7, 8);
        
        // BUTTON OUTPUT
        $btnOutput = new GtkButton('Output Report');
        $tbl->attach($btnOutput, 1, 2, 8, 9);
        
        //$makecbo->connect('changed', array($this, 'on_selection_changed'));
        $makecbo->connect('changed', array($this, 'on_selection_changed'), $modelcbo, $engcbo, $transcbo, $fuelcbo);
        $btnOutput->connect('clicked', array($this, 'signal_clicked'), $makecbo, $modelcbo, $yearStarttxt, $yearEndtxt, $engcbo, $transcbo, $fuelcbo);
       
        $this->show_all();
    }
             
    function on_selection_changed($makecbo, $modelcbo, $engcbo, $transcbo, $fuelcbo) {
        //echo "make combo checked\n";               
        $model = $makecbo->get_model();
        $selection = $model->get_value($makecbo->get_active_iter(), 0);
        //echo $selection."\n";
                
        // MODEL CBO 
        for($i=0; $i < 1000; $i++){            
           $modelcbo->remove_text(0);
        }        
        $modellist = dbData("SELECT DISTINCT [Model] FROM vehicles WHERE [Make] = ? ORDER BY [Model]", $selection);
        $num = count($modellist);
        foreach ($modellist as $item){
            $modelcbo->append_text($item);
        }
        
        // ENGINE CBO 
        for($i=0; $i < 1000; $i++){            
           $engcbo->remove_text(0);
        }        
        $englist = dbData("SELECT DISTINCT [engId] FROM vehicles WHERE [Make] = ? ORDER BY [engId]", $selection);
        $num = count($englist);
        foreach ($englist as $item){
            $engcbo->append_text($item);
        }        
        
        // TRANSMISSION CBO 
        for($i=0; $i < 1000; $i++){            
           $transcbo->remove_text(0);
        }        
        $translist = dbData("SELECT DISTINCT [trany] FROM vehicles WHERE [Make] = ? ORDER BY [trany]", $selection);
        $num = count($translist);
        foreach ($translist as $item){
            $transcbo->append_text($item);
        }

        // FUEL TYPE CBO 
        for($i=0; $i < 1000; $i++){            
           $fuelcbo->remove_text(0);
        }        
        $fuellist = dbData("SELECT DISTINCT [fueltype] FROM vehicles WHERE [Make] = ? ORDER BY [fueltype]", $selection);
        $num = count($fuellist);
        foreach ($fuellist as $item){
            $fuelcbo->append_text($item);
        }     
    }
    
    function signal_clicked($btnOutput, $makecbo, $modelcbo, $yearStarttxt, $yearEndtxt, $engcbo, $transcbo, $fuelcbo){
        $cd = dirname(__FILE__);        
        
        $strFilter = "1 = 1";
        $params = [];
                
        // MAKE FILTER
        $model = $makecbo->get_model();
        if ($makecbo->get_active_iter() != null){
            $makeselection = $model->get_value($makecbo->get_active_iter(), 0);        
            if ($makeselection != "") {
                $strFilter = $strFilter ." AND [make] = ?";
                $params[] = $makeselection;
            }
        }

        // MODEL FILTER
        $model = $modelcbo->get_model();
        if ($modelcbo->get_active_iter() != null){
            $modelselection = $model->get_value($modelcbo->get_active_iter(), 0);        
            if ($modelselection != "") {
                $strFilter = $strFilter ." AND [model] = ?";
                $params[] = $modelselection;
            }
        }
        
        // ENGINE FILTER
        $model = $engcbo->get_model();        
        if ($engcbo->get_active_iter() != null){
            $engselection = $model->get_value($engcbo->get_active_iter(), 0);        
            if ($engselection != "") {
                $strFilter = $strFilter ." AND [engId] = ?";
                $params[] = $engselection;
            }
        }
        
        // YEAR RANGE FILTER
        if($yearStarttxt->get_text() != "" AND $yearEndtxt->get_text() != "") {
            $strFilter = $strFilter ." AND [year] BETWEEN ? AND ?";
            $params[] = $yearStarttxt->get_text();
            $params[] = $yearEndtxt->get_text();
            
        }
        
        // TRANSMISSION FILTER    
        $model = $transcbo->get_model();
        if ($transcbo->get_active_iter() != null){
            $transselection = $model->get_value($transcbo->get_active_iter(), 0);        
            if ($transselection != "") {
                $strFilter = $strFilter ." AND [trany] = ?";
                $params[] = $transselection;
            }
        }
         
        // FUEL FILTER
        $model = $fuelcbo->get_model();
        if ($fuelcbo->get_active_iter() != null){
            $fuelselection = $model->get_value($fuelcbo->get_active_iter(), 0);        
            if ($fuelselection != "") {
                $strFilter = $strFilter ." AND [fueltype] = ?";
                $params[] = $fuelselection;
            }
        }
        
        try {
            $conn = new PDO("sqlite:D:/Freelance Work/Sandbox/GUI_PROGRAM/DATA/vehicles.db");
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            
            // PREPARE SQL STATEMENT
            $sql = "SELECT Vehicles.Make, Vehicles.Model, Vehicles.Year,"
                      ." Vehicles.EngId, Vehicles.Trany, Vehicles.FuelType,"
                      ." Avg(Vehicles.barrels08) AS BarrelsAvg, Avg(Vehicles.city08) AS CityMPGAvg, "
                      ." Avg(Vehicles.comb08) AS CombinedMPGAvg, Avg(Vehicles.highway08) AS HighwayMPGAvg, "
                      ." Avg(Vehicles.fuelCost08) AS FuelCostAvg"
                      ." FROM Vehicles"
                      ." WHERE ". $strFilter
                      ." GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year,"
                      ."          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;";
            
            $STH = $conn->prepare($sql);
            
            // BIND PARAMETERS
            for($i=0; $i < count($params); $i++){
                $STH->bindParam($i+1, $params[$i], PDO::PARAM_STR, 100);
            }
            
            // RUN QUERY
            $STH->execute();
            
            
            // OUTPUT DATA TO CSV
            $STH->setFetchMode(PDO::FETCH_ASSOC);
            // COLUMN HEADERS
            $columns = [];
            for ($i = 0; $i < $STH->columnCount(); $i++) {
                $col = $STH->getColumnMeta($i);
                $columns[] = $col['name'];
            }
            
            $fs = fopen($cd.'/DATA/GUIData_PHP.csv', 'w');
            fputcsv($fs, $columns);
            fclose($fs);
            
            // DATA ROWS            
            while($row = $STH->fetch()) {
                $fs = fopen($cd.'/DATA/GUIData_PHP.csv', 'a');
                fputcsv($fs, $row);
                fclose($fs);
            }            
                
            $conn = null;
            unset($conn);
            
            // SUCCESS MESSAGE
            $dialogBox = new GtkDialog(
                            "SUCCESSFUL OUTPUT",
                            $this,
                            Gtk::DIALOG_MODAL,
                            array(
                                Gtk::STOCK_OK, Gtk::RESPONSE_OK    
                            )
                        );
                
            $dialogQues = new GtkLabel("\n   Successfully outputted query data to csv file!    \n");
            $prompt = $dialogBox->vbox;
            $prompt->add($dialogQues);
            
            $dialogBox->show_all();
            $msgresponse = $dialogBox->run();
            if($msgresponse == Gtk::RESPONSE_OK) {$dialogBox->destroy();}
        }
        
        catch(PDOException $e) {  
            echo $e->getMessage();
        }
        
    }
     
}

$makelist = dbData("SELECT DISTINCT [Make] FROM vehicles WHERE ? ORDER BY [Make]", "1");
new mainWindow($makelist);
Gtk::main();

?>