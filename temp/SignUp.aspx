<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    string verificationCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!Page.IsPostBack)
        {
            //초기화
            verificationCode = "";
        }

    }

    //인증을 위한 랜덤수 생성
    public void CreateRandomNum()
    {
        Random random = new Random();
        int[] a = new int[4];

        for(int i=0; i<4; i++)
        {
            a[i]  = (int)(random.NextDouble()*10);
            verificationCode += a[i];
        }
    }

    protected void btnSendMail_Click(object sender, EventArgs e)
    {
        //인증번호를 보낼 메일이 있어야 함
        if ( email.Text != "")
        {
            MailMessage message = new MailMessage();

            //누가보내고 누구한테 보내는지
            message.From = new MailAddress("echunleaning@gmail.com","이시헌",System.Text.Encoding.UTF8);
            message.To.Add(new MailAddress(email.Text));
            message.IsBodyHtml = true;

            //인증 번호 생성하고 보낼 내용 기술
            CreateRandomNum();
            lblVerification.Text = verificationCode;
            message.Subject = "Toword 인증번호";
            message.Body = "인증번호는 "+verificationCode +"입니다.";

            //인코딩 설정
            message.SubjectEncoding = System.Text.Encoding.UTF8;
            message.BodyEncoding = System.Text.Encoding.UTF8;

            //smtp설정 gmail이용
            SmtpClient client = new SmtpClient("smtp.gmail.com", 587);

            //기타 설정, 실제 gmail을 이용하여보냄, 구글계정에서 개인설정 필요함
            client.EnableSsl = true;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential("echunleaning@gmail.com", "!#qwe1234");
            client.Send(message);


            confirmMail.Visible = true;

        }
        else
        {
            this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "MessageBox", "alert('email을 입력하세요')",true);
        }

    }

    public void CheckForSubmit()
    {
        //비밀번호가 일치하고 인증번호가 일치하면, 다시게시 때문에 visible==false인 라벨을 만들어서 값 저장시킴
        if(pwd.Text==pwdck.Text && confirmMail.Text == lblVerification.Text)
        {
            SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=flunge; pwd=dksk1399");

            string sql = "insert into userInfo values(@userid, @password, @email)";
            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.Parameters.AddWithValue("@userid", userID.Text);
            cmd.Parameters.AddWithValue("@password", pwd.Text);
            cmd.Parameters.AddWithValue("@email", email.Text);

            con.Open();
            cmd.ExecuteNonQuery();

            con.Close();
        }
        else
        {
            this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "MessageBox", "alert('인증번호를 확인하세요')",true);
        }


    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        CheckForSubmit();
        Response.Redirect("index.aspx");
    }


</script>
<script lang="javascript" type="text/javascript">

    function ConfirmID() {
        window.name = "ckForm";
        window.open("wizard.aspx", "check", "width=500, height=300");
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
        width:400px;
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
    <h1>Join us</h1>
    <form id="userInfo" runat="server" class="form">
        <div>
            <div class="formDiv">
                <asp:Label ID="lblId" runat="server" Text="아이디" CssClass="labelCss"></asp:Label>
                <asp:TextBox ID="userID" runat="server" TextMode="SingleLine" CssClass="inputCss"></asp:TextBox><asp:Button ID="Button1" runat="server" Text="중복확인" OnClientClick="return ConfirmID()" CssClass="buttonCss"/>
            </div>
            <div class="formDiv">
               <asp:Label ID="lblPwd" runat="server" Text="암호" CssClass="labelCss" ></asp:Label>
                <asp:TextBox ID="pwd" runat="server" TextMode="Password" CssClass="inputCss"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="RequireFieldValidation1" runat="server" ErrorMessage="<font color='red'>암호를 입력하세요</font>" 
                        ControlToValidate="pwd" Display="Dynamic"></asp:RequiredFieldValidator>
            <div class="formDiv">
               <asp:Label ID="lblPwdCk" runat="server" Text="암호확인" CssClass="labelCss"></asp:Label>
               <asp:TextBox ID="pwdck" runat="server" TextMode="Password" CssClass="inputCss"></asp:TextBox>
            </div>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="<font color='green'>암호확인을 입력하세요</font>" 
                        ControlToValidate="pwdck" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="비밀번호가 일치하지 않습니다" ControlToValidate="pwd" ControlToCompare="pwdck" Display="Dynamic"></asp:CompareValidator>
            
            <div class="formDiv">
                <asp:Label ID="lblEmail" runat="server" Text="이메일" CssClass="labelCss"></asp:Label>
                <asp:TextBox ID="email" runat="server" TextMode="SingleLine" placeholder="abcd@toword.com" CssClass="inputCss"></asp:TextBox><asp:Button ID="btnSendMail" runat="server" Text="메일전송" OnClick="btnSendMail_Click"/>
                
            </div>
            <div class="formDiv">
                <asp:TextBox ID="confirmMail" runat="server" Visible="false" placeholder="인증번호를 입력하세요. " CssClass="inputCss"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="<font color='red'>인증번호를 입력하세요</font>" 
                        ControlToValidate="confirmMail" Display="Dynamic"></asp:RequiredFieldValidator>
            
            
            <asp:Button ID="Button2" runat="server" Text="회원가입" OnClick="Button2_Click" CssClass="buttonCss"/>
            
        </div>
        
        <asp:Label ID="lblVerification" runat="server" Text="" Visible="false"></asp:Label>
    </form>
</div>
</body>
</html>
