<%@include file="/libs/sling-cms/global.jsp"%>
<div class="card my-2">
	<div class="card-body">
		<h5 class="card-title">
			<a href="${resource.path}.html">
				<sling:encode value="${properties['jcr:content/jcr:title']}" default="${resource.name}" mode="HTML" />
			</a>
		</h5>
		<p class="card-text">
			<sling:encode value="${properties['jcr:content/jcr:description']}" mode="HTML" />
		</p>
		<a href="${resource.path}.html" class="card-link">
			${fn:replace(resource.path,sling:getAbsoluteParent(resource,2).path,'')}.html
		</a>
	</div>
</div>