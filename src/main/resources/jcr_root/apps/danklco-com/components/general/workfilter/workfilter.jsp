<%@include file="/libs/sling-cms/global.jsp"%>
<form id="content-filter-form" data-target="${properties.target}">
    <label for="content-filter">${sling:encode(properties.title,'HTML')}</label>
    <div class="input-group">
        <input type="text" placeholder="Filter..." name="content-filter" id="content-filter" class="form-control" />
        <span class="input-group-btn">
            <button class="btn btn-default content-filter-clear" type="button">
                <em class="fa fa-close">
                    <span class="sr-only">Clear Filter</span>
                </em>
            </button>
        </span>
    </div><br>
    <p>
        <small class="help-block"></small>
    </p>
</form>