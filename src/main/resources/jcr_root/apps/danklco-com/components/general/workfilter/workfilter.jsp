<%@include file="/libs/sling-cms/global.jsp"%>
<form class="work-filter">
    <label for="work-filter">Find Relevant Work</label>
    <div class="input-group">
        <input type="text" placeholder="Filter My Work..." name="work-filter" id="work-filter" class="form-control" />
        <span class="input-group-btn">
            <button class="btn btn-default work-filter-clear" type="button">
                <em class="fa fa-close">
                    <span class="sr-only">Clear Work Filter</span>
                </em>
            </button>
        </span>
    </div><br>
    <p>
        <small class="help-block"></small>
    </p>
</form>