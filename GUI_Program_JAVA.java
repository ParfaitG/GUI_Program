
import java.util.ArrayList;
import java.awt.*;  
import java.awt.event.*;
import javax.swing.*;

import java.sql.* ;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class GUI_Program extends Frame
      implements WindowListener {
      
   private static final long serialVersionUID = 7526472295622776147L;   
   
   public static Connection dbConn(String cd) {
      Connection conn = null;    
      try {
          Class.forName("org.sqlite.JDBC");
       } 
      catch (ClassNotFoundException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      }
      try {
          String database = cd + "/DATA/Vehicles.db"; 
          conn = DriverManager.getConnection("jdbc:sqlite:"+database);                             
      }
          
      catch ( SQLException err ) {            
          System.out.println(err.getMessage());            
      }      
      return(conn);
   }
   
   public static ArrayList<String> dbData(Connection conn, String strSQL, String param){
      ArrayList<String> dbList = new ArrayList<String>();      
      try {         
         PreparedStatement pstmt = conn.prepareStatement(strSQL);
         pstmt.setString(1, param);
         
         ResultSet rs = pstmt.executeQuery();
         dbList.add("");
         while(rs.next()) {
            dbList.add(rs.getString(1));           
         }
      }      
      catch ( SQLException err ) {            
          System.out.println(err.getMessage());            
      }      
      return(dbList);      
   }
   
   public static void dbClose(Connection conn){
      try {
          conn.close();                            
      }          
      catch ( SQLException err ) {            
          System.out.println(err.getMessage());            
      }      
   }
   
   public GUI_Program(Connection conn, String cd, ArrayList<String> makelist) {
      
      // SUPER FRAME SETTINGS
      setTitle("Report Menu");    
      setSize(375, 350);
      JPanel guipanel = new JPanel(new GridBagLayout());
      GridBagConstraints c = new GridBagConstraints();
      add(guipanel);
            
      Font ctrlFont = new Font("Arial", Font.PLAIN, 12);
      Font headFont = ctrlFont.deriveFont(18F);
            
      // IMAGE      
      ImageIcon image = new ImageIcon("IMG/CarIcon.png");
      JLabel imagelabel = new JLabel("", image, JLabel.LEFT);      
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 0;
      guipanel.add(imagelabel, c);

      JLabel imglbl = new JLabel("Vehicle Report Menu", SwingConstants.CENTER);      
      imglbl.setFont(headFont);      
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 1;
      c.gridy = 0;
      guipanel.add(imglbl, c);
      
      // MAKE
      JLabel makelbl = new JLabel("Make", SwingConstants.LEFT);
      makelbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 1;
      guipanel.add(makelbl, c);
      
      Choice makeChoice = new Choice();
      makeChoice.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 1;
      c.gridy = 1;
      guipanel.add(makeChoice, c);
      
      for (String i: makelist){
         makeChoice.add(i);
      }  
      
      // MODEL            
      JLabel modellbl= new JLabel("Model", SwingConstants.LEFT);
      modellbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 2;
      guipanel.add(modellbl, c);                            
      
      Choice modelChoice = new Choice();
      modelChoice.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 1;
      c.gridy = 2;
      guipanel.add(modelChoice, c);
            
      // YEAR START
      JLabel yearStartlbl = new JLabel("Year Start", SwingConstants.LEFT);
      yearStartlbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 3;
      guipanel.add(yearStartlbl, c);
      
      TextField yearStartTxt = new TextField(4);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 1;
      c.gridy = 3;
      guipanel.add(yearStartTxt, c);
      
      // YEAR END
      JLabel yearEndlbl = new JLabel("Year End", SwingConstants.LEFT);
      yearEndlbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 0;
      c.gridy = 4;
      guipanel.add(yearEndlbl, c);
      
      TextField yearEndTxt = new TextField(4);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 1;
      c.gridy = 4;
      guipanel.add(yearEndTxt, c);
      
      // ENGINE
      JLabel englbl = new JLabel("Engine", SwingConstants.LEFT);
      englbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 5;
      guipanel.add(englbl, c);
      
      Choice engChoice = new Choice();
      engChoice.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 1;
      c.gridy = 5;
      guipanel.add(engChoice, c);
            
      // TRANSMISSION
      JLabel translbl = new JLabel("Transmission", SwingConstants.LEFT);      
      translbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.insets = new Insets(0,0,0,10);
      c.gridx = 0;
      c.gridy = 6;
      guipanel.add(translbl, c);
      
      Choice transChoice = new Choice();
      transChoice.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.insets = new Insets(0,0,0,0);
      c.gridx = 1;
      c.gridy = 6;
      guipanel.add(transChoice, c);
 
      // FUEL TYPE            
      JLabel fuellbl = new JLabel("Fuel Type", SwingConstants.LEFT);
      fuellbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;      
      c.gridx = 0;
      c.gridy = 7;
      guipanel.add(fuellbl, c);
      
      Choice fuelChoice = new Choice();
      fuelChoice.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 1;
      c.gridy = 7;
      guipanel.add(fuelChoice, c);
      
      // BUTTON
      JLabel btnlbl = new JLabel("", SwingConstants.LEFT);
      btnlbl.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.gridx = 0;
      c.gridy = 8;      
      guipanel.add(btnlbl, c);
      
      Button btnOutput = new Button("Output Report");
      btnOutput.setFont(ctrlFont);
      c.fill = GridBagConstraints.HORIZONTAL;
      c.ipady = 0; 
      c.weighty = 0.05;
      c.insets = new Insets(0,0,10,0);
      c.gridx = 1;
      c.gridy = 8;         
      guipanel.add(btnOutput, c);
      
      // UPDATE COMBO BOX CHOICES
      makeChoice.addItemListener(new ItemListener(){        
         ArrayList<String> modellist = new ArrayList<String>();
         ArrayList<String> englist = new ArrayList<String>();
         ArrayList<String> translist = new ArrayList<String>();
         ArrayList<String> fuellist = new ArrayList<String>();
          
         public void itemStateChanged(ItemEvent ie){
            Connection conn = dbConn(cd);
                        
            modellist = dbData(conn, "SELECT DISTINCT [Model] FROM vehicles WHERE [Make] = ? ORDER BY [Model];", makeChoice.getSelectedItem().toString());
            modelChoice.removeAll();
            for (String i: modellist){
               modelChoice.add(i);
            }  
            
            englist = dbData(conn, "SELECT DISTINCT [engId] FROM vehicles WHERE [Make] = ? ORDER BY [engId];", makeChoice.getSelectedItem().toString());
            engChoice.removeAll();
            for (String i: englist){
               engChoice.add(i);
            }              
            
            translist = dbData(conn, "SELECT DISTINCT [trany] FROM vehicles WHERE [Make] = ? ORDER BY [trany];", makeChoice.getSelectedItem().toString());
            transChoice.removeAll();
            for (String i: translist){
               transChoice.add(i);
            }  
                        
            fuellist = dbData(conn, "SELECT DISTINCT [fuelType] FROM vehicles WHERE [Make] = ? ORDER BY [fuelType];", makeChoice.getSelectedItem().toString());
            fuelChoice.removeAll();
            for (String i: fuellist){
               fuelChoice.add(i);
            }  
                        
            dbClose(conn);
          }
      });
      
      // PROCESS AND OUTPUT REPORT
      btnOutput.addActionListener(new ActionListener(){        
         String strFilter;
                  
         public void actionPerformed(ActionEvent ae){
            
            ArrayList<String> params = new ArrayList<String>();
            Connection conn = dbConn(cd);
               
            strFilter = "1 = 1";
            
            if (!makeChoice.getSelectedItem().toString().equals("")){               
               strFilter = strFilter + " AND Make = ?";
               params.add(makeChoice.getSelectedItem().toString());
            }
            if (!modelChoice.getSelectedItem().toString().equals("")){               
               strFilter = strFilter + " AND Model = ? ";
               params.add(modelChoice.getSelectedItem().toString());
            }
            if ((!yearStartTxt.getText().equals("")) && (!yearEndTxt.getText().equals(""))){               
               strFilter = strFilter + " AND [Year] BETWEEN ? AND ?";
               params.add(yearStartTxt.getText());
               params.add(yearEndTxt.getText());
            }            
            if (!engChoice.getSelectedItem().toString().equals("")){               
               strFilter = strFilter + " AND engId = ?";
               params.add(engChoice.getSelectedItem().toString());
            }
            if (!transChoice.getSelectedItem().toString().equals("")){               
               strFilter = strFilter + " AND trany = ?";
               params.add(transChoice.getSelectedItem().toString());
            }
            if (!fuelChoice.getSelectedItem().toString().equals("")){               
               strFilter = strFilter + " AND fuelType = ?";
               params.add(fuelChoice.getSelectedItem().toString());
            }
            
            String strSQL = String.join("\n",
                        "SELECT Vehicles.Make, Vehicles.Model, Vehicles.Year,",
                        " Vehicles.EngId, Vehicles.Trany, Vehicles.FuelType,",
                        " Avg(Vehicles.barrels08) AS BarrelsAvg, Avg(Vehicles.city08) AS CityMPGAvg, ",
                        " Avg(Vehicles.comb08) AS CombinedMPGAvg, Avg(Vehicles.highway08) AS HighwayMPGAvg, ",
                        " Avg(Vehicles.fuelCost08) AS FuelCostAvg",
                        " FROM Vehicles",
                        " WHERE " + strFilter,
                        " GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year,",
                        "          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;");
            
            String COLUMN_HEADER = "Make,Model,Year,EngId,Trany,FuelType,BarrelsAvg,CityMPGAvg,CombinedMPGAvg,HighwayMPGAvg,FuelCostAvg";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";                 
               
            try {
               
               // CSV FILE
               FileWriter writer = new FileWriter("DATA\\GUIData_Java.csv");
               
               // COLUMN HEADERS
               writer.append(COLUMN_HEADER.toString());
               writer.append(NEW_LINE_SEPARATOR);               
               
               // RUN QUERY
               PreparedStatement pstmt = conn.prepareStatement(strSQL);               
               for(int i = 0; i < params.size(); i++){                  
                  pstmt.setString(i + 1, params.get(i).toString());
               }            
               ResultSet rs = pstmt.executeQuery();
         
               // DATA ROWS
               while(rs.next()) {
                  writer.append(rs.getString(1) + "," + rs.getString(2) + "," + rs.getString(3) + "," + rs.getString(4) + "," +
                                rs.getString(5) + "," + rs.getString(6) + "," + rs.getString(7) + "," + rs.getString(8) + "," +
                                rs.getString(9) + "," + rs.getString(10)  + "," + rs.getString(11));
                  writer.append(NEW_LINE_SEPARATOR);
               }
                               
               writer.flush();
               writer.close();
                              
               JOptionPane.showMessageDialog(null, "Successfully outputted query data to csv file!", "SUCCESS", JOptionPane.INFORMATION_MESSAGE);
                
            } catch ( SQLException err ) {            
                  System.out.println(err.getMessage());            
            } catch (IOException ioe) {
                System.err.println(ioe.getMessage());
            }
            
            dbClose(conn);
          }
      });

      addWindowListener(this);     
      setVisible(true);      
   }
   
   public static void main(String[] args) {
      
      ArrayList<String> makelist = new ArrayList<String>();
      String currentDir = new File("").getAbsolutePath();
      
      Connection conn = dbConn(currentDir);
      makelist = dbData(conn, "SELECT DISTINCT [Make] FROM vehicles WHERE ? ORDER BY [Make];", "1");
      dbClose(conn);
      new GUI_Program(conn, currentDir, makelist);
      
   }
   
   // WindowEvent handlers
   @Override
   public void windowClosing(WindowEvent evt) {
      // Terminate the program
      System.exit(0);                                                          
   }
   
   @Override public void windowOpened(WindowEvent evt) { }
   @Override public void windowClosed(WindowEvent evt) { }
   @Override public void windowIconified(WindowEvent evt) { }
   @Override public void windowDeiconified(WindowEvent evt) { }
   @Override public void windowActivated(WindowEvent evt) { }
   @Override public void windowDeactivated(WindowEvent evt) { }
}