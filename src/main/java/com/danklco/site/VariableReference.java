package com.danklco.site;

import java.util.HashMap;
import java.util.Map;

public class VariableReference {

	private final Map<String, String> details = new HashMap<>();
	private final String link;
	private final String solution;

	public VariableReference(String solution, String link) {
		this.solution = solution;
		this.link = link;
	}

	public Map<String, String> getDetails() {
		return details;
	}

	public String getLink() {
		return link;
	}

	public String getSolution() {
		return solution;
	}
}
