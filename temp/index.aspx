﻿<%@ Page Language="C#" %>

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

                Session["type"] = null;
            }




        }
    }

    //퀴즈 유형 선택
    protected void TypeBtn_Click(object sender, EventArgs e)
    {


        if (sender == btnEngBasic)
        {
            Session["type"] = "engBasic";
            Response.Redirect("main.aspx");
        }
        else if(sender== btnEngToeic)
        {
            if (Session["id"] == null)
            {
                this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "MessageBox", "alert('로그인을 하세요(기초 영단어는 가능)')",true);
            }
            else
            {
                Session["type"] = "engToeic";
                Response.Redirect("main.aspx");
            }

        }

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

    .leftJumbo{
         float:left;
         margin-left:5%;
         width:40%;
    }

    .rightJumbo{
         float:right;
         margin-right:5%;
         width:40%;
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

    <br />
    <br />

  
    
    <div class="jumbotron text-center" style="background-color: #214C63;">
        <h1>Toword</h1>
        <p>매일 매일 단어 암기</p>
    </div>



    <form id="form1" runat="server">


    <div class="jumbotron text-center leftJumbo" style="background-color: #214C63;" >
        <h1>English</h1>
        <p>매일 매일 영단어 암기</p>
  
        <div class="btn-group btn-group-justified">
            <asp:Button ID="btnEngBasic" runat="server" Text="기초 단어" class="btn btn-primary" OnClick="TypeBtn_Click"/>
            <asp:Button ID="btnEngToeic" runat="server" Text="토익 단어" class="btn btn-primary" OnClick="TypeBtn_Click"/>
                
        </div>
        
    </div>




     <div class="jumbotron text-center rightJumbo" style="background-color: #214C63;">
        <h1>제2 외국어</h1>
        <p>매일 매일 제2외국어 단어 암기</p>
         
        <div class="btn-group btn-group-justified">
            <a href="#" class="btn btn-primary">추가 예정</a>
            <a href="#" class="btn btn-primary">추가 예정</a>             
        </div>       
    </div>

  

    </form>


   <%--  <div style="margin-top:500px">
        <footer class="container-fluid bg-4 text-center">
            

            <div class=" text-center py-3">© 2020 Copyright:
                <a href="https://github.com/shawn-flunge/"> 201607058 이시헌</a>
            </div>

        </footer>
    </div>--%>


    <footer class="footer bg-4">
        <div class=" text-center py-3">© 2020 Copyright:
                <a href="https://github.com/shawn-flunge/"> 201607058 이시헌</a>
            </div>
    </footer>


    
</body>
    
</html>
