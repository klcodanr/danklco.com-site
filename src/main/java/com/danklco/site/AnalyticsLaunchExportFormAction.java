package com.danklco.site;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.cms.reference.forms.FormAction;
import org.apache.sling.cms.reference.forms.FormActionResult;
import org.apache.sling.cms.reference.forms.FormException;
import org.apache.sling.cms.reference.forms.FormRequest;
import org.osgi.service.component.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

@Component(service = FormAction.class, immediate = true)
public class AnalyticsLaunchExportFormAction implements FormAction {
	private static JsonParser parser = new JsonParser();

	private static final Logger log = LoggerFactory.getLogger(AnalyticsLaunchExportFormAction.class);

	private class RequestData {
		public String clientId;
		public String orgId;
		public String token;
		public String reportSuite;
		public String companyId;
		public String propertyId;
		public String companyName;
		public List<Element> elements = new ArrayList<>();
		public String analyticsLink;
		public Map<String, AnalyticsVariable> variables = new HashMap<>();
		public String launchUrlBase;

	}

	public FormActionResult handleForm(Resource actionResource, FormRequest request) throws FormException {
		try {
			RequestData requestData = new RequestData();
			ValueMap formData = request.getFormData();
			requestData.clientId = formData.get("clientId", "");
			requestData.orgId = formData.get("orgId", "");
			requestData.token = formData.get("token", "");
			requestData.reportSuite = formData.get("reportSuite", "");
			requestData.companyId = formData.get("launchProperty", "").split("::")[0];
			requestData.propertyId = formData.get("launchProperty", "").split("::")[1];
			requestData.companyName = formData.get("companyName", "");
			requestData.launchUrlBase = String.format("https://launch.adobe.com/companies/%s/properties/%s/",
					requestData.companyId, requestData.propertyId);
			requestData.analyticsLink = String.format(
					"https://analytics-discovery.adobe.net/1.0/loginRedirect?allow_project_redirect=1&IMS=1&company=%s&current_org=%s",
					requestData.companyName, requestData.orgId);

			Node company = Node.create("Company", requestData.companyId, "Company");
			requestData.elements.add(company);

			Node analytics = Node.create("Analytics", requestData.reportSuite,
					"Analytics Report Suite: " + requestData.reportSuite);
			requestData.elements.add(analytics);
			requestData.elements.add(Edge.connect(company.getId(), analytics.getId(),
					requestData.companyId + " > " + requestData.reportSuite));

			loadAnalyticsVariables(requestData, "Evars");
			loadAnalyticsVariables(requestData, "Events");
			loadAnalyticsVariables(requestData, "Props");

			Node launch = Node.create("Launch", requestData.propertyId, "Launch Property: " + requestData.propertyId);
			requestData.elements.add(launch);
			requestData.elements.add(Edge.connect(company.getId(), launch.getId(),
					requestData.companyId + " > " + requestData.propertyId));

			loadLaunchExtension(requestData,
					"https://reactor.adobe.io/properties/" + requestData.propertyId + "/extensions");
			loadLaunchRules(requestData, "https://reactor.adobe.io/properties/" + requestData.propertyId + "/rules");
			List<AnalyticsVariable> vars = new ArrayList<>();
			vars.addAll(requestData.variables.values());
			Collections.sort(vars, new Comparator<AnalyticsVariable>() {
				@Override
				public int compare(AnalyticsVariable o1, AnalyticsVariable o2) {
					return o1.getVariableName().compareTo(o2.getVariableName());
				}

			});
			request.getOriginalRequest().setAttribute("variables", vars);
			Set<String> validIds = new HashSet<>();
			JsonArray arr = new JsonArray();
			requestData.elements.forEach(e -> {
				JsonObject element = new JsonObject();
				if (e instanceof Edge) {
					element.addProperty("group", "edges");

				} else {
					element.addProperty("group", "nodes");
					element.addProperty("classes", e.getId().replace("__", " "));
				}
				element.add("data", new Gson().toJsonTree(e));
				arr.add(element);
				validIds.add(e.getId());
			});
			requestData.elements.stream().filter(e -> e instanceof Edge).map(e -> (Edge) e)
					.filter(e -> !validIds.contains(e.getTarget())).map(Edge::getTarget).forEach(id -> {
						JsonObject element = new JsonObject();
						element.addProperty("group", "nodes");
						element.addProperty("classes", "missing");
						JsonObject data = new JsonObject();
						data.addProperty("id", id);
						data.addProperty("name", "Missing element " + id + "!");
						element.add("data", data);
						arr.add(element);
					});
			request.getOriginalRequest().setAttribute("elements", arr.toString());

		} catch (IOException e) {
			throw new FormException("Failed to call Adobe I/O", e);
		}
		return FormActionResult.success("Successfully authenticated with Adobe I/O");
	}

	private void loadLaunchRules(RequestData requestData, String url) throws IOException {
		log.trace("loadLaunchExtension({})", url);
		String responseStr = AdobeIOUtil.adobeIOGetRequest(url, requestData.clientId, requestData.orgId,
				requestData.token);
		JsonObject response = parser.parse(responseStr).getAsJsonObject();
		JsonArray data = response.get("data").getAsJsonArray();
		for (int i = 0; i < data.size(); i++) {
			JsonObject rule = data.get(i).getAsJsonObject();
			String id = rule.get("id").getAsString();

			JsonObject ruleAttributes = rule.get("attributes").getAsJsonObject();
			String ruleName = ruleAttributes.get("name").getAsString();

			if (ruleEnabled(ruleAttributes)) {

				log.debug("Handling rule {}", ruleName);

				Node en = Node.create("Launch Rule", id, ruleName);
				requestData.elements.add(en);
				requestData.elements.add(Edge.connect(Node.getId("Launch", requestData.propertyId), en.getId(),
						"Launch Property " + requestData.propertyId + " includes Rule " + ruleName));

				String componentsStr = AdobeIOUtil.adobeIOGetRequest(
						"https://reactor.adobe.io/rules/" + id + "/rule_components", requestData.clientId,
						requestData.orgId, requestData.token);
				JsonArray components = parser.parse(componentsStr).getAsJsonObject().get("data").getAsJsonArray();
				components.forEach(component -> {
					JsonObject attributes = component.getAsJsonObject().get("attributes").getAsJsonObject();
					if ("adobe-analytics::actions::set-variables"
							.equals(attributes.get("delegate_descriptor_id").getAsString())) {
						String settingsStr = attributes.get("settings").getAsString();
						loadAnalyticsExtensionSettings(requestData, "Rule: " + ruleName, en.getId(),
								requestData.launchUrlBase + "rules/" + id, parser.parse(settingsStr).getAsJsonObject());
					}
				});
			} else {
				log.debug("Skipping rule {} as it is not enabled or published", ruleName);
			}
		}
		String nextPage = null;
		JsonElement el = response.get("meta").getAsJsonObject().get("pagination").getAsJsonObject().get("next_page");
		if (!el.isJsonNull()) {
			nextPage = el.getAsString();
		}
		if (StringUtils.isNotBlank(nextPage)) {
			loadLaunchRules(requestData, nextPage);
		}
	}

	private boolean ruleEnabled(JsonObject attr) {
		return attr.get("enabled").getAsBoolean() || attr.get("published").getAsBoolean();
	}

	private void loadLaunchExtension(RequestData requestData, String url) throws IOException {
		log.trace("loadLaunchExtension({})", url);
		String responseStr = AdobeIOUtil.adobeIOGetRequest(url, requestData.clientId, requestData.orgId,
				requestData.token);
		JsonObject response = parser.parse(responseStr).getAsJsonObject();
		response.get("data").getAsJsonArray().forEach(extension -> {
			String id = extension.getAsJsonObject().get("id").getAsString();
			JsonObject attributes = extension.getAsJsonObject().get("attributes").getAsJsonObject();
			String name = attributes.get("name").getAsString();

			Node en = Node.create("Launch Extension", id, name);
			requestData.elements.add(en);
			requestData.elements.add(Edge.connect(Node.getId("Launch", requestData.propertyId), en.getId(),
					"Launch Property " + requestData.propertyId + " includes Extension " + name));

			log.debug("Processing extension: {}", name);
			if ("adobe-analytics".equals(name)) {
				String settingsStr = attributes.get("settings").getAsString();
				loadAnalyticsExtensionSettings(requestData, "Extension: " + name, en.getId(),
						requestData.launchUrlBase + "extensions/" + id, parser.parse(settingsStr).getAsJsonObject());

			}
		});
		String nextPage = null;
		JsonElement el = response.get("meta").getAsJsonObject().get("pagination").getAsJsonObject().get("next_page");
		if (!el.isJsonNull()) {
			nextPage = el.getAsString();
		}

		if (StringUtils.isNotBlank(nextPage)) {
			loadLaunchExtension(requestData, nextPage);
		}
	}

	private void loadAnalyticsExtensionSettings(RequestData requestData, String referenceName, String sourceId,
			String link, JsonObject settings) {
		log.trace("loadAnalyticsExtensionSettings({})", settings);
		if (settings.has("trackerProperties")) {
			JsonObject trackerSettings = settings.get("trackerProperties").getAsJsonObject();
			if (trackerSettings.has("eVars")) {
				handleVars(requestData, referenceName, sourceId, link, trackerSettings.get("eVars").getAsJsonArray());
			}
			if (trackerSettings.has("props")) {
				handleVars(requestData, referenceName, sourceId, link, trackerSettings.get("props").getAsJsonArray());
			}
			if (trackerSettings.has("events")) {
				handleVars(requestData, referenceName, sourceId, link, trackerSettings.get("events").getAsJsonArray());
			}
		}
	}

	private void handleVars(RequestData requestData, String referenceName, String sourceId, String link,
			JsonArray vars) {
		vars.forEach(v -> {
			JsonObject var = v.getAsJsonObject();
			String name = var.get("name").getAsString().toLowerCase();
			if (name.startsWith("evar") || name.startsWith("prop") || name.startsWith("event")) {
				if (!requestData.variables.containsKey(name)) {
					requestData.variables.put(name, new AnalyticsVariable(name));
				}
				VariableReference reference = new VariableReference("Launch", link);
				reference.getDetails().put("Reference Name", referenceName);
				var.entrySet().stream().filter(e -> !e.getValue().isJsonNull())
						.forEach(e -> reference.getDetails().put(e.getKey(), e.getValue().getAsString()));
				requestData.variables.get(name).getReferences().add(reference);

				requestData.elements.add(Edge.connect(sourceId, Node.getId("Analytics", name),
						sourceId + " references Analytics item " + name));
			} else {
				log.debug("Ignoring non-custom variable: {}", name);
			}
		});
	}

	private void loadAnalyticsVariables(RequestData requestData, String type) throws IOException {
		log.trace("loadAnalyticsVariables({})", type);

		JsonObject req = new JsonObject();
		JsonArray rs = new JsonArray();
		rs.add(new JsonPrimitive(requestData.reportSuite));
		req.add("rsid_list", rs);
		String response = AdobeIOUtil.adobeIOPostRequest(
				"https://api.omniture.com/admin/1.4/rest/?method=ReportSuite.Get" + type, req.toString(),
				requestData.token);

		JsonArray vars = parser.parse(response).getAsJsonArray().get(0).getAsJsonObject().get(type.toLowerCase())
				.getAsJsonArray();
		vars.forEach(v -> {
			JsonObject data = v.getAsJsonObject();
			String name = data.get("id").getAsString().toLowerCase();

			if (enabled(data) && (name.startsWith("evar") || name.startsWith("prop") || name.startsWith("event"))) {
				log.debug("Adding variable {}", name);
				AnalyticsVariable var = new AnalyticsVariable(name);

				VariableReference ref = new VariableReference("Analytics", requestData.analyticsLink);
				data.entrySet().stream().filter(e -> !e.getValue().isJsonNull())
						.forEach(e -> ref.getDetails().put(e.getKey(), e.getValue().toString()));
				var.getReferences().add(ref);
				requestData.variables.put(name, var);

				Node variable = Node.create("Analytics", var.getName(), var.getName());
				requestData.elements.add(variable);
				requestData.elements.add(Edge.connect(Node.getId("Analytics", requestData.reportSuite),
						variable.getId(), var.getName() + " belongs to " + requestData.reportSuite));
			} else {
				log.debug("Variable {} is not enabled / custom", name);
			}
		});
	}

	private boolean enabled(JsonObject data) {
		boolean enabled = true;
		if (data.has("type") && "disabled".equals(data.get("type").getAsString())) {
			enabled = false;
		}
		if (data.has("enabled") && data.get("enabled").getAsBoolean() == false) {
			enabled = false;
		}
		return enabled;
	}

	public boolean handles(Resource actionResource) {
		return "danklco-com/components/form/analyticslaunchexport".equals(actionResource.getResourceType());
	}

}
