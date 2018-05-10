<%@include file="/apps/danklco-com/global.jsp"%>
<c:set var="page" value="${sling:adaptTo(resource,'org.apache.sling.cms.core.models.PageManager').page}" />
<c:set var="type" value="${fn:replace(page.templatePath,'/conf/danklco-com/site/templates/','')}" />
<c:if test="${not empty page.keywords}">
    <c:set var="sep" value="','" />
    <c:set var="keywords" value="'${fn:join(page.keywords,sep)}'" />
</c:if>
<script>
    dataLayer = [{
        "keywords": [${keywords}],
        "name": "${page.resource.name}",
        "path": "${page.path}",
        "sitePath": "${fn:replace(page.path,'/content/personal-sites/danklco-com','')}",
        "type": "${type}"
        
    }];
<c:choose>
    <c:when test="${type == 'post'}">
        <fmt:parseDate value="${properties.publishDate}" var="publishDate" pattern="yyyy-MM-dd" />
        dataLayer.push({
            "publishYear": "<fmt:formatDate value="${publishDate}" pattern="yyyy" />",
            "publishMonth": "<fmt:formatDate value="${publishDate}" pattern="MM" />"
        });
    </c:when>
</c:choose>
</script>
