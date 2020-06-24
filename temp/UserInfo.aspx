<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net.Mail" %>

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

                //회원정보 세팅
                setInfo();
            }




        }
    }

    //회원정보창에 정보를 세팅
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

    //정보바꾸는 메소드
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=flunge; pwd=dksk1399");
        string sql = "update userInfo set pwd=@pwd where id=@id";
        con.Open();

        SqlCommand cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@pwd", txtPwd.Text);
        cmd.Parameters.AddWithValue("@id", Session["id"].ToString());

        cmd.ExecuteNonQuery();

        con.Close();
        this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "MessageBox", "alert('변경이 완료되었습니다.')",true);
    }


    //건의사항을 운영자에게 보냄, 메일인증할때의 smtp를이용
    protected void btnSend_Click(object sender, EventArgs e)
    {
        MailMessage message = new MailMessage();

        //누가보내고 누구한테 보내는지, toword 공식 메일이 될 나의 실험용 계정에서 개인 계정으로
        message.From = new MailAddress("echunleaning@gmail.com","Toword",System.Text.Encoding.UTF8);
        message.To.Add(new MailAddress("echun1234@gmail.com"));
        message.IsBodyHtml = true;

        //인증 번호 생성하고 보낼 내용 기술

        message.Subject = "Toword 건의사항 발신자 : " + Session["id"].ToString() ;
        message.Body = "내용 : " + txtSuggestion.Text;

        //인코딩 설정
        message.SubjectEncoding = System.Text.Encoding.UTF8;
        message.BodyEncoding = System.Text.Encoding.UTF8;

        //smtp설정 gmail이용, 구글 smtp는 587과 465가 있는데 465를 쓰면 io어쩌구 에러 뜸
        SmtpClient client = new SmtpClient("smtp.gmail.com", 587);

        //기타 설정, 실제 gmail을 이용하여보냄, 구글계정에서 개인설정 필요함
        client.EnableSsl = true;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("echunleaning@gmail.com", "!#qwe1234");
        client.Send(message);
         
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
                            <asp:RequiredFieldValidator ID="RequireFieldValidation1" runat="server" ErrorMessage="<font color='red'>암호를 입력하세요</font>" 
                                ControlToValidate="txtPwd" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="formDiv">
                                <asp:Label ID="Label3" runat="server" Text="비밀번호 확인" CssClass="labelCss"></asp:Label>
                                <asp:TextBox ID="txtPwdCk" runat="server" TextMode="Password" CssClass="inputCss"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="<font color='red'>암호확인을 입력하세요</font>" 
                                ControlToValidate="txtPwdCk" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="암호가 일치하지 않습니다" ControlToValidate="txtPwd" ControlToCompare="txtPwdCk" Display="Dynamic"></asp:CompareValidator>
                            <div class="formDiv">
                                <asp:Label ID="Label4" runat="server" Text="이메일" CssClass="labelCss"></asp:Label>
                                <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true" CssClass="inputCss"></asp:TextBox>
                            </div>
                            <div class="formDiv">
                                <asp:Button ID="btnSubmit" runat="server" Text="정보 변경" CssClass="buttonCss" OnClick="btnSubmit_Click"/>
                            </div>
                        </div>
                    </td>

                </tr>
                <tr >
                    <td style="height:400px;background-color:yellowgreen">
                        <h3>건의 사항이 있으면 건의해주세요~</h3>
                        <asp:TextBox ID="txtSuggestion" runat="server" TextMode="MultiLine" Width="100%" Height="70%"></asp:TextBox>
                        <asp:Button ID="btnSend" runat="server" Text="전송" CssClass="buttonCss" OnClick="btnSend_Click" CausesValidation="false"/>
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
