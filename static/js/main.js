// Avoid `console` errors in browsers that lack a console.
(function() {
	var method;
	var noop = function () {};
	var methods = [
		'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
		'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
		'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
		'timeline', 'timelineEnd', 'timeStamp', 'trace', 'warn'
	];
	var length = methods.length;
	var console = (window.console = window.console || {});

	while (length--) {
		method = methods[length];

		// Only stub undefined methods.
		if (!console[method]) {
			console[method] = noop;
		}
	}
}());

document.addEventListener('DOMContentLoaded', function(event) {
	centerContent();
});

window.addEventListener('resize', function(event) {
	centerContent();
});

function centerContent()
{
	var wrapperHeight = 0;
	if (document.getElementsByClassName('wrapper')[0] !== undefined) {
		wrapperHeight = document.getElementsByClassName('wrapper')[0].clientHeight;
	}

	var topLineHeight = 0;
	if (document.getElementsByClassName('top-line')[0] !== undefined) {
		topLineHeight = document.getElementsByClassName('top-line')[0].clientHeight;
	}

	var browserupgradeHeight = 0;
	if (document.getElementsByClassName('browserupgrade')[0] !== undefined) {
		browserupgradeHeight = document.getElementsByClassName('browserupgrade')[0].clientHeight;
	}

	var marginTop = (window.innerHeight - wrapperHeight) / 2;
	marginTop = marginTop - 100 - topLineHeight - browserupgradeHeight;

	if (marginTop < 20) {
		marginTop = 20;
	}

	if (document.getElementsByClassName('wrapper')[0] !== undefined) {
		document.getElementsByClassName('wrapper')[0].style.marginTop = marginTop + 'px';
	}
}
