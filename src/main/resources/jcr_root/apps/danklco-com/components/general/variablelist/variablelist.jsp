<%@include file="/libs/sling-cms/global.jsp"%>
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
								<strong><sling:encode value="${reference.solution}" mode="HTML" /></strong><br/>
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