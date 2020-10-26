<%@include file="/libs/sling-cms/global.jsp"%>
<hr class="large"/>
<h4>Tags</h4>
<div class="tags" property="keywords">
    <c:forEach var="tag" items="${properties['sling:taxonomy']}" varStatus="status">
		<c:set var="tagProperties" value="${sling:getResource(resourceResolver,tag).valueMap}" />
		<a href="/content/personal-sites/danklco-com/tags.html${tag}"><sling:encode value="${tagProperties['jcr:title']}" mode="HTML" /></a><c:if test="${not status.last}">,</c:if>&nbsp;
	</c:forEach>
</div>