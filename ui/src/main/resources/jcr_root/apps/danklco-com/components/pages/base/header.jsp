<%@include file="/apps/danklco-com/global.jsp"%>
<header class="page-header row">
	<div class="container">
		<div class="content" typeof="Person">
			<a href="/" title="Home">
				<img src="/etc/clientlibs/danklco-com/img/me.jpg" property="image" alt="Picture of Dan Klco" width="100" height="100" class="pull-left img-responsive"  />
			</a>
			<c:choose>
					<c:when test="${page.path == '/content/danklco-com/index'}">
					<h1 property="name">
						Daniel Klco
					</h1>
				</c:when>
				<c:otherwise>
					<div class="header-lg" property="name">
						Daniel Klco
					</div>
				</c:otherwise>
			</c:choose>
			<p property="description">
				<span class="fa fa-globe"><span class="sr-only">I'm based out of</span></span>&nbsp;&nbsp;<span property="homeLocation">Cincinnati, OH</span><br/>
				<span class="fa fa-briefcase"><span class="sr-only">I work as the</span></span>&nbsp;&nbsp;<span property="jobTitle">Adobe Digital Marketing Solution Lead</span> at <a href="http://www.perficient.com" property="worksFor" title="My Employer" typeof="Organization">Perficient</a>
			</p>
		</div>
	</div>
</header>