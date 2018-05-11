<%@include file="/libs/sling-cms/global.jsp"%>
<c:set var="site" value="${sling:adaptTo(item,'org.apache.sling.cms.core.models.SiteManager').site}" />
<fmt:parseDate value="${item.valueMap['jcr:content/publishDate']}" var="publishDate" pattern="yyyy-MM-dd" />
<article class="col-lg-4"> 
	<div class="pin">
		<c:choose>
			<c:when test="${not empty item.valueMap['jcr:content/sling:thumbnail']}">
				<c:set var="image" value="${fn:replace(item.valueMap['jcr:content/sling:thumbnail'],'/content/personal-sites/danklco-com','')}" />
			</c:when>
			<c:otherwise>
				<c:set var="image" value="//placehold.it/300x300?text=${sling:encode(item.valueMap['jcr:content/jcr:title'],'HTML_ATTR')}" />
			</c:otherwise>
		</c:choose>
		<div class="img" style="background-image:url('${image}')">
			<c:choose>
				<c:when test="${item.valueMap['jcr:content/display'] == 'post'}">
					<div class="hover-show">
						<h3>
							<a href="${item.path}.html" title="${sling:encode(item.valueMap['jcr:content/jcr:title'],'HTML_ATTR')}" itemprop="url">
								<sling:encode value="${item.valueMap['jcr:content/jcr:title']}" mode="HTML" />
							</a>
						</h3>
						<div class="content" property="description">
							<sling:encode value="${item.valueMap['jcr:content/jcr:description']}" mode="HTML" />
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="hover-show">
						<h3>
							<a href="${item.path}.html" title="${sling:encode(item.valueMap['jcr:content/jcr:title'],'HTML_ATTR')}" itemprop="url">
								<sling:encode value="${item.valueMap['jcr:content/jcr:title']}" mode="HTML" />
							</a>
							<br/>
							<span class="text-center">
								<c:choose>
									<c:when test="${item.valueMap['jcr:content/display'] == 'pdf'}">
										<em class="fa fa-download fa-3x"></em>
									</c:when>
									<c:when test="${item.valueMap['jcr:content/display'] == 'audio'}">
										<em class="fa fa-microphone fa-3x"></em>
									</c:when>
									<c:otherwise>
										<em class="fa fa-play fa-3x"></em>
									</c:otherwise>
								</c:choose>
							</span>
						</h3>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		<p class="text-muted">
			<small>
				<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span> <em itemprop="datePublished"><fmt:formatDate value="${publishDate}" pattern="MMM d, yyyy" /></em>
				<br/>
				<span><em class="fa fa-tags"></em>
					<c:forEach var="tag" items="${item.valueMap['jcr:content/sling:taxonomy']}" end="2" varStatus="status">
						<c:set var="tagProperties" value="${sling:getResource(resourceResolver,tag).valueMap}" />
						<a href="/content/personal-sites/danklco-com/tags.html${tag}"><sling:encode value="${tagProperties['jcr:title']}" mode="HTML" /></a><c:if test="${not status.last}">,</c:if>&nbsp;
					</c:forEach>
				</span>
			</small>
		</p>
	</div>
</article>
