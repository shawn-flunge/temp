<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

   
    bool IsAuthenticated(string userid, string password)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString);
        string sql = "select count(userid) from member where userid = @userid and password=@password";
        SqlCommand cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@userid", userid);
        cmd.Parameters.AddWithValue("@password", password);

        con.Open();
        int count = (int)cmd.ExecuteNonQuery();
        con.Close();

        return count >0;
    }

</script>
    
    
    

<style>
    .login_wrapper{
        border : 20px solid lightblue;
        padding : 5px 20px;
        position : absolute;
        top:50%;
        left:50%;
        width:450px;
        height : 250px;
        margin-top :-170px;
        margin-left:-220px;

        display:flex;
        flex-direction:column;
        justify-content:center;
        align-items:center;
    }

    h1{
        font-size:25px;
        padding-bottom:20px;
    }

    .form{
        width:300px;
    }

    .formDiv{
        display:flex;
        justify-content:center;
        padding-bottom:7px;
        align-items:center;
        
    }

    .labelCss{
        flex:1;
        text-align:left;
    }
    .buttonCss{
        width:85px;
        float:right;
        padding:3px;
    }
    .inputCss{
        padding:5px;
    }

</style>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<div class="login_wrapper">
    <h1>Welcome to Toword</h1>
    <form id="form1" runat="server" class="form">
        <div>

            <div class="formDiv">
            <asp:Label ID="Label2" runat="server" Text="아이디" CssClass="labelCss"></asp:Label><br />
                <asp:TextBox ID="TextBox1" runat="server" CssClass="inputCss"></asp:TextBox><br />
            </div>
            <div class="formDiv">
            <asp:Label ID="Label3" runat="server" Text="암호" CssClass="labelCss"></asp:Label>
                <asp:TextBox ID="TextBox2" runat="server" CssClass="inputCss" TextMode="Password"></asp:TextBox><br />
            </div>
            <div>
            <asp:Button ID="Button1" runat="server" Text="로그인" CssClass="buttonCss"/><br />
            </div>

        </div>
    </form>
</div>
</body>
</html>
