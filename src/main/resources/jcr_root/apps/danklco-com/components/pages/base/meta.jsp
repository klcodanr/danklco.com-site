<%@include file="/apps/danklco-com/global.jsp"%>
<c:set var="page" value="${sling:adaptTo(resource,'org.apache.sling.cms.PageManager').page}" />
<c:if test="${slingRequest.requestPathInfo.suffixResource != null && slingRequest.requestPathInfo.suffixResource.resourceType == 'sling:Taxonomy'}">
	<c:set var="titlePrefix" value="${sling:encode(slingRequest.requestPathInfo.suffixResource.valueMap['jcr:title'],'HTML')} | " />
</c:if>
<title>${titlePrefix}<sling:encode value="${properties['jcr:title']}" mode="HTML" /> | Dan Klco - Adobe Digital Marketing Architect</title>
<meta content="${fn:join(page.keywords,',')}" name="keywords" />
<meta content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" name="description" />
<meta name="twitter:description" content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" />
<meta content="Dan Klco" name="author" />
<meta property="og:site_name" content="Dan Klco - Adobe Digital Marketing Architect"/>
<meta property="og:type" content="blog"/>
<meta property="og:title" content="${titlePrefix}${sling:encode(properties['jcr:title'], 'HTML')} | Dan Klco - Adobe Digital Marketing Architect"/>
<meta name="twitter:card" content="summary" />
<meta name="twitter:title" content="${titlePrefix}${sling:encode(properties['jcr:title'], 'HTML')} | Dan Klco - Adobe Digital Marketing Architect" />
<meta property="og:image" content="/static/clientlibs/danklco-com/img/me.jpg"/>
<meta name="twitter:image" content="/static/clientlibs/danklco-com/img/me.jpg"/>
<c:set var="publishedUrl" value="https://www.danklco.com${fn:replace(page.publishedPath,'index.html','')}${slingRequest.requestPathInfo.suffix}" />
<meta property="og:url" content="${publishedUrl}"/>
<link rel="canonical" href="${publishedUrl}" />
<meta name="twitter:url" content="${publishedUrl}" />