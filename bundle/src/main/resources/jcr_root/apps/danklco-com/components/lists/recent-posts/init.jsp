<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="query" value="SELECT * FROM [sling:Page] WHERE [jcr:content/published] = true AND [jcr:content/publishDate] IS NOT NULL AND ISDESCENDANTNODE([/content/personal-sites/danklco-com/posts]) ORDER BY [jcr:content/publishDate] DESC" scope="request" />
<c:set var="limit" value="5" scope="request" />
<c:set var="includePagination" value="false" scope="request" />

<c:set var="tag" value="ul" scope="request" />
<c:set var="clazz" value="simple-post-list list-unstyled" scope="request" />
<c:set var="listConfig" value="${pageMgr.page.template.componentConfigs['reference/components/general/list']}" scope="request" />
<c:if test="${not empty limit}">
	<c:set var="list" value="${sling:adaptTo(slingRequest, 'org.apache.sling.cms.reference.models.ItemList')}" scope="request"  />
</c:if>