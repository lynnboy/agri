<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty bubbleMessage}">
<!-- 
<div id="messageBox" class="alert alsert-${bubbleType} hide">
<button data-dismiss="alert" class="close"><span class="icon-remove-sign"></span></button>
${bubbleMessage}
</div>
 -->
<script type="text/javascript">
//if (!top.$.jBox.tip.mess) {
	//top.$.jBox.tip.mess = 1;
	top.$.jBox.tip("${bubbleMessage}", "${not empty bubbleType ? bubbleType : 'info'}", {persistent:true, opacity:0});
	//$("#messageBox").show();
//}
</script>
</c:if>