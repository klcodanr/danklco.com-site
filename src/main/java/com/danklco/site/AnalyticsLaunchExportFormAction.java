package com.danklco.site;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

@Component(service = FormAction.class, immediate = true)
public class AnalyticsLaunchExportFormAction implements FormAction {
	private static JsonParser parser = new JsonParser();

	private static final Logger log = LoggerFactory.getLogger(AnalyticsLaunchExportFormAction.class);

	public FormActionResult handleForm(Resource actionResource, FormRequest request) throws FormException {
		try {
			ValueMap formData = request.getFormData();
			String clientId = formData.get("clientId", "");
			String orgId = formData.get("orgId", "");
			String token = formData.get("token", "");
			String reportSuite = formData.get("reportSuite", "");
			String companyId = formData.get("launchProperty", "").split("::")[0];
			String propertyId = formData.get("launchProperty", "").split("::")[1];
			String companyName = formData.get("companyName", "");

			Map<String, AnalyticsVariable> variables = new HashMap<>();

			String analyticsLink = String.format(
					"https://analytics-discovery.adobe.net/1.0/loginRedirect?allow_project_redirect=1&IMS=1&company=%s&current_org=%s",
					companyName, orgId);

			loadAnalyticsVariables(variables, reportSuite, "Evars", analyticsLink, token);
			loadAnalyticsVariables(variables, reportSuite, "Events", analyticsLink, token);
			loadAnalyticsVariables(variables, reportSuite, "Props", analyticsLink, token);

			String launchUrlBase = String.format("https://launch.adobe.com/companies/%s/properties/%s/", companyId,
					propertyId);

			loadLaunchExtension(variables, "https://reactor.adobe.io/properties/" + propertyId + "/extensions",
					clientId, orgId, token, launchUrlBase);
			loadLaunchRules(variables, "https://reactor.adobe.io/properties/" + propertyId + "/rules", clientId, orgId,
					token, launchUrlBase);

			List<AnalyticsVariable> vars = new ArrayList<>();
			vars.addAll(variables.values());
			Collections.sort(vars, new Comparator<AnalyticsVariable>() {
				@Override
				public int compare(AnalyticsVariable o1, AnalyticsVariable o2) {
					return o1.getVariableName().compareTo(o2.getVariableName());
				}

			});
			request.getOriginalRequest().setAttribute("variables", vars);

		} catch (IOException e) {
			throw new FormException("Failed to call Adobe I/O", e);
		}
		return FormActionResult.success("Successfully authenticated with Adobe I/O");
	}

	private void loadLaunchRules(Map<String, AnalyticsVariable> variables, String url, String clientId, String orgId,
			String token, String linkBase) throws MalformedURLException, IOException {
		log.trace("loadLaunchExtension({})", url);
		String responseStr = AdobeIOUtil.adobeIOGetRequest(url, clientId, orgId, token);
		JsonObject response = parser.parse(responseStr).getAsJsonObject();
		JsonArray data = response.get("data").getAsJsonArray();
		for (int i = 0; i < data.size(); i++) {
			JsonObject rule = data.get(i).getAsJsonObject();
			String id = rule.get("id").getAsString();

			JsonObject ruleAttributes = rule.get("attributes").getAsJsonObject();
			String ruleName = ruleAttributes.get("name").getAsString();

			if (ruleEnabled(ruleAttributes)) {

				log.debug("Handling rule {}", ruleName);

				String componentsStr = AdobeIOUtil.adobeIOGetRequest(
						"https://reactor.adobe.io/rules/" + id + "/rule_components", clientId, orgId, token);
				JsonArray components = parser.parse(componentsStr).getAsJsonObject().get("data").getAsJsonArray();
				components.forEach(component -> {
					JsonObject attributes = component.getAsJsonObject().get("attributes").getAsJsonObject();
					if ("adobe-analytics::actions::set-variables"
							.equals(attributes.get("delegate_descriptor_id").getAsString())) {
						String settingsStr = attributes.get("settings").getAsString();
						loadAnalyticsExtensionSettings(variables, "Rule: " + ruleName, linkBase + "rules/" + id,
								parser.parse(settingsStr).getAsJsonObject());
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
			loadLaunchExtension(variables, nextPage, clientId, orgId, token, linkBase);
		}
	}

	private boolean ruleEnabled(JsonObject attr) {
		return attr.get("enabled").getAsBoolean() || attr.get("published").getAsBoolean();
	}

	private void loadLaunchExtension(Map<String, AnalyticsVariable> variables, String url, String clientId,
			String orgId, String token, String linkBase) throws MalformedURLException, IOException {
		log.trace("loadLaunchExtension({})", url);
		String responseStr = AdobeIOUtil.adobeIOGetRequest(url, clientId, orgId, token);
		JsonObject response = parser.parse(responseStr).getAsJsonObject();
		response.get("data").getAsJsonArray().forEach(extension -> {
			String id = extension.getAsJsonObject().get("id").getAsString();
			JsonObject attributes = extension.getAsJsonObject().get("attributes").getAsJsonObject();
			String name = attributes.get("name").getAsString();
			log.debug("Processing extension: {}", name);
			if ("adobe-analytics".equals(name)) {
				String settingsStr = attributes.get("settings").getAsString();
				loadAnalyticsExtensionSettings(variables, "Extension: " + name, linkBase + "extensions/" + id,
						parser.parse(settingsStr).getAsJsonObject());
				return;
			}
		});
		String nextPage = null;
		JsonElement el = response.get("meta").getAsJsonObject().get("pagination").getAsJsonObject().get("next_page");
		if (!el.isJsonNull()) {
			nextPage = el.getAsString();
		}

		if (StringUtils.isNotBlank(nextPage)) {
			loadLaunchExtension(variables, nextPage, clientId, orgId, token, linkBase);
		}
	}

	private void loadAnalyticsExtensionSettings(Map<String, AnalyticsVariable> variables, String referenceName,
			String link, JsonObject settings) {
		log.trace("loadAnalyticsExtensionSettings({})", settings);
		if (settings.has("trackerProperties")) {
			JsonObject trackerSettings = settings.get("trackerProperties").getAsJsonObject();
			if (trackerSettings.has("eVars")) {
				handleVars(variables, referenceName, link, trackerSettings.get("eVars").getAsJsonArray());
			}
			if (trackerSettings.has("props")) {
				handleVars(variables, referenceName, link, trackerSettings.get("props").getAsJsonArray());
			}
			if (trackerSettings.has("events")) {
				handleVars(variables, referenceName, link, trackerSettings.get("events").getAsJsonArray());
			}
		}
	}

	private void handleVars(Map<String, AnalyticsVariable> variables, String referenceName, String link,
			JsonArray vars) {
		vars.forEach(v -> {
			JsonObject var = v.getAsJsonObject();
			String name = var.get("name").getAsString().toLowerCase();
			if (name.startsWith("evar") || name.startsWith("prop") || name.startsWith("event")) {
				if (!variables.containsKey(name)) {
					variables.put(name, new AnalyticsVariable(name));
				}
				VariableReference reference = new VariableReference("Launch", link);
				reference.getDetails().put("Reference Name", referenceName);
				var.entrySet().stream().filter(e -> !e.getValue().isJsonNull())
						.forEach(e -> reference.getDetails().put(e.getKey(), e.getValue().getAsString()));
				variables.get(name).getReferences().add(reference);
			} else {
				log.debug("Ignoring non-custom variable: " + name);
			}
		});
	}

	private void loadAnalyticsVariables(Map<String, AnalyticsVariable> variables, String reportSuite, String type,
			String analyticsLink, String token) throws IOException {
		log.trace("loadAnalyticsVariables({})", type);

		JsonObject req = new JsonObject();
		JsonArray rs = new JsonArray();
		rs.add(new JsonPrimitive(reportSuite));
		req.add("rsid_list", rs);
		String response = AdobeIOUtil.adobeIOPostRequest(
				"https://api.omniture.com/admin/1.4/rest/?method=ReportSuite.Get" + type, req.toString(), token);

		JsonArray vars = parser.parse(response).getAsJsonArray().get(0).getAsJsonObject().get(type.toLowerCase())
				.getAsJsonArray();
		vars.forEach(v -> {
			JsonObject data = v.getAsJsonObject();
			String name = data.get("id").getAsString().toLowerCase();

			if (enabled(data) && (name.startsWith("evar") || name.startsWith("prop") || name.startsWith("event"))) {
				log.debug("Adding variable {}", name);
				AnalyticsVariable var = new AnalyticsVariable(name);

				VariableReference ref = new VariableReference("Analytics", analyticsLink);
				data.entrySet().stream().filter(e -> !e.getValue().isJsonNull())
						.forEach(e -> ref.getDetails().put(e.getKey(), e.getValue().toString()));
				var.getReferences().add(ref);
				variables.put(name, var);
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
