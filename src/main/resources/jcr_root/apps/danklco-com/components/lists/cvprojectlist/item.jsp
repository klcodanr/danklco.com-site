<%@include file="/libs/sling-cms/global.jsp"%>
<sling:adaptTo var="pageMgr" adaptable="${item}" adaptTo="org.apache.sling.cms.core.models.PageManager" />
<article class="project client" data-title="${sling:encode(item.valueMap.clientName,'HTML_ATTR')} - ${sling:encode(item.valueMap.projectName,'HTML_ATTR')}"
	data-image="${item.valueMap.image}"
	data-url="${pageMgr.page.path}.html" data-client="${sling:encode(item.valueMap.clientName,'HTML_ATTR')}"
	data-project="${sling:encode(item.valueMap.projectName,'HTML_ATTR')}">
	<header>
		<h4>
			<a href="${pageMgr.page.path}.html" title="More about ${sling:encode(item.valueMap.clientName,'HTML_ATTR')} - ${sling:encode(item.valueMap.projectName,'HTML_ATTR')}">
				${sling:encode(item.valueMap.clientName,'HTML')} - ${sling:encode(item.valueMap.projectName,'HTML_ATTR')}
			</a>
			<fmt:parseDate value="${item.valueMap.startDate}" var="startDate" pattern="yyyy-MM-dd" />
			<fmt:parseDate value="${item.valueMap.endDate}" var="endDate" pattern="yyyy-MM-dd" />
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
			<sling:encode value="${item.valueMap.projectRole}" mode="HTML" />
		</em>
	</p>
	<ul class="tasks">
		<c:forEach var="task" items="${item.valueMap.tasks}">
			<li>
				<sling:encode value="${task}" mode="HTML" />
			</li>
		</c:forEach>
	</ul>
	Tools Used:
	<ul class="list-inline">
		<c:forEach var="tool" items="${item.valueMap.tools}">
			<li class="list-inline-item">
				<c:set var="toolProperties" value="${sling:getResource(resourceResolver,tool).valueMap}" />
				<sling:encode value="${toolProperties['jcr:title']}" mode="HTML" />
			</li>
		</c:forEach>
	</ul>
</article>