<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty bubbleMessage}">
<div id="message" class="alert alsert-${bubbleType} hide">
<button data-dismiss="alert" class="close">x</button>
${bubbleMessage}
	<p>
</div>
<script type="text/javascript">
$("#message").show();
</script>
</c:if>