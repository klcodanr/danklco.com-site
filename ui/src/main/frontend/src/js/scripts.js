"use strict";

var _gaq = _gaq || [];
jQuery(function ($) {
	$(document).ready(function () {

		/* Contact form validation */
		$('input,textarea,select').bind('invalid', function (evt) {
			$(evt.target).parent().addClass('has-error');
			$(evt.target).parent().find('.text-danger').show().removeClass('d-none');
			return false;
		});
		var validateField = function (event) {
			if (event.target.checkValidity()) {
				$(event.target).parent().removeClass('has-error');
				$(event.target).parent().find('.text-danger').hide();
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
				var url = $(this).data('url');
				if(!url){
					url = $(this).find('a').first().attr('href');
				}
				if (url) {
					_gaq.push(['_trackEvent', 'Pin', 'Click', url]);
					window.location = url;
					return false;
				}
			}
		};
		$('.recent-activity .pin').click(pinClick);

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