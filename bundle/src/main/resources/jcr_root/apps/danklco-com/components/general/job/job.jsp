<%@include file="/libs/sling-cms/global.jsp"%>
<article class="job">
	<header>
		<h4>
			<sling:encode value="${properties.company}" mode="HTML" /> &mdash; <sling:encode value="${properties.location}" mode="HTML" />
			<span class="pull-right">
				<sling:encode value="${properties.start}" mode="HTML" /> - <sling:encode value="${properties.end}" mode="HTML" />
			</span>
		</h4>
	</header>
	<p>
		<em>
			<sling:encode value="${properties.role}" mode="HTML" />
		</em>
	</p>
	<ul>
		<c:forEach var="task" items="${properties.tasks}">
			<li>
				<sling:encode value="${task}" mode="HTML" />
			</li>
		</c:forEach>
	</ul>
</article>