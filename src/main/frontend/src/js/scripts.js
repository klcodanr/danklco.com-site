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

		/* Client Modals on the My Work page */
		$('.client').click(function () {
			var $client = $(this);
			$('#client-box img').attr('src', $client.data('image'));
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
		$('form.work-filter').submit(function(){
            window.dataLayer.push({
                'event': 'workfilter'
            });
            filterWork();
        });
		$('input[name=work-filter]').change(function(){
            window.dataLayer.push({
                'event': 'workfilter'
            });
            filterWork();
        });
		$('input[name=work-filter]').keyup(filterWork);
		$('.work-filter-clear').click(function () {
			$('input[name=work-filter]').val('');
			filterWork();
		});
	});
    if (navigator.userAgent.indexOf("Speed Insights") === -1) {
        $('body').append($("<script />", {
            src: 'https://platform.twitter.com/widgets.js'
        }));
    }
});