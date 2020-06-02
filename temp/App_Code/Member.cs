using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data.SqlClient;
using System.Data;
using System.Security.Cryptography.X509Certificates;

/// <summary>
/// Member의 요약 설명입니다.
/// </summary>
public class Member
{
    string _conString;
    public Member()
    {
        _conString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString;
    }

    public DataSet SelectMember()
    {
        SqlConnection con = new SqlConnection(_conString);

        string sql = "select userid, password, name, phone from member";
        SqlCommand cmd = new SqlCommand(sql,con);

        SqlDataAdapter ad = new SqlDataAdapter();
        ad.SelectCommand = cmd;

        DataSet ds = new DataSet();
        ad.Fill(ds);

        return ds;
    }

    public DataSet SelectMemberByUserID(string userID)
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
    public int InsertMember(string userID, string password, string name, string phone)
    {

        return 0;
    }
    public int Update(string userID, string password, string name, string phone)
    {
        return 0;
    }
    public int DeleteMember(string userID)
    {
        return 0;
    }

}