// http://davidwalsh.name/mootools-twitter-plugin
window.addEvent('domready', function() {
	gitter = new TwitterGitter('RangoProject', {
		count: 5,
		onComplete: function(tweets, user) {
			tweets.each(function(tweet, i) {
				new Element('div', {
					//html: '<img src="' + user.profile_image_url.replace("\\",'') + '" align="left" alt="' + user.name + '" /> <strong>' + user.name + '</strong><br />' + tweet.text + '<br /><span>' + tweet.created_at + ' via ' + tweet.source.replace("\\",'') + '</span>',
					html: '<strong>' + user.name + '</strong><br />' + tweet.text + '<br /><em>' + tweet.created_at + '</em><br>',
					'class': 'tweet clear'
				}).inject('tweets');
			});
		}
	}).retrieve();
});
