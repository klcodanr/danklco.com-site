package com.danklco.internal;

import java.io.IOException;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.StringSubstitutor;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.metatype.annotations.AttributeDefinition;
import org.osgi.service.metatype.annotations.AttributeType;
import org.osgi.service.metatype.annotations.Designate;
import org.osgi.service.metatype.annotations.ObjectClassDefinition;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.danklco.internal.ContactEmail.Config;

/**
 * Servlet for sending emails.
 * 
 * @author dan.klco
 */
@Component(service = Servlet.class, property = { "sling.servlet.methods=POST",
		"sling.servlet.resourceTypes=danklco-com/components/general/contact", "sling.servlet.selectors=allowpost" })
@Designate(ocd = Config.class)
public class ContactEmail extends SlingAllMethodsServlet {

	@ObjectClassDefinition(name = "Contact Email Configuration")
	public @interface Config {

		@AttributeDefinition(name = "SMTP Host")
		String host();

		@AttributeDefinition(name = "SMTP Password", type = AttributeType.PASSWORD)
		String password();

		@AttributeDefinition(name = "SMTP Port")
		String port();

		@AttributeDefinition(name = "SMTP Username")
		String username();
	}

	private static final long serialVersionUID = 7308004761024147882L;

	public static final String PN_ID_STAMP = "idstamp";

	private static final Logger log = LoggerFactory.getLogger(ContactEmail.class);

	private static final String[] IP_HEADER_CANDIDATES = { "X-Forwarded-For", "Proxy-Client-IP", "WL-Proxy-Client-IP",
			"HTTP_X_FORWARDED_FOR", "HTTP_X_FORWARDED", "HTTP_X_CLUSTER_CLIENT_IP", "HTTP_CLIENT_IP",
			"HTTP_FORWARDED_FOR", "HTTP_FORWARDED", "HTTP_VIA", "REMOTE_ADDR" };

	public static String getClientIpAddress(HttpServletRequest request) {
		for (String header : IP_HEADER_CANDIDATES) {
			String ip = request.getHeader(header);
			if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
				return ip;
			}
		}
		return request.getRemoteAddr();
	}

	private transient Config config;

	@Activate
	public void activate(Config config) {
		this.config = config;
	}

	@Override
	protected void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {

		ValueMap properties = request.getResource().getValueMap();
		String hp = "tigger";
		String honeypot = request.getParameter("comment");
		if ((honeypot == null || StringUtils.isBlank(honeypot))
				&& properties.get(PN_ID_STAMP, "").equals(request.getParameter(PN_ID_STAMP))) {
			log.debug("Message passed honey pot");
			try {
				sendEmail(request);
			} catch (Exception e) {
				log.error("Failed to send emails!", e);
				response.sendError(500, "Failed to send emails!");
			}
		} else {
			log.warn("Message caught in honey pot, redirecting as though successful");
			hp = "poohbear";
			log.info("Not sending email with payload {} from {}", toFlatMap(request),
					getClientIpAddress(request));
		}

		String redirectTarget = request.getResourceResolver().map(properties.get("redirect", "")) + ".html?hp=" + hp;
		response.sendRedirect(redirectTarget);

	}

	public void sendEmail(SlingHttpServletRequest request) throws MessagingException {

		// Read the form fields
		String from = request.getParameter("email");

		// load the parameters
		String host = config.host();
		String port = config.port();
		String username = config.username();
		String password = config.password();

		// Get system properties
		Properties properties = System.getProperties();

		// configure the mail connection
		properties.put("mail.smtp.port", port);
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", true);
		log.debug("Sending emails through server {}:{} with user {}", host, port, username);

		Authenticator auth = new Authenticator() {
			@Override
			public PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		};
		Session session = Session.getDefaultInstance(properties, auth);

		ValueMap rProperties = request.getResource().getValueMap();
		Map<String, String> params = toFlatMap(request);
		StringSubstitutor sub = new StringSubstitutor(params);

		String recipient = rProperties.get("recipient", String.class);
		log.info("Sending message to {}", recipient);

		MimeMessage message = new MimeMessage(session);
		message.setFrom(new InternetAddress(from));
		message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
		String msgSubject = sub.replace(rProperties.get("msgSubjectTpl", String.class));
		log.debug("Sending subject: {}", msgSubject);
		message.setSubject(msgSubject);
		String msgTpl = sub.replace(rProperties.get("msgTpl", String.class));
		log.debug("Sending message: {}", msgTpl);
		message.setText(msgTpl);
		Transport.send(message);
		log.info("Message sent successfully!");

		log.info("Sending confirmation to {}", from);
		MimeMessage conf = new MimeMessage(session);
		conf.setFrom(new InternetAddress(recipient));
		conf.addRecipient(Message.RecipientType.TO, new InternetAddress(from));
		String confSubject = sub.replace(rProperties.get("confSubjectTpl", String.class));
		log.debug("Sending subject: {}", confSubject);
		conf.setSubject(confSubject);
		String confMsg = sub.replace(rProperties.get("confTpl", String.class));
		log.debug("Sending message: {}", confMsg);
		conf.setText(confMsg);
		Transport.send(conf);
		log.info("Confirmation sent successfully!");
	}

	private Map<String, String> toFlatMap(SlingHttpServletRequest request) {
		return request.getRequestParameterMap().entrySet().stream()
				.collect(Collectors.toMap(Map.Entry::getKey, e -> request.getParameter(e.getKey())));
	}

}
