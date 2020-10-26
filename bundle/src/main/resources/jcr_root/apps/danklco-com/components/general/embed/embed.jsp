<%@include file="/libs/sling-cms/global.jsp"%>
<c:choose>
	<c:when test="${properties.mediaType == 'embed'}">
		<br/><br/>
		<div class="embed-responsive embed-responsive-16by9">
			<iframe src="${properties.media}" class="embed-responsive-item" allowfullscreen="allowfullscreen" title="Video Embed"></iframe>
		</div>
	</c:when>
	<c:when test="${properties.mediaType == 'pdf'}">
		<br/><br/>
		<div class="embed-responsive embed-responsive-4by3">
			<iframe src="${properties.media}" class="embed-responsive-item" allowfullscreen="allowfullscreen" title="PDF Embed"></iframe>
		</div>
	</c:when>
	<c:when test="${properties.mediaType == 'audio'}">
		<br/><br/>
		<audio controls="controls">
			<source src="${properties.media}" type="audio/mpeg"/>
		</audio>
	</c:when>
</c:choose>