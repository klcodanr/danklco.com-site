<%@include file="/libs/sling-cms/global.jsp" %>
<% pageContext.setAttribute("newLine", "\n"); %>
original: ${properties.code} 
<c:set var="code" value="${fn:replace(properties.code,'~','FOUND')}" />
code: ${code}
<pre>${code}</pre>