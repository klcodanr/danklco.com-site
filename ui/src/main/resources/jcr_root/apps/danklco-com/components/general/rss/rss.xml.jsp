<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="site" value="${sling:adaptTo(resource,'org.apache.sling.cms.core.models.SiteManager').site}" />
	<channel>
		<title>${site.title}</title>
		<description>${site.description}</description>
		<link>${site.url}</link>
		<atom:link href="${site.url}/rss/jcr:content.rss.xml" rel="self" type="application/rss+xml" />
		<c:set var="query" value="SELECT * FROM [sling:Page] WHERE ISDESCENDANTNODE([/content/danklco-com/posts]) AND [jcr:content/published]=true ORDER BY [jcr:content/publishDate] DESC" />
		<c:forEach var="postRsrc" items="${sling:findResources(resourceResolver,query,'JCR-SQL2')}" end="9">
			<item>
				<c:set var="post" value="${sling:adaptTo(postRsrc,'org.apache.sling.cms.core.models.PageManager').page}" />
				<title><sling:encode value="${post.title}" mode="XML" /></title>
				<description><sling:encode value="${post.properties['jcr:description']}" mode="XML" /></description>
				<content:encoded>
					<![CDATA[
						<img src="${site.url}${fn:replace(post.properties['sling:thumbnail'],site.path,'')}" title="${sling:encode(post.properties.summary,'XML_ATTR')}" />
						<sling:encode value="${post.properties.snippet}" mode="XML" />
					]]>
				</content:encoded>
				<c:if test="${not empty post.properties['sling:thumbnail']}">
					<c:choose>
						<c:when test="${fn:indexOf(post.properties['sling:thumbnail'],'.png') != -1}">
							<enclosure length="0" type="image/png" url="${fn:replace(site.url,'https','http')}${fn:replace(post.properties['sling:thumbnail'],site.path,'')}" />
						</c:when>
						<c:otherwise>
							<enclosure length="0" type="image/jpeg" url="${fn:replace(site.url,'https','http')}${fn:replace(post.properties['sling:thumbnail'],site.path,'')}" />
						</c:otherwise>
					</c:choose>
				</c:if>
				<fmt:parseDate value="${post.properties.publishDate}" var="publishDate" pattern="yyyy-MM-dd" />
				<pubDate><fmt:formatDate value="${publishDate}" pattern="EEE, dd MMM yyyy HH:mm:ss Z" /></pubDate>
				<link>${site.url}${post.publishedPath}</link>
				<guid isPermaLink="true">${site.url}${post.publishedPath}</guid>
			</item>
		</c:forEach>
	</channel>
</rss>