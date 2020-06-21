<%@ Page Language="C#" %>

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
                DropLog.InnerText = "LogOut";
                DropLog.HRef = "Logout.aspx";

            }




        }
    }

</script>

<style>

   .body {
		
		background : linear-gradient(#214C63,#2D8634);
		background-repeat : no-repeat;
		background-size : cover;
        height : 1000px
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
  <!-- Brand -->
  <a class="navbar-brand" href="index.aspx" runat="server" >Toword</a>

  <!-- Links -->
  <ul class="navbar-nav">
    

    <!-- Dropdown -->
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
        <div>

        </div>
    </form>


 <div class="jumbotron text-center leftJumbo" >
        <h1>Toword</h1>
        <p>매일 매일 단어 암기</p>
    </div>

     <div class="jumbotron text-center rightJumbo">
        <h1>Toword</h1>
        <p>매일 매일 단어 암기</p>
    </div>




</body>
</html>
