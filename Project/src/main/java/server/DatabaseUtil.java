package server;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection() {
		// TODO Auto-generated method stub

			try {
				String dbURL = "jdbc:mysql://localhost:3306/brand";
				String dbID = "root";
				String dbPassword = "faith1918!";
				Class.forName("com.mysql.cj.jdbc.Driver");
				return DriverManager.getConnection(dbURL, dbID, dbPassword);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}
		
}
