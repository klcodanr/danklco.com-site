"use strict";

var _gaq = _gaq || [];
jQuery(function ($) {
	$(document).ready(function () {

		/* Contact form validation */
		$('input,textarea,select').bind('invalid', function (evt) {
			$(evt.target).parent().addClass('has-error');
			$(evt.target).parent().find('.help-block').show().removeClass('hidden');
			return false;
		});
		var validateField = function (event) {
			if (event.target.checkValidity()) {
				$(event.target).parent().removeClass('has-error');
				$(event.target).parent().find('.help-block').hide();
			}
		};
		$('input,textarea,select').blur(validateField).keyup(validateField);

		/* Track Events */
		$('a').click(function () {
			if ($(this).attr('href').indexOf('http') !== -1) {
				_gaq.push(['_trackEvent', 'Outbound Link', 'Click', $(this).attr('href')]);
			}
		});
		$('.footer-search,.gsc-search-box').submit(function () {
			_gaq.push(['_trackEvent', 'Search', 'Search', $(this).find('input[name=q]').val()]);
		});
		$('.social-networks a').click(function () {
			_gaq.push(['_trackEvent', 'Social Link', 'Click', $(this).attr('id')]);
		});
		$('#contact-form').submit(function () {
			_gaq.push(['_trackEvent', 'Contact Form', 'Submit']);
		});

		/* Client Modals on the My Work page */
		$('.client').click(function () {
			var $client = $(this);
			var id = $client.attr('id');
			_gaq.push(['_trackEvent', 'Client', 'Open', id]);
			$('#client-box img').attr('src', $client.attr('data-image')).attr('width', $client.attr('data-image-width'));
			var url = $client.data('url') + ' .engagement-body';
			$('.modal-title').html($client.data('title'));
			$('#client-box .client-content').load(url, function () {
				$('#client-box').show().modal('show');
			});
			return false;
		});

		/* handle pin clicks */
		var pinClick = function (evt) {
			if (evt.target.tagName !== 'A') {
				var $pin = $(this);
				if ($pin.attr('data-url')) {
					_gaq.push(['_trackEvent', 'Pin', 'Click', $(this).attr('href')]);
					if ($pin.attr('data-url').indexOf('http') !== -1) {
						_gaq.push(['_trackEvent', 'Outbound Link', 'Click', $(this).attr('href')]);
						window.open($pin.attr('data-url'), '_blank');
					} else {
						window.location = $pin.attr('data-url');
					}
					return false;
				}
			}
		};
		$('.recent-activity .pin').click(pinClick);

		/* Home page article paging */
		var totalPages = $('.articles-wrapper').attr('data-total-pages');
		var currentPage = 1;
		$('.loader').hide();
		var loadNext = function () {
			var dfd = jQuery.Deferred();
			var $btn = $('.next-page');
			var $ldr = $btn.siblings('.loader');
			window.location.hash = '#!' + $btn.attr('href');
			$btn.hide();
			$ldr.show();
			var link = $btn.attr('href');
			if (currentPage < totalPages) {
				currentPage++;
				$btn.attr('href', '/page' + (currentPage + 1));
			} else {
				$btn.attr('disabled', 'disabled');
			}
			$("<div>").load(link + " .articles-wrapper", function () {
				$(".recent-activity").append($(this).html());
				$('#' + $(this).find('section.articles-wrapper').attr('id')).find('.pin').click(pinClick);
				$btn.show();
				$ldr.hide();
				window.scrollBy(0, window.innerHeight);
				dfd.resolve();
			});
			return dfd.promise();
		};
		$('.next-page').click(function () {
			loadNext();
			return false;
		});
		if (window.location.pathname === '/' && window.location.hash.match(/#!\/page\d+\/?/)) {
			var page = parseInt(window.location.hash.match(/\d+\/?$/)[0], 10);
			var loadPages = function () {
				if (page > 1) {
					loadNext().done(function () {
						page--;
						loadPages();
					});
				} else {
					window.scrollTo(0, 2147483647);
				}
			};
			loadPages();
		}

		/* Load the related articles */
		var tags = [];
		var $rel = $('#relatedPosts ul');
		$rel.each(function () {
			if (tags.length === 0) {
				$('.tags a').each(function (idx, tag) {
					tags.push($.trim($(tag).text()));
				});
			}
			$.getJSON('/posts.json', function (posts) {
				var related = 0;
				$.each(posts, function (idx, post) {
					var matches = 0;
					$.each(post.tags, function (idx, tag) {
						if (tags.indexOf(tag) !== -1) {
							matches++;
						}
					});
					post.matches = matches;
				});
				posts.sort(function (pa, pb) {
					return pb.matches - pa.matches;
				});
				$rel.html('');
				$.each(posts, function (idx, post) {
					if (related < 5 && location.pathname !== post.url) {
						$rel.append(post.post);
						related++;
					}
				});
			});
		});

		/* support filtering of my work */
		var filterWork = function () {
			var val = $('input[name=work-filter]').val().toLocaleLowerCase();
			var visible = 0;
			$('.pin.client').closest('.col-md-4').each(function () {
				var $client = $(this);
				var clientText = $client.text().toLocaleLowerCase();
				if (clientText.indexOf(val) !== -1) {
					visible++;
					$client.show();
				} else {
					$client.hide();
				}
			});
			if ($('input[name=work-filter]').val() === '') {
				$('form.work-filter .help-block').html('');
			} else {
				$('form.work-filter .help-block').html('Found ' + visible + ' engagements related to ' + $('input[name=work-filter]').val() + '!');
			}

			return false;
		};
		$('form.work-filter').submit(filterWork);
		$('input[name=work-filter]').change(filterWork);
		$('input[name=work-filter]').keyup(filterWork);
		$('.work-filter-clear').click(function () {
			$('input[name=work-filter]').val('');
			filterWork();
		});

		/* display popup */
		var openPopup = function () {
			try {
				if (window.localStorage.getItem('popup') !== 'hide') {
					_gaq.push(['_trackEvent', 'Popup', 'Show']);
					$('#site-popup .btn').click(function () {
						_gaq.push(['_trackEvent', 'Popup', 'Click']);
						window.localStorage.setItem('popup', 'hide');
						$('#site-popup').modal('close');
					});
					$('#site-popup').modal('show').on('hidden.bs.modal', function (e) {
						_gaq.push(['_trackEvent', 'Popup', 'Hide']);
						window.localStorage.setItem('popup', 'hide');
					});
				}
			} catch (e) {
				/* problem occurred with local storage */
			}
		};
	});
});
var track = true;
try {
	if (window.location.search === '?track=false') {
		window.localStorage.setItem('track', 'false');
		track = false;
	}
	if (window.localStorage.getItem('track') === 'false') {
		track = false;
	}
} catch (e) {
	/* problem occurred with local storage */
}

if (track) {
	_gaq.push(['_setAccount', 'UA-37209568-1']);
	_gaq.push(['_trackPageview']);
	(function () {
		if (navigator.userAgent.indexOf("Speed Insights") === -1) {
			var includeScript = function(src) {
				var se = document.createElement('script');
				se.type = 'text/javascript';
				se.async = true;
				se.src = src;
				var s = document.getElementsByTagName('script')[0];
				s.parentNode.insertBefore(se, s);
			}
			includeScript('https://ssl.google-analytics.com/ga.js');
			includeScript('https://platform.twitter.com/widgets.js');
		}
	})();
}