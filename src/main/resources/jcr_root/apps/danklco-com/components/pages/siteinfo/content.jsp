<%@include file="/libs/sling-cms/global.jsp"%>
<% pageContext.setAttribute("newLineChar", "\n"); %> 
<div class="container">
	<div class="row background__white">
		<div class="col-12 py-4">
			<sling:include path="container" resourceType="sling-cms/components/general/container" />
		</div>
	</div>
	<div class="row background__white">
		<div class="col-12 py-4">
			<form method="get" action="">
				<div class="form-group">
					<label for="domains">
						Domains
					</label>
					<textarea name="domains" class="form-control" required="required"><c:forEach var="domain" items="${fn:split(param.domains,newLineChar)}">${sling:encode(domain,'HTML')}${newLineChar}</c:forEach></textarea>
					<small class="text-muted">
						New line separated domains, include root domain only, e.g. google.com
					</small>
				</div>
				<div class="form-group">
					<button class="btn btn-primary" type="submit">Go</button>
				</div>
			</form>
		</div>
	</div>
	<c:if test="${not empty param.domains}">
		<div class="row background__white">
			<div class="col-12 py-4">
				<div class="table-responsive">
					<table class="table table-hover">
						<thead>
							<tr>
								<th scope="col">Domain</th>
								<th scope="col" title="Shows the tools / technologies used to build the site">BuiltWith</th>
								<th scope="col" title="Shows statistics about the site traffic and information about how people get to the site">SimilarWeb</th>
								<th scope="col" title="Runs SEO analysis on the homepage of the site">SEO Analyzer</th>
								<th scope="col" title="Runs speed checks to determine the perceived speed of a site">PageSpeed</th>
								<th scope="col" title="WAVE: Runs accessibility checks on the homepage">Accessibility</th>
								<th scope="col" title="Provided by W3C: Runs a HTML Validator of the homepage">HTML Validator</th>
								<th scope="col" title="Provided by Qualsys: Validates the SSL certificates for the site">SSL Check</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="domain" items="${fn:split(param.domains,newLineChar)}">
								<c:if test="${not empty domain}">
									<tr>
										<td>${sling:encode(domain,'HTML')}</td>
										<td><a href="https://builtwith.com/${sling:encode(domain,'HTML_ATTR')}" target="_blank">BuiltWith</a></td>
										<td><a href="https://www.similarweb.com/website/${sling:encode(domain,'HTML_ATTR')}" target="_blank">SimilarWeb</a></td>
										<td><a href="http://tools.neilpatel.com/en/analyze/${sling:encode(domain,'HTML_ATTR')}" target="_blank">SEO Analyzer</a></td>
										<td><a href="https://developers.google.com/speed/pagespeed/insights/?url=${sling:encode(domain,'HTML_ATTR')}" target="_blank">PageSpeed</a></td>
										<td><a href="http://wave.webaim.org/report#/${sling:encode(domain,'HTML_ATTR')}" target="_blank">Accessibility</a></td>
										<td><a href="https://validator.w3.org/check?charset=%28detect+automatically%29&doctype=Inline&group=0&uri=${sling:encode(domain,'HTML_ATTR')}" target="_blank">HTML Validator</a></td>
										<td><a href="https://www.ssllabs.com/ssltest/analyze.html?latest&d=${sling:encode(domain,'HTML_ATTR')}" target="_blank">SSL Check</a></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</c:if>
</div>