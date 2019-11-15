package com.danklco.site;

public class Edge extends Element {

	public static Edge connect(String sourceId, String targetId, String name) {
		return new Edge(sourceId, targetId, name);
	}

	private final String source;

	private final String target;

	private Edge(String sourceId, String targetId, String name) {
		super("e__" + sourceId + "__" + targetId, name);
		this.source = sourceId;
		this.target = targetId;
	}

	public String getSource() {
		return source;
	}

	public String getTarget() {
		return target;
	}

}
