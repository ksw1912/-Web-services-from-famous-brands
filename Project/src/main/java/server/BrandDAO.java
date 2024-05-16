package server;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BrandDAO {
    Connection conn = DatabaseUtil.getConnection();

    public String getBrandAddress(String brandName) {
        String brandAddress = null;

        String SQL = "SELECT brand_address FROM brandTable WHERE brand_name = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, brandName);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                brandAddress = rs.getString("brand_address");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return brandAddress;
    }
}
