<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<script runat="server">

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        Page.Header.DataBind();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        if(!Page.IsPostBack)
        {

            //세션이 없을 때 == 로그인 안된 상태
            if(Session["id"] == null)
            {

                navbardrop.HRef="MyLogin.aspx";
                navbardrop.InnerText = "Login";

                DropLog.InnerText = "Login";
                DropLog.HRef="MyLogin.aspx";
                DropUser.Visible = false;

            }
            else
            {
                navbardrop.InnerText=Session["id"].ToString();

                DropUser.Visible = true;
                DropUser.HRef = "UserInfo.aspx";

                DropLog.InnerText = "LogOut";
                DropLog.HRef = "Logout.aspx";

                

                setInfo();
            }




        }
    }

    public void setInfo()
    {
        SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=flunge; pwd=dksk1399 ");
        string sql = "select * from MyDB.dbo.userInfo where id='"+Session["id"].ToString()+"'";
        con.Open();

        SqlCommand cmd = new SqlCommand(sql, con);

        SqlDataReader rd = cmd.ExecuteReader();

        if (rd.Read())
        {
            lblId.Text = rd["id"].ToString();
            txtEmail.Text = rd["email"].ToString();
        }

        rd.Close();
        con.Close();

    }

</script>

<style>

   .body {
		
		background : linear-gradient(#214C63,#2D8634);
		background-repeat : no-repeat;
		background-size : cover;
        height:1000px
		}
	.jumbotron {
  		background-color: #214C63; 
  		color: #ffffff;
		}

	.bg-grey {
    		background-color: #f6f6f6;
  		}

 	.container-fluid {
    		padding: 60px 50px;
  		}


    .bg-4 { 
         background-color: #2f2f2f;
         color: #fff;
    }

    .footer{
        position:fixed;
        left:0px; 
        bottom:0px; 
        height: 50px;
        width:100%;
        margin-bottom:0px;
    }

    .abc{
        position:absolute;
        margin-left:15%;
        margin-top:7%;
    }

    table{
        width:70%;
        border:0
    }

    .login_wrapper{
        border : 20px solid lightblue;
        padding : 5px 20px;
        width:60%;
        height:80%;
        margin-left:20%;
        display:flex;
        flex-direction:column;
        justify-content:center;
        align-items:center;
    }

    h1{
        font-size:25px;
        padding-bottom:20px;
    }

    .formDiv{
        display:flex;
        justify-content:center;
        padding-bottom:7px;
        align-items:center;
        width:100%;
        border : 1px solid;
        border-color:blue;
    }

    .labelCss{
        flex:1;
        text-align:left;
        float:left;
        margin-left:10%
    }
    .buttonCss{
        width:85px;
        float:right;
        padding:3px;
    }
    .inputCss{
        padding:5px;
        float:right;
        margin-right:10%;
    }


</style>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>


    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <script type="text/javascript" src='<%= Page.ResolveUrl("js/jquery-3.3.1.min.js") %>' ></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/popper.min.js"></script>

</head>
<body class="body">

    <nav class="navbar navbar-expand-sm bg-info navbar-dark fixed-top">
        <a class="navbar-brand" href="index.aspx" runat="server" >Toword</a>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" runat="server" id="navbardrop" data-toggle="dropdown">
                        Dropdown link
                    </a>
                    <div class="dropdown-menu" >
                        <a class="dropdown-item" runat="server" id="DropLog">로그아웃</a>
                        <a class="dropdown-item" runat="server" id="DropUser">회원정보</a>
        
                    </div>
                </li>
            </ul>
    </nav>


    <form id="form1" runat="server">
        <div  style="position:relative;">

            <table class="abc">
                <tr >
                    <td colspan="2" style="height:400px; background-color:whitesmoke;">
                        <div  class="login_wrapper">
                            <div class="formDiv">
                                <h1>
                                    <asp:Label ID="lblId" runat="server" Text=""></asp:Label>
                                </h1>
                            </div>

                            <div class="formDiv">
                                <asp:Label ID="Label2" runat="server" Text="비밀번호 변경" CssClass="labelCss"></asp:Label>
                                <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="inputCss"></asp:TextBox>
                            </div>

                            <div class="formDiv">
                                <asp:Label ID="Label3" runat="server" Text="비밀번호 확인" CssClass="labelCss"></asp:Label>
                                <asp:TextBox ID="txtPwdCk" runat="server" TextMode="Password" CssClass="inputCss"></asp:TextBox>
                            </div>

                            <div class="formDiv">
                                <asp:Label ID="Label4" runat="server" Text="이메일" CssClass="labelCss"></asp:Label>
                                <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true" CssClass="inputCss"></asp:TextBox>
                            </div>
                        </div>
                    </td>

                </tr>
                <tr >
                    <td style="height:400px;background-color:yellowgreen">
                        dgsdgdg

                    </td>

                </tr>


            </table>


        </div>
    </form>


    <footer class="footer bg-4">
        <div class=" text-center py-3">© 2020 Copyright:
                <a href="https://github.com/shawn-flunge/"> 201607058 이시헌</a>
            </div>
    </footer>
</body>
</html>
