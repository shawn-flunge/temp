<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">



    protected void btnCheck_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString);
        string sql = "select count(id) from userInfo where id=@id";

        con.Open();
        SqlCommand cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@id", txtId.Text);

        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.Read())
        {
            if (dr[0].ToString() != "1")
            {
                lblOk.Value = "o";
                lblCk.Text = "사용 가능합니다.";
            }
            else
            {
                lblOk.Value = "x";
                lblCk.Text = "사용 불가능합니다.";
            }

        }


        dr.Close();
        con.Close();

    }


    //protected void btnSubmit_Click(object sender, EventArgs e)
    //{
    //    String str = "opener.document.getElementById('lblConfirm').value = 'o';";

    //    if (lblOk. == "o")
    //    {
    //        this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "alert('sdfas');", str,true);
    //    }
    //    else
    //    {
    //        txtId.Text = "";
    //    }
    //}
</script>
<script type="text/javascript">

    function acceptId() {
        if (document.getElementById("lblOk").value == "o") {
            opener.document.getElementById("confirm").value = "o";
            opener.document.getElementById("userID").value = document.getElementById("txtId").value;
            window.close();
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
        height : 300px;
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
    <h1>중복확인</h1>
    <form id="form1" runat="server" class="form">
        <div>
            <div class="formDiv">
                <asp:TextBox ID="txtId" runat="server" TextMode="SingleLine" CssClass="inputCss"></asp:TextBox>
                <asp:Button ID="btnCheck" runat="server" Text="중복확인" CssClass="buttonCss" OnClick="btnCheck_Click"/>
                
            </div>
            <asp:RequiredFieldValidator ID="RequireFieldValidation1" runat="server" ErrorMessage="<font color='red'>아이디를 입력하세요</font>" 
                        ControlToValidate="txtId" Display="Dynamic"></asp:RequiredFieldValidator>
            <div class="formDiv">
                <asp:Label ID="lblCk" runat="server" Text="" CssClass="inputCss"></asp:Label>
            </div>
            <div class="formDiv">
                <asp:Button ID="btnSubmit" runat="server" Text="사용" CssClass="buttonCss" OnClientClick="acceptId()" />
            </div>
            <input type="hidden" runat="server" id="lblOk" value="x"/>
            
        </div>
    </form>
</div>
</body>
</html>
