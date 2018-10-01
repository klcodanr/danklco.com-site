<%@include file="/apps/danklco-com/global.jsp"%>
<c:set var="page" value="${sling:adaptTo(resource,'org.apache.sling.cms.PageManager').page}" />
<title><sling:encode value="${properties['jcr:title']}" mode="HTML" /> | Dan Klco - Adobe Digital Marketing Architect</title>
<meta content="${fn:join(page.keywords,',')}" name="keywords" />
<meta content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" name="description" />
<meta name="twitter:description" content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" />
<meta content="Dan Klco" name="author" />
<meta property="og:site_name" content="Dan Klco - Adobe Digital Marketing Architect"/>
<meta property="og:type" content="blog"/>
<meta property="og:title" content="${properties['jcr:title']} | Dan Klco - Adobe Digital Marketing Architect"/>
<meta name="twitter:card" content="summary" />
<meta name="twitter:title" content="${properties['jcr:title']} | Dan Klco - Adobe Digital Marketing Architect" />
<meta property="og:image" content="/static/clientlibs/danklco-com/img/me.jpg"/>
<meta name="twitter:image" content="/static/clientlibs/danklco-com/img/me.jpg"/>
<meta property="og:url" content="https://www.danklco.com${page.publishedPath}"/>
<link rel="canonical" href="https://www.danklco.com${page.publishedPath}" />
<meta name="twitter:url" content="https://www.danklco.com${page.publishedPath}" />