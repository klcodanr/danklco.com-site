<%@include file="/libs/sling-cms/global.jsp"%>
<sling:adaptTo var="pageMgr" adaptable="${resource}" adaptTo="org.apache.sling.cms.core.models.PageManager" />
<div class="col-md-4 col-sm-6">
	<div class="pin client" id="${sling:encode(properties.clientName,'HTML_ATTR')}"
		data-title="${sling:encode(properties.clientName,'HTML_ATTR')} - ${sling:encode(properties.projectName,'HTML_ATTR')}"
		title="Find out more about my work at ${sling:encode(properties.clientName,'HTML_ATTR')}"
		data-image="${sling:encode(properties.image,'HTML_ATTR')}" data-image-width="800"
		data-url="${pageMgr.page.path}.html">
		<div class="img"
			style="background-image: url('${sling:encode(properties.image,'HTML_ATTR')}')">
			<div class="hover-show">
				<h3>
					<a href="${pageMgr.page.path}.html" title="${sling:encode(properties.clientName,'HTML_ATTR')} - ${sling:encode(properties.projectName,'HTML_ATTR')}">
						${sling:encode(properties.clientName,'HTML')} - ${sling:encode(properties.projectName,'HTML')}
					</a>
				</h3>
				<div class="content">
					<fmt:parseDate value="${properties.startDate}" var="startDate" pattern="yyyy-MM-dd" />
					<fmt:parseDate value="${properties.endDate}" var="endDate" pattern="yyyy-MM-dd" />
					<p>
						<fmt:formatDate value="${startDate}" pattern="MM / yyyy" /> -
						<c:choose>
							<c:when test="${endDate.year == 1100}">
								Present
							</c:when>
							<c:otherwise>
								<fmt:formatDate value="${endDate}" pattern="MM / yyyy" />
							</c:otherwise>
						</c:choose>
					</p>
					<p>
						<em>
							<sling:encode value="${properties.projectRole}" mode="HTML" />
						</em>
					</p>
				</div>
			</div>
		</div>
		<div class="d-none">
			<ul class="tasks">
				<c:forEach var="task" items="${properties.tasks}">
					<li>
						<sling:encode value="${task}" mode="HTML" />
					</li>
				</c:forEach>
			</ul>
			<ul class="list-inline">
				<c:forEach var="tool" items="${properties.tools}">
					<li>
						<c:set var="toolProperties" value="${sling:getResource(resourceResolver,tool).valueMap}" />
						<sling:encode value="${toolProperties['jcr:title']}" mode="HTML" />
					</li>
				</c:forEach>
			</ul>
		</div>
	</div>
</div>