package com.danklco.site;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VariableName implements Comparable<VariableName> {
	private static final Logger log = LoggerFactory.getLogger(VariableName.class);

	public String getType() {
		return type;
	}

	public int getIndex() {
		return index;
	}

	private static final Pattern PATTERN = Pattern.compile("^(event|prop|evar)([0-9]+)$");

	public final String type;
	public final int index;

	public VariableName(String name) {
		log.trace("VariableName({})", name);
		Matcher matcher = PATTERN.matcher(name.toLowerCase());
		if (matcher.matches()) {
			type = matcher.group(1);
			index = Integer.parseInt(matcher.group(2), 10);
		} else {
			throw new RuntimeException("Java Regex's suck");
		}
	}

	@Override
	public int compareTo(VariableName o) {
		if (!o.getType().equals(type)) {
			return type.compareTo(o.type);
		} else {
			return index - o.index;
		}
	}
}
