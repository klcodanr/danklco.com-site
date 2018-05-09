<%@include file="/apps/danklco-com/global.jsp"%>
<sling:adaptTo var="pageMgr" adaptable="${resource}" adaptTo="org.apache.sling.cms.core.models.PageManager" />
<c:set var="page" value="${pageMgr.page}" />
<nav class="navbar navbar-expand-md navbar-dark fixed-top background__dark">
	<div class="container">
      <a class="navbar-brand" href="/content/personal-sites/danklco-com/">Dan Klco</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#main-nav" aria-controls="main-nav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
		<div class="collapse navbar-collapse" id="main-nav">
			<ul class="nav navbar-nav mr-auto">
				<li class="nav-item ${fn:startsWith(page.path,'/content/personal-sites/danklco-com/my-work') || fn:startsWith(page.path,'/content/personal-sites/danklco-com/projects/') ? 'active' : ''}">
                    <a class="nav-link" href="/content/personal-sites/danklco-com/my-work.html">My Work</a>
                </li>
				<li class="nav-item ${page.path == '/content/personal-sites/danklco-com/curriculum-vitae' ? 'active' : ''}">
                    <a class="nav-link" href="/content/personal-sites/danklco-com/curriculum-vitae.html">Curriculum Vitae</a>
                </li>
				<li class="nav-item ${page.path == '/content/personal-sites/danklco-com/projects' ? 'active' : ''}">
                     <a class="nav-link" href="/content/personal-sites/danklco-com/projects.html">Projects</a>
                </li>
				<li class="nav-item ${page.path == '/content/personal-sites/danklco-com/contact' || page.path == '/content/personal-sites/danklco-com/thank-you' ? 'active' : ''}">
                    <a class="nav-link" href="/content/personal-sites/danklco-com/contact.html">Contact</a>
                </li>
			</ul>
		</div>
	</div>
</nav>