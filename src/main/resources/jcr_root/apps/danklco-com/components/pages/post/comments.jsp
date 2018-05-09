<%@include file="/libs/sling-cms/global.jsp"%>
<sling:adaptTo var="pageMgr" adaptable="${resource}" adaptTo="org.apache.sling.cms.core.models.PageManager" />
<hr class="large"/>
<div class="comments">
    <div id="disqus_thread"></div>
    <script type="text/javascript">
    /* CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE */
    var disqus_shortname = 'danklco';
    var disqus_url = 'https://www.danklco.com${fn:replace(pageMgr.page.path,'/content/personal-sites/danklco-com','')}.html';
    /* DON'T EDIT BELOW THIS LINE */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="//disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="https://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
</div>