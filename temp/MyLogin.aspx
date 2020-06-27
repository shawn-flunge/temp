<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">


    protected void Button1_Click(object sender, EventArgs e)
    {
        //Connection 객체 생성
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString);
        //쿼리
        string sql = "Select id from userInfo where id=@id and pwd=@pwd";
        //command객체 생성후 매개변수로 쿼리문과 connection객체 전달
        SqlCommand cmd = new SqlCommand(sql, con);

        //connection객체 open
        con.Open();

        cmd.Parameters.AddWithValue("@id", txtId.Text);
        cmd.Parameters.AddWithValue("@pwd", txtPwd.Text);

        SqlDataReader rd = cmd.ExecuteReader();

        if (rd.Read())
        {
            Session["id"] = txtId.Text;
            rd.Close();
            con.Close();

            Response.Redirect("index.aspx");
        }
        else
        {
            this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "MessageBox", "alert('아이디 또는 비밀번호를 확인하세요')",true);
            rd.Close();
            con.Close();
        }
        

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
                <asp:Label ID="lblId" runat="server" Text="아이디" CssClass="labelCss"></asp:Label><br />
                <asp:TextBox ID="txtId" runat="server" CssClass="inputCss"></asp:TextBox><br />
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="<font color='red'>아아디를 입력하세요</font>" ControlToValidate="txtId" Display="Dynamic"></asp:RequiredFieldValidator>
            <div class="formDiv">
                <asp:Label ID="lblPwd" runat="server" Text="암호" CssClass="labelCss"></asp:Label>
                <asp:TextBox ID="txtPwd" runat="server" CssClass="inputCss" TextMode="Password"></asp:TextBox><br /> 
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="<font color='red'>비밀번호를 입력하세요</font>" ControlToValidate="txtPwd" Display="Dynamic"></asp:RequiredFieldValidator>
            <div class="formDiv">
                <a href="SignUp.aspx">회원가입</a>
            </div>
            <div>
                <asp:Button ID="Button1" runat="server" Text="로그인" CssClass="buttonCss" OnClick="Button1_Click"/><br />
            </div>

        </div>
        <input type="hidden" id="ok" />
    </form>
</div>
</body>
</html>
