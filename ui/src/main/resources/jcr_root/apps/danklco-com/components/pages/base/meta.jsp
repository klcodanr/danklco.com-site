<%@include file="/apps/danklco-com/global.jsp"%>
<title><sling:encode value="${properties['jcr:title']}" mode="HTML" /> | Dan Klco - Adobe Digital Marketing Architect</title>
<meta content="Adobe Experience Manager, Digital Marketer, Adobe Certified Expert, AEM Architect" name="keywords" />
<meta content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" name="description" />
<meta name="twitter:description" content="${sling:encode(properties['jcr:description'],'HTML_ATTR')}" />
<meta content="Dan Klco" name="author" />
<meta property="og:site_name" content="Dan Klco - Adobe Digital Marketing Architect"/>
<meta property="og:type" content="blog"/>
<meta property="og:title" content="${properties['jcr:title']} | Dan Klco - Adobe Digital Marketing Architect"/>
<meta name="twitter:card" content="summary" />
<meta name="twitter:title" content="${properties['jcr:title']} | Dan Klco - Adobe Digital Marketing Architect" />
<meta property="og:image" content="/etc/designs/danklco-com/img/me.jpg"/>
<meta name="twitter:image" content="/etc/designs/danklco-com/img/me.jpg"/>
<meta property="og:url" content="https://www.danklco.com${fn:replace(page.path,'/content/danklco-com','')}"/>
<link rel="canonical" href="https://www.danklco.com${fn:replace(page.path,'/content/danklco-com','')}" />
<meta name="twitter:url" content="https://www.danklco.com${fn:replace(page.path,'/content/danklco-com','')}" />