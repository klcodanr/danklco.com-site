<%@include file="/libs/sling-cms/global.jsp"%>
<li>
	<fmt:parseDate value="${item.valueMap['jcr:content/publishDate']}" var="publishDate" pattern="yyyy-MM-dd" />
	<a href="${item.path}.html">${item.valueMap['jcr:content/jcr:title']}</a>
	<br>
	<small class="text-muted">
		<span class="fa fa-calendar" aria-hidden="true"></span>&nbsp;
		<em itemprop="datePublished"><fmt:formatDate value="${publishDate}" pattern="MMM d, yyyy" /></em><br></small>
	<br>
</li>