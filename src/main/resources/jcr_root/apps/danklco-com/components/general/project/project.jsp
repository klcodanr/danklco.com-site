<%@include file="/libs/sling-cms/global.jsp"%>
<c:if test="${not empty properties.clientName}">
	<div class="project" data-client="${sling:encode(properties.clientName,'HTML_ATTR')}" data-project="${sling:encode(properties.projectName,'HTML_ATTR')}">
		<a href="/content/personal-sites/danklco-com/my-work.html" class="btn btn-default btn-lg">
			<em class="fa fa-chevron-left"></em> 
			My Work
		</a>
		<br><br>
		<div class="row">
			<div class="col-md-6 offset-md-3">
				<img src="${properties.image}" data-project="${sling:encode(properties.projectName,'HTML_ATTR')}" alt="${sling:encode(properties.clientName,'HTML_ATTR')} - ${sling:encode(properties.projectName,'HTML_ATTR')}" class="img-fluid mx-auto d-block">
			</div>
		</div>
		<br><hr><br>
		<div class="row">
			<div class="col-md-12">
				<div class="engagement-body">
					<header>
						<h4>
							<sling:encode value="${properties.clientName}" mode="HTML" /> - <sling:encode value="${properties.projectName}" mode="HTML" />
							<fmt:parseDate value="${properties.startDate}" var="startDate" pattern="yyyy-MM-dd" />
							<fmt:parseDate value="${properties.endDate}" var="endDate" pattern="yyyy-MM-dd" />
							<span class="pull-right">
								<fmt:formatDate value="${startDate}" pattern="MM / yyyy" /> -
								<c:choose>
									<c:when test="${endDate.year == 1100}">
										Present
									</c:when>
									<c:otherwise>
										<fmt:formatDate value="${endDate}" pattern="MM / yyyy" />
									</c:otherwise>
								</c:choose>
							</span>
						</h4>
					</header>
					<p>
						<em>
							<sling:encode value="${properties.projectRole}" mode="HTML" />
						</em>
					</p>
					<ul class="tasks">
						<c:forEach var="task" items="${properties.tasks}">
							<li>
								<sling:encode value="${task}" mode="HTML" />
							</li>
						</c:forEach>
					</ul>
					Tools Used:
					<ul class="list-inline">
						<c:forEach var="tool" items="${properties.tools}">
							<li class="list-inline-item">
								<c:set var="toolProperties" value="${sling:getResource(resourceResolver,tool).valueMap}" />
								<a href="/content/personal-sites/danklco-com/tags.html${tool}" title="Search for ${sling:encode(toolProperties['jcr:title'],'HTML_ATTR')}">
									<sling:encode value="${toolProperties['jcr:title']}" mode="HTML" />
								</a>
							</li>
						</c:forEach>
					</ul> 
				</div>
			</div>
		</div>
	</div>
</c:if>