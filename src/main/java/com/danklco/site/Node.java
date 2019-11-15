package com.danklco.site;

public class Node extends Element {

	public static Node create(String service, String variable, String name) {
		return new Node(service, variable, name);
	}

	private Node(String service, String variable, String name) {
		super(getId(service, variable), name);
	}

	public static final String getId(String service, String variable) {
		return "n__" + service.toLowerCase().replace("[^a-z0-9]", "-")
				+ (variable != null ? "__" + variable.toLowerCase().replace("[^a-z0-9]", "-") : "");
	}

}
