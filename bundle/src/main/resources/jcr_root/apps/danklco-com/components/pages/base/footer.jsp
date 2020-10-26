<%@include file="/apps/danklco-com/global.jsp"%>
<footer class="transparent-block-inverse">
	<div class="container">
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy" var="currentYear" />
        Copyright &copy; 2009 - <c:out value="${currentYear}" /> &mdash; Dan Klco
        <form class="form-inline float-right" action="/content/personal-sites/danklco-com/search.html" method="get" title="Site Search">
            <div class="input-group">
                <label for="q" aria-label="q" class="sr-only">Search</label>
                <input class="form-control" name="q" id="q" type="text" placeholder="Search..."/>
                <div class="input-group-append">
                    <button class="btn btn-inverse" type="submit">
                        <span class="fa fa-search"></span>
                        <span class="sr-only">Search</span>
                    </button>
                </div>
            </div>
        </form>
        <br/>
        <hr/>
        <br/>
        <a rel="license noopener" href="http://creativecommons.org/licenses/by-nc-sa/3.0/us/deed.en_US" target="_blank">
            <img alt="Creative Commons License" width="88" height="31" src="/static/clientlibs/danklco-com/img/cc-license.png" />
        </a>
        <div class="float-right" itemscope itemtype="http://schema.org/Person">
            <link itemprop="url" href="https://www.danklco.com" />
            <ul class="nav social-networks">
                <li class="nav-item">
                    <span class="nav-link p-1">
                        <a itemprop="sameAs" href="http://www.linkedin.com/in/danielklco/" target="_blank" rel="noopener" title="Find me on LinkedIn!" class="btn btn-default" data-network="LinkedIn">
                            <em class="fa fa-linkedin" aria-hidden="true"></em><span class="sr-only">Find me on LinkedIn</span>
                        </a>
                    </span>
                </li>
                <li class="nav-item">
                    <span class="nav-link p-1">
                        <a itemprop="sameAs" href="https://twitter.com/KlcoDanR" title="Find me on Twitter!" target="_blank" rel="noopener" class="btn btn-default" data-network="Twitter">
                            <em class="fa fa-twitter" aria-hidden="true"></em><span class="sr-only">Find me on Twitter</span>
                        </a>
                    </span>
                </li>
                <li class="nav-item">
                    <span class="nav-link p-1">
                        <a itemprop="sameAs" href="https://plus.google.com/109214091683324297793?rel=author" target="_blank" rel="noopener" title="Find me on Google Plus!" class="btn btn-default" data-network="Google+">
                            <em class="fa fa-google-plus" aria-hidden="true"></em><span class="sr-only">Find me on Google+</span>
                        </a>
                    </span>
                </li>
                <li class="nav-item">
                    <span class="nav-link p-1">
                        <a itemprop="sameAs" href="https://github.com/klcodanr" title="Find me on GitHub!" target="_blank" rel="noopener" class="btn btn-default" data-network="GitHub">
                            <em class="fa fa-github" aria-hidden="true"></em><span class="sr-only">Find me on GitHub</span>
                        </a>
                    </span>
                </li>
                <li class="nav-item">
                    <span class="nav-link p-1">
                        <a itemprop="sameAs" href="/feed.xml" title="Follow my RSS Feed" target="_blank" rel="noopener" class="btn btn-default" data-network="RSS">
                            <em class="fa fa-rss" aria-hidden="true"></em><span class="sr-only">Follow my RSS Feed</span>
                        </a>
                    </span>
                </li>
            </ul>
        </div>
    </div>
</footer>