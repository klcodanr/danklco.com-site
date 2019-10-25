package com.danklco.site;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AdobeIOUtil {
	private static final Logger log = LoggerFactory.getLogger(AdobeIOUtil.class);

	public static final String adobeIOGetRequest(String url, String clientId, String orgId, String token)
			throws MalformedURLException, IOException {
		log.debug("adobeIOGetRequest({},{},{},TOKEN)", url, clientId, orgId);
		HttpURLConnection con = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();

			con.setRequestProperty("Authorization", "Bearer " + token);
			con.setRequestProperty("Cache-Control", "nocache");
			con.setRequestProperty("Connection", "keep-alive");
			con.setRequestProperty("Accept", "application/vnd.api+json;revision=1");
			con.setRequestProperty("Content-Type", "application/vnd.api+json");
			if (clientId != null) {
				con.setRequestProperty("X-Api-Key", clientId);
			}
			if (orgId != null) {
				con.setRequestProperty("X-Gw-Ims-Org-Id", orgId);
			}
			con.setUseCaches(false);
			int rc = con.getResponseCode();
			if (rc == 200) {
				try (InputStream is = con.getInputStream()) {
					return IOUtils.toString(is, StandardCharsets.UTF_8);
				}
			} else {
				try (InputStream is = con.getErrorStream()) {
					log.debug(IOUtils.toString(is, StandardCharsets.UTF_8));
				}
				throw new IOException("Failed to invoke Adobe I/O API: " + rc);
			}
		} finally {
			if (con != null) {
				con.disconnect();
			}
		}
	}
	

	public static final String adobeIOGetRequestWithoutTypes(String url, String clientId, String orgId, String token)
			throws MalformedURLException, IOException {
		log.debug("adobeIOGetRequest({},{},{},TOKEN)", url, clientId, orgId);
		HttpURLConnection con = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();

			con.setRequestProperty("Authorization", "Bearer " + token);
			con.setRequestProperty("Cache-Control", "nocache");
			con.setRequestProperty("Connection", "keep-alive");
			if (clientId != null) {
				con.setRequestProperty("X-Api-Key", clientId);
			}
			if (orgId != null) {
				con.setRequestProperty("X-Gw-Ims-Org-Id", orgId);
			}
			con.setUseCaches(false);
			int rc = con.getResponseCode();
			if (rc == 200) {
				try (InputStream is = con.getInputStream()) {
					return IOUtils.toString(is, StandardCharsets.UTF_8);
				}
			} else {
				try (InputStream is = con.getErrorStream()) {
					log.debug(IOUtils.toString(is, StandardCharsets.UTF_8));
				}
				throw new IOException("Failed to invoke Adobe I/O API: " + rc);
			}
		} finally {
			if (con != null) {
				con.disconnect();
			}
		}
	}

	public static final String adobeIOPostRequest(String url, String body, String token)
			throws MalformedURLException, IOException {
		log.debug("adobeIOPostRequest({},{},{})", url, body, token);
		HttpURLConnection con = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);
			con.setRequestProperty("Authorization", "Bearer " + token);
			con.setRequestProperty("accept", "application/json");
			con.setRequestProperty("Cache-Control", "nocache");
			con.setRequestProperty("Content-Type", "application/json; utf-8");
			con.setUseCaches(false);
			try (OutputStream os = con.getOutputStream()) {
				os.write(body.getBytes(StandardCharsets.UTF_8));
				os.flush();
				os.close();
				int rc = con.getResponseCode();
				if (rc == 200) {
					try (InputStream is = con.getInputStream()) {
						return IOUtils.toString(is, StandardCharsets.UTF_8);
					}
				} else {
					throw new IOException("Failed to invoke Adobe I/O API: " + rc);
				}
			}
		} finally {
			if (con != null) {
				con.disconnect();
			}
		}
	}

}
