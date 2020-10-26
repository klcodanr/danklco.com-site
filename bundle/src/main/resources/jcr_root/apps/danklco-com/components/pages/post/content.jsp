<%@include file="/libs/sling-cms/global.jsp"%>
<div class="container">
	<div class="row background__white">
		<div class="col-md-8 py-4">
			<article class="post" typeof="BlogPosting">
				<header class="row">
					<div class="col-md-12">
					<c:choose>
						<c:when test="${not empty properties['sling:thumbnail']}">
							<c:set var="image" value="${fn:replace(properties['sling:thumbnail'],'/content/personal-sites/danklco-com','')}" />
						</c:when>
						<c:otherwise>
							<c:set var="image" value="//placehold.it/300x300?text=${sling:encode(properties['jcr:title'],'HTML_ATTR')}" />
						</c:otherwise>
					</c:choose>
						<div class="post-hero" style="background-image: url(${image})">
							<div class="cover">
								<h1 property="headline">
									<sling:encode value="${properties['jcr:title']}" mode="HTML" />
								</h1>
								<em>
									<fmt:parseDate value="${properties.publishDate}" var="publishDate" pattern="yyyy-MM-dd" />
									Published on 
									<time datetime='${properties.publishDate}'>
										<span class="d-none" property="dateModified">${publishDate}</span>
										<span property="datePublished">
											<fmt:formatDate value="${publishDate}" pattern="MMM d, yyyy" /> 
										</span>
									</time>
									by <span class="d-none" property="publisher" typeOf="Organization"><span property="name">Dan Klco</span><img property="logo" src="/static/clientlibs/danklco-com/img/me.jpg" alt="Picture of Me" /></span>
									<span class="author" property="author" typeOf="Person"><span property="name">Dan Klco</span></span>
								</em>
							</div>
						</div>
						<div class="graybar">
							<sling:include path="share" resourceType="danklco-com/components/general/share" />
						</div>
					</div>
				</header>
				<hr class="large" />
				<c:choose>
					<c:when test="${empty properties.original || fn:indexOf(properties.original,'labs.6dglobal.com') != -1 || fn:indexOf(properties.original,'labs.sixdimensions.com') != -1}">
                        <div class="post-body">
				            <sling:include path="container" resourceType="sling-cms/components/general/container" />
                        </div>
						<sling:call script="tags.jsp" />
						<sling:call script="comments.jsp" />
					</c:when>
					<c:otherwise>
                        <blockquote>
                            <div class="post-summary">
                                ${properties.snippet}
                            </div>
                            <footer>
                                <a href="${properties.original}" target="_blank" rel="noopener">
                                	Read the full post &quot;<sling:encode value="${properties['jcr:title']}" mode="HTML" />&quot; on ${fn:split(fn:replace(fn:replace(properties.original,'https://',''),'http://',''),'/')[0]}</a>
                        		</footer>
                        </blockquote> 
                        <sling:call script="tags.jsp" />
                        <sling:call script="/apps/danklco-com/components/general/adsense/adsense.jsp" />
					</c:otherwise>
				</c:choose>
			</article>
		</div>
		<div class="col-md-4 py-4">
			<sling:call script="sidebar.jsp" />
		</div>
	</div>
</div>