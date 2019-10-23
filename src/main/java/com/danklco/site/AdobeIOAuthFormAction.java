package com.danklco.site;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
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

@Component(service = FormAction.class, immediate = true)
public class AdobeIOAuthFormAction implements FormAction {
	private static JsonParser parser = new JsonParser();

	private static final Logger log = LoggerFactory.getLogger(AdobeIOAuthFormAction.class);

	public FormActionResult handleForm(Resource actionResource, FormRequest request) throws FormException {
		try {
			SlingHttpServletRequest slingRequest = request.getOriginalRequest();

			String clientId = request.getFormData().get("clientId", String.class);
			String orgId = request.getFormData().get("orgId", String.class);
			String token = getAccessToken(clientId, request.getFormData().get("clientSecret", String.class),
					request.getFormData().get("jwtToken", String.class));

			slingRequest.setAttribute("clientId", clientId);
			slingRequest.setAttribute("orgId", orgId);
			slingRequest.setAttribute("token", token);
			slingRequest.setAttribute("reportSuites", getReportSuites(token));
			slingRequest.setAttribute("launchProperties", getProperties(clientId, orgId, token));

		} catch (IOException e) {
			throw new FormException("Failed to authenticate with Adobe I/O", e);
		}
		return FormActionResult.success("Successfully authenticated with Adobe I/O");
	}

	public boolean handles(Resource actionResource) {
		return "danklco-com/components/form/adobeioauth".equals(actionResource.getResourceType());
	}

	private String getAccessToken(String clientId, String clientSecret, String jwtToken) throws IOException {

		log.debug("Getting access token");

		HttpURLConnection con = null;
		try {
			con = (HttpURLConnection) new URL("https://ims-na1.adobelogin.com/ims/exchange/jwt/").openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			con.setUseCaches(false);
			con.setDoInput(true);
			con.setDoOutput(true);

			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
			wr.write("client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8.toString()) + "&client_secret="
					+ URLEncoder.encode(clientSecret, StandardCharsets.UTF_8.toString()) + "&jwt_token="
					+ URLEncoder.encode(jwtToken, StandardCharsets.UTF_8.toString()));
			wr.flush();
			int rc = con.getResponseCode();
			if (rc == 200 || rc == 201) {
				try (InputStream in = con.getInputStream()) {
					String res = IOUtils.toString(in, StandardCharsets.UTF_8);
					log.debug("Retrieved access token response: {}", res);
					JsonElement json = parser.parse(res);
					String accessToken = json.getAsJsonObject().get("access_token").getAsString();
					log.debug("Retrieved access token: {}", accessToken);
					return accessToken;
				}
			} else {
				throw new IOException("Failed to retrieve Access token, error code: " + rc);
			}
		} finally {
			con.disconnect();
		}

	}

	private List<Entry<String, String>> getPropertiesFromCompany(String companyId, String clientId, String orgId,
			String token) throws IOException {
		log.debug("getPropertiesFromCompany {}", companyId);
		List<Entry<String, String>> properties = new ArrayList<Entry<String, String>>();

		String res = AdobeIOUtil.adobeIOGetRequest("https://reactor.adobe.io/companies/" + companyId + "/properties",
				clientId, orgId, token);
		log.debug("Retrieved : {}", res);
		JsonElement json = parser.parse(res);
		JsonArray arr = json.getAsJsonObject().get("data").getAsJsonArray();
		for (int i = 0; i < arr.size(); i++) {
			JsonObject property = arr.get(i).getAsJsonObject();
			properties.add(new ImmutablePair<String, String>(
					property.get("attributes").getAsJsonObject().get("name").getAsString(),
					property.get("id").getAsString()));
		}
		log.debug("Loaded properties: {}", properties);
		return properties;
	}

	private List<Entry<String, String>> getProperties(String clientId, String orgId, String token) throws IOException {
		log.debug("getCompaniesAndProperties");
		List<Entry<String, String>> properties = new ArrayList<Entry<String, String>>();

		String res = AdobeIOUtil.adobeIOGetRequest("https://reactor.adobe.io/companies", clientId, orgId, token);
		log.debug("Retrieved : {}", res);
		JsonElement json = parser.parse(res);
		JsonArray arr = json.getAsJsonObject().get("data").getAsJsonArray();
		for (int i = 0; i < arr.size(); i++) {
			JsonObject property = arr.get(i).getAsJsonObject();
			String id = property.get("id").getAsString();
			String name = property.get("attributes").getAsJsonObject().get("name").getAsString();

			getPropertiesFromCompany(id, clientId, orgId, token).forEach(p -> {
				properties.add(new AbstractMap.SimpleEntry<String, String>(name + " / " + p.getKey(), p.getValue()));
			});
		}
		log.debug("Loaded properties: {}", properties);
		return properties;

	}

	private List<Entry<String, String>> getReportSuites(String token) throws IOException {

		log.debug("Getting report suites");
		List<Entry<String, String>> reportSuites = new ArrayList<Entry<String, String>>();

		String res = AdobeIOUtil.adobeIOGetRequest(
				"https://api.omniture.com/admin/1.4/rest/?method=Company.GetReportSuites", null, null, token);
		log.debug("Retrieved : {}", res);
		JsonElement json = parser.parse(res);
		JsonArray arr = json.getAsJsonObject().get("report_suites").getAsJsonArray();
		for (int i = 0; i < arr.size(); i++) {
			JsonObject rs = arr.get(i).getAsJsonObject();
			reportSuites.add(new AbstractMap.SimpleEntry<String, String>(rs.get("site_title").getAsString(),
					rs.get("rsid").getAsString()));
		}
		log.debug("Loaded report suites: {}", reportSuites);
		return reportSuites;

	}

}
