
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DbConnect {
    Connection conn=null;
    public int i=0;
    public Connection getConnection()
    {
        try{
            Class.forName("com.mysql.jdbc.Driver");  
 conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root",""); 
   // System.out.println("Connected Successfully."+ i++);
        }catch (ClassNotFoundException | SQLException e)
        {
        }
        return conn;
}
}
