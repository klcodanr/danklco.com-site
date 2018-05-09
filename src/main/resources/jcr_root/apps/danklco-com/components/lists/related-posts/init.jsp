<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="page" value="${sling:adaptTo(resource,'org.apache.sling.cms.core.models.PageManager').page}" />
<c:set var="params" value="${fn:join(page.contentResource.valueMap['sling:taxonomy'],'\\' OR [jcr:content/sling:taxonomy]=\\']')}" />
<c:set var="query" value="SELECT * FROM [sling:Page] WHERE ISDESCENDANTNODE([/content/personal-sites/danklco-com/posts]) AND [jcr:content/publishDate] IS NOT NULL AND NOT [jcr:path] = '${page.path}' AND ([jcr:content/sling:taxonomy]='${params}')" scope="request" />
<c:set var="limit" value="5" scope="request" />
<c:set var="includePagination" value="false" scope="request" />
<c:set var="tag" value="ul" scope="request" />
<c:set var="clazz" value="simple-post-list list-unstyled" scope="request" />
<c:set var="listConfig" value="${pageMgr.page.template.componentConfigs['reference/components/general/list']}" scope="request" />
<c:if test="${not empty limit}">
	<c:set var="list" value="${sling:adaptTo(slingRequest, 'org.apache.sling.cms.reference.models.ItemList')}" scope="request"  />
</c:if>