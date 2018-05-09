<%@page session="false" %><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><sling:defineObjects /><sling:adaptTo var="properties" adaptable="${resource}" adaptTo="org.apache.sling.api.resource.ValueMap" />
<c:set var="page" value="${sling:adaptTo(resourc,'org.apache.sling.cms.core.models.PageManager').page}" />
<c:set var="page" value="${sling:adaptTo(resourc,'org.apache.sling.cms.core.models.PageManager').page}" />
