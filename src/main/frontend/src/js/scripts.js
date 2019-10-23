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
		var filterContent = function () {
			var val = $('input[name=content-filter]').val().toLocaleLowerCase();
			var target = $('#content-filter-form').data('target');
			var visible = 0;
			$(target).each(function () {
				var $item = $(this);
				var text = $item.text().toLocaleLowerCase();
				if (text.indexOf(val) !== -1) {
					visible++;
					$item.show();
				} else {
					$item.hide();
				}
			});
			if ($('input[name=content-filter]').val() === '') {
				$('#content-filter-form .help-block').html('');
			} else {
				$('#content-filter-form .help-block').html('Found ' + visible + ' items with ' + $('input[name=content-filter]').val() + '!');
			}

			return false;
		};
		$('#content-filter-form').submit(function(){
            window.dataLayer.push({
                'event': 'contentfilter'
            });
            filterContent();
        });
		$('input[name=content-filter]').change(function(){
            window.dataLayer.push({
                'event': 'contentfilter'
            });
            filterContent();
        });
		$('input[name=content-filter]').keyup(filterContent);
		$('.content-filter-clear').click(function () {
			$('input[name=content-filter]').val('');
			filterContent();
		});
	});
    if (navigator.userAgent.indexOf("Speed Insights") === -1) {
        $('body').append($("<script />", {
            src: 'https://platform.twitter.com/widgets.js'
        }));
    }
});