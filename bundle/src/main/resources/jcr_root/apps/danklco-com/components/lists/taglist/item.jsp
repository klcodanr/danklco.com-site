<%@include file="/libs/sling-cms/global.jsp"%>
<div class="card my-2">
	<div class="card-body">
		<h5 class="card-title">
			<a href="${item.path}.html">
				<sling:encode value="${item.valueMap['jcr:content/jcr:title']}" default="${item.name}" mode="HTML" />
			</a>
		</h5>
		<p class="card-text">
			<sling:encode value="${item.valueMap['jcr:content/jcr:description']}" mode="HTML" />
		</p>
		<a href="${item.path}.html" class="card-link">
			${fn:replace(item.path,sling:getAbsoluteParent(item,3).path,'')}.html
		</a>
	</div>
</div>