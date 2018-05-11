<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="page" value="${sling:adaptTo(resource,'org.apache.sling.cms.core.models.PageManager').page}" />
<span class="social-share share">
	Share this:
	<c:url var="twitter" value="https://twitter.com/intent/tweet">
		<c:param name = "text" value = "${page.contentResource.valueMap['jcr:title']} ${page.publishedUrl}?utm_source%3Dsocialshare%26utm_medium%3Dtwitter"/>
	</c:url>
	<a class="btn btn-sm btn-default" href="${twitter}" target="_blank" title="Share this article on Twitter" data-network="Twitter">
		<em class="fa fa-twitter">
			<span class="sr-only">Share on Twitter</span>
		</em>
	</a>
	<c:url var="linkedin" value="https://www.linkedin.com/shareArticle">
		<c:param name="mini" value="true" />
		<c:param name="url" value="${page.publishedUrl}?utm_source%3Dsocialshare%26utm_medium%3Dlinkedin" />
		<c:param name="title" value="${page.contentResource.valueMap['jcr:title']}" />
		<c:param name="summary" value = "${page.contentResource.valueMap['jcr:description']}"/>
		<c:param name="source" value = "DanKlco.com"/>
	</c:url>
	<a class="btn btn-sm btn-default" href="${linkedin}" target="_blank" title="Share this article on LinkedIn" data-network="LinkedIn">
		<em class="fa fa-linkedin">
			<span class="sr-only">Share on LinkedIn</span>
		</em>
	</a>
	<c:url var="email" value="">
		<c:param name="subject" value="${page.contentResource.valueMap['jcr:title']}" />
		<c:param name="body" value = "${page.contentResource.valueMap['jcr:description']}\n\nLink: ${page.publishedUrl}?utm_source%3Dsocialshare%26utm_medium%3Demail"/>
	</c:url>
	<a class="btn btn-sm btn-default" href="mailto:${email}" target="_blank" title="Share this article via Email" data-network="Email">
		<em class="fa fa-envelope">
			<span class="sr-only">Share via Email</span>
		</em>
	</a>
</span>