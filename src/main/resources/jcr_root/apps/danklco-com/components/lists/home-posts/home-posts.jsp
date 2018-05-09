<%@include file="/libs/sling-cms/global.jsp"%>
<sling:call script="init.jsp" />
<c:if test="${list != null}">
	<${tag} class="list ${clazz}">
		<c:if test="${list.currentPage != 1}">
			<div class="my-4 font-weight-bold">
				<strong>
					Page ${list.currentPage} of ${fn:length(list.pages)}
				</strong>
			</div>
		</c:if>
		<section itemscope itemtype="http://schema.org/Blog" class="articles-wrapper">
			<div class="row">
				<c:forEach var="it" items="${list.items}">
					<c:set var="item" value="${it}" scope="request" />
					<sling:call script="item.jsp" />
				</c:forEach>
			</div>
		</section>
	</${tag}>
	<c:if test="${includePagination}">
		<sling:call script="pagination.jsp" />
	</c:if>
</c:if>