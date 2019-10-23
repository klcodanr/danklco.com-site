<%@include file="/libs/sling-cms/global.jsp"%>
<c:forEach var="reason" items="${sling:listChildren(sling:getResource(resourceResolver,'/content/personal-sites/danklco-com/100-reasons-why-not-htl'))}" varStatus="status">
  <c:if test="${reason.name != 'jcr:content'}"> 
    <div class="card my-1">
      <div class="card-body">
        <h5>
          <span class="font-weight-bold">#${status.index}</span>
          <sling:encode value="${reason.valueMap['jcr:content/jcr:title']}" mode="HTML" />
        </h5>
        <c:if test="${not empty reason.valueMap['jcr:content/name']}">
          <cite>
            <sling:encode value="${reason.valueMap['jcr:content/name']}" mode="HTML" />
          </cite>
        </c:if>
      </div>
    </div>
  </c:if>
</c:forEach>