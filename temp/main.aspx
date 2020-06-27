<%@ Page Title="" Language="C#" MasterPageFile="~/aspTest_201607058/final/MasterPage1.master" %>

<script runat="server">

</script>




<asp:Content ID="Content2" ContentPlaceHolderID="quiz" runat="server">
        <iframe id="fraQuiz"  src="quiz.aspx" scrolling="no" width="100%" height="100%" frameborder=0 framespacing=0></iframe>
        
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ex" runat="server">
        <iframe id="fraRemainder" src="Reminder.aspx" scrolling="no" width="100%" height="100%" frameborder=0 framespacing=0></iframe>
        
</asp:Content>
