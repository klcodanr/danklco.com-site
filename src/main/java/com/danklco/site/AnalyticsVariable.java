package com.danklco.site;

import java.util.ArrayList;
import java.util.List;

public class AnalyticsVariable {
	private final String name;
	private final List<VariableReference> references = new ArrayList<>();
	private final VariableName variableName;

	public AnalyticsVariable(String name) {
		this.name = name;
		this.variableName = new VariableName(name);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AnalyticsVariable other = (AnalyticsVariable) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

	public String getName() {
		return name;
	}

	public List<VariableReference> getReferences() {
		return references;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	public VariableName getVariableName() {
		return variableName;
	}

}
