<%@ Page Title="" Language="C#" MasterPageFile="~/aspTest_201607058/final/MasterPage1.master" %>

<script runat="server">

</script>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    Hi Master ==> !!
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="quiz" runat="server">
        <iframe src="quiz.aspx" scrolling="no" width="100%" height="100%" frameborder=0 framespacing=0></iframe>
        
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ex" runat="server">
        <iframe src="Reminder.aspx" scrolling="no" width="100%" height="100%" frameborder=0 framespacing=0></iframe>
        
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="abc" runat="server">
    asfadafd
    <asp:GridView ID="GridView1" runat="server"></asp:GridView>
</asp:Content>