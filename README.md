# Getvideo

getvideo is parse video information on Ruby, you can get video media download url, cover, flash url and title.

## Support Sites List

* Youtube [http://www.youtube.com/](http://www.youtube.com/)
* 优酷网 [http://www.youku.com/](http://www.youku.com/)
* 土豆网 [http://www.tudou.com/](http://www.tudou.com/)
* 56网 [http://www.56.com/](http://www.56.com/)
* 爱奇艺 [http://www.iqiyi.com/](http://www.iqiyi.com/)
* 搜狐视频 [http://tv.sohu.com/](http://tv.sohu.com/)
* 酷6网 [http://www.ku6.com/](http://www.ku6.com/)
* 新浪视频 [http://video.sina.com.cn/](http://video.sina.com.cn/)

## Installation

Add this line to your application's Gemfile:

    gem 'getvideo'

And then execute:

    $ bundle

Or install it yourself as

    $ gem install getvideo        

## Usage
check faraday, multi_json, nokogiri gems installed

```
	require 'getvideo'
	
	video = Getvideo.parse "http://videourl.com/info"
	video.cover 
	video.id
	video.html_url
	video.title
	video.media #get all video url like {"mp4" => "http://mp4 play url", "hlv" => "http://hlv"}
	video.flash
	video.play_media  # get mp4 video
	video.json
````
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

get more video you can access [you-get](https://github.com/soimort/you-get)