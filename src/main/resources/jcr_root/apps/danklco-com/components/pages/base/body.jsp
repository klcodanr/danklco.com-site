<%@include file="/apps/danklco-com/global.jsp"%>
<body>
	<sling:call script="/libs/sling-cms/components/editor/scripts/init.jsp" />
	<sling:call script="nav.jsp" />
	<sling:call script="header.jsp" />
	<sling:call script="content.jsp" />
	<sling:call script="footer.jsp" />
	<sling:call script="scripts.jsp" />
	<sling:call script="/libs/sling-cms/components/editor/scripts/finalize.jsp" />
</body>