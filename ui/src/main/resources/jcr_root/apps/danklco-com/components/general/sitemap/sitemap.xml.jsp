<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="site" value="${sling:adaptTo(resource,'org.apache.sling.cms.core.models.SiteManager').site}" />
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<c:set var="query" value="SELECT * FROM [sling:Page] WHERE ISDESCENDANTNODE([${site.path}]) AND [jcr:content/published]=true AND ([jcr:content/hideInSitemap] IS NULL OR [jcr:content/hideInSitemap] <> true)" />
	<c:forEach var="pageRsrc" items="${sling:findResources(resourceResolver,query,'JCR-SQL2')}">
		<c:set var="page" value="${sling:adaptTo(pageRsrc,'org.apache.sling.cms.core.models.PageManager').page}" />
		<url>
			<loc>${site.url}${page.publishedPath}</loc>
			<changefreq>monthly</changefreq>
		</url>
	</c:forEach>
	<url>
		<loc>${site.url}/</loc>
		<changefreq>always</changefreq>
	</url>
</urlset>
