<%@include file="/libs/sling-cms/global.jsp"%>
<div class="${formConfig.fieldGroupClass} ${properties.addClasses}">
    <c:if test="${not empty properties.label}">
        <label for="${properties.name}">
            <sling:encode value="${properties.label}" mode="HTML" />
            <span class="${formConfig.fieldRequiredClass}">
                *
            </span>
        </label>
    </c:if>
    <br/>
    <select name="${properties.name}" required="required">
    	<c:forEach var="option" items="${requestScope[properties.key]}" >
    		<option value="${option.value}">${option.key}</option>
    	</c:forEach>
    </select>
</div>