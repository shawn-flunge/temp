using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data.SqlClient;
using System.Data;

/// <summary>
/// user의 요약 설명입니다.
/// </summary>
public class user
{
    string _conString;
    public user()
    {
        _conString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString;
    }

    public DataSet SelectUser()
    {
        SqlConnection con = new SqlConnection(_conString);

        string sql = "select userid, password, name, phone from member";
        SqlCommand cmd = new SqlCommand(sql, con);

        SqlDataAdapter ad = new SqlDataAdapter();
        ad.SelectCommand = cmd;

        DataSet ds = new DataSet();
        ad.Fill(ds);

        return ds;
    }

    public int InsertUser(string userID, string password, string email)
    {
        SqlConnection con = new SqlConnection(_conString);

        string sql = "insert into user values(@userid, @password, @email)";
        SqlCommand cmd = new SqlCommand(sql, con);

        cmd.Parameters.AddWithValue("@userid", userID);
        cmd.Parameters.AddWithValue("@password", password);
        cmd.Parameters.AddWithValue("@name", email);

        con.Open();
        cmd.ExecuteNonQuery();

        con.Close();

        return 1;
    }
    public int UpdateUser(string userID, string password, string name, string phone)
    {
        return 0;
    }
    public int DeleteUser(string userID)
    {
        return 0;
    }


}