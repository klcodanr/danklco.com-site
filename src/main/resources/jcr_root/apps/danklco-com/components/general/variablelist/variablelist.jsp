<%@include file="/libs/sling-cms/global.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.9.4/cytoscape.min.js"></script>

<div id="graph" style="width: 100%;height: 800px"></div>
<script>
var elements = ${requestScope.elements}
var cy = cytoscape({
  container: document.getElementById('graph'),
  elements: elements,
  layout: {
      name: 'cose',
      idealEdgeLength: 100,
      nodeOverlap: 20,
      refresh: 20,
      fit: true,
      padding: 30,
      randomize: false,
      componentSpacing: 100,
      nodeRepulsion: 400000,
      edgeElasticity: 100,
      nestingFactor: 5,
      gravity: 80,
      numIter: 1000,
      initialTemp: 200,
      coolingFactor: 0.95,
      minTemp: 1.0
  },
  style: [{
	  "selector": "node",
	  "style": {
	    "content": "data(name)",
	    "font-size": "5px",
	    "text-valign": "center",
	    "text-halign": "center",
	    "background-color": "#555",
	    "text-outline-color": "#555",
	    "text-outline-width": "2px",
	    "color": "#fff",
	    "overlay-padding": "6px",
	    "z-index": "10"
	  }
	},
	{
	  "selector": "node.analytics",
	  "style": {
	    "background-color": "#9F7FFF"
	  }
	},
	{
	  "selector": "node.launch",
	  "style": {
	    "background-color": "#F29721"
	  }
	},
	{
	  "selector": "node.missing",
	  "style": {
	    "background-color": "#dc3545"
	  }
	},
	{
	  "selector": "node.extension",
	  "style": {
	    "background-color": "#5293CF"
	  }
	},
	{
	  "selector": "node.rule",
	  "style": {
	    "background-color": "#06BAC7"
	  }
	},
	
	
	
	{
	  "selector": "node:selected",
	  "style": {
	    "border-width": "6px",
	    "border-color": "#AAD8FF",
	    "border-opacity": "0.5",
	    "background-color": "#77828C",
	    "text-outline-color": "#77828C"
	  }
	},
	{
	  "selector": "edge",
	  "style": {
	    "curve-style": "haystack",
	    "haystack-radius": "0.5",
	    "opacity": "0.4",
	    "line-color": "#bbb",
	    "width": "2px",
	    "overlay-padding": "3px"
	  }
	}, {
	  "selector": "node.unhighlighted",
	  "style": {
	    "opacity": "0.2"
	  }
	}, {
	  "selector": "edge.unhighlighted",
	  "style": {
	    "opacity": "0.05"
	  }
	}, {
	  "selector": ".highlighted",
	  "style": {
	    "z-index": "999999"
	  }
	}, {
	  "selector": "node.highlighted",
	  "style": {
	    "border-width": "6px",
	    "border-color": "#AAD8FF",
	    "border-opacity": "0.5",
	    "background-color": "#394855",
	    "text-outline-color": "#394855"
	  }
	}]
});
</script>
<div id="accordion">
	<c:forEach var="variable" items="${requestScope.variables}" >
		<div class="card variable-item">
			<div class="card-header" id="var-${variable.name}-heading">
				<button class="btn btn-link" data-toggle="collapse" data-target="#var-${variable.name}" aria-expanded="false" aia-controls="var-${variable.name}">
					<sling:encode value="${variable.name}" mode="HTML" />
				</button>
			</div>
			<div class="collapse" aria-labelledby="var-${variable.name}-heading" data-parent="#accordion" id="var-${variable.name}">
				<div class="card-body">
					<ul class="list-group">
						<c:forEach var="reference" items="${variable.references}">
							<li class="list-group-item">
								<strong>
									<a href="${reference.link}" target="_blank">
										<sling:encode value="${reference.solution}" mode="HTML" />
									</a>
								</strong>
								<br/>
								<ul>
									<c:forEach var="detail" items="${reference.details}">
										<li>
											<sling:encode value="${detail.key}" mode="HTML" />: <sling:encode value="${detail.value}" mode="HTML" />
										</li>
									</c:forEach>
								</ul>
							</li>
						</c:forEach>
					</ul>
			    </div>
		    </div>
		</div>
	</c:forEach>
</div>