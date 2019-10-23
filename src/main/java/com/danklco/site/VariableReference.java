package com.danklco.site;

import java.util.HashMap;
import java.util.Map;

public class VariableReference {

	private final String solution;
	private final Map<String, String> details = new HashMap<>();

	public VariableReference(String solution) {
		this.solution = solution;
	}

	public String getSolution() {
		return solution;
	}

	public Map<String, String> getDetails() {
		return details;
	}
}
