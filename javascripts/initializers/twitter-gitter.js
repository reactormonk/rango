// http://davidwalsh.name/mootools-twitter-plugin
window.addEvent('domready', function() {
	var myTwitterGitter = new TwitterGitter($('RangoProject').value, {
		count: 5,
		onComplete: function(tweets, user) {
			tweets.each(function(tweet, i) {
				new Element('div', {
					html: '<img src="' + user.profile_image_url.replace("\\",'') + '" align="left" alt="' + user.name + '" /> <strong>' + user.name + '</strong><br />' + tweet.text + '<br /><span>' + tweet.created_at + ' via ' + tweet.source.replace("\\",'') + '</span>',
					'class': 'tweet clear'
				}).inject('tweets');
			});
		}
	}).retrieve();
});
