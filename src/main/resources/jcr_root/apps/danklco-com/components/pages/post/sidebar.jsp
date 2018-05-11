<%@include file="/libs/sling-cms/global.jsp"%>
<a class="btn btn-inverse btn-lg" href="/content/personal-sites/danklco-com/feed.xml" rel="alternate" type="application/rss+xml" >
	<em class="fa fa-rss"></em> Follow My Blog Posts
</a>
<hr/>
<h3>More Posts</h3>
<div class="tabs">    
	<ul class="nav nav-tabs">
	    <li class="nav-item"><a class="nav-link active" href="#relatedPosts" data-toggle="tab"><span class="fa fa-star"></span> Related</a></li>
	    <li class="nav-item"><a class="nav-link" href="#recentPosts" data-toggle="tab"><span class="fa fa-clock-o"></span> Recent</a></li>
	</ul>
	<div class="tab-content">
	    <div class="tab-pane active" id="relatedPosts">
	        <sling:include path="related-posts" resourceType="danklco-com/components/lists/related-posts" />
	    </div>
	    <div class="tab-pane" id="recentPosts">
	        <sling:include path="recent-posts" resourceType="danklco-com/components/lists/recent-posts" />
	    </div>
	</div>
</div>
<hr />
<sling:include path="twitter" resourceType="danklco-com/components/general/twitter" />