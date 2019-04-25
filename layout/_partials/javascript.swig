{# javascript #}
{% if theme.service_workers %}
<script>
    if ('serviceWorker' in navigator) {
        window.addEventListener('load', function() {
            navigator.serviceWorker.register('/sw.js').then(function(registration) {
                console.log('ServiceWorker registration successful with scope: ', registration.scope);
            }).catch(function(err) {
                console.log('ServiceWorker registration failed: ', err);
            });
        });
    }
</script>
{% else %}
{# 卸载时为 unregister #}
<script>
    if(window.navigator && navigator.serviceWorker) {
        navigator.serviceWorker.getRegistrations()
        .then(function(registrations) {
            for(let registration of registrations) {
                registration.unregister();
            }
        });
    }
</script>
{% endif %}

{# 非文章页懒加载 #}
{% if !is_post() %}
{% if theme.local_search %}
{{ js('js/mix/home-lazy-local.min') }}
{% else %}
{{ js('js/lazyload') }}
{% endif %}
<script>;(function() {var bLazy = new Blazy()})();</script>
{% endif %}

{# 文章页面 #}
{% if is_post() %}
{% include "public/fload-header.swig" %}

{# 如果开启文章页懒加载 #}
{% if theme.lazyload %}
{# 如果开启搜索，则引入 post 页面、懒加载、搜索合并文件 #}
{% if theme.local_search %}
{{ js('js/mix/post-lazy-local.min') }}
{% else %}
{# 未开启搜索只引入 post 页面、懒加载合并文件 #}
{{ js('js/mix/post-lazy.min') }}
{% endif %}
<script>;(function() {var bLazy = new Blazy()})();</script>
{% else %}
{# 如果未开启文章页懒加载 #}
{% if theme.local_search %}
{# 如果开启搜索，则引入 post 页面、搜索合并文件 #}
{{ js('js/mix/post-local.min') }}
{% else %}
{# 如果未开启懒加载，未开启搜索，则只引入 post 文件 #}
{{ js('js/post.min') }}
{% endif %}
{% endif %}

{# 相册 #}
{% if theme.lightgallery %}
{{ js('js/lightgallery.min') }}
{{ css('css/lightgallery.min') }}
<script>
    lightGallery(document.getElementById('lightgallery'), {
        selector: '.post-img'
    });
</script>
{% endif %}

{# Valine 评论 #}
{% if theme.comment %}
<script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
<script src='//unpkg.com/valine/dist/Valine.min.js'></script>
<script>
    new Valine({
        el: '#comment' ,
        verify: {{ theme.valine.verify }},
        notify: {{ theme.valine.notify }},
        appId: '{{ theme.valine.appId }}',
        appKey: '{{ theme.valine.appKey }}',
        placeholder: '{{ theme.valine.placeholder }}',
        pageSize: {{ theme.valine.pageSize }},
        avatar: '{{ theme.valine.avatar }}',
        visitor: true,
    });
</script>
{% endif %}

{# viewer相册 #}
{% if theme.viewer %}
{{ js('js/viewer.min') }}
{{ css('css/viewer.min') }}
	<script type="text/javascript">
	//默认设置， 可以根据个人需求和喜好进行配置
	//详细参考官方说明
	Viewer.setDefaults({
		//设置初始缩放 default: 1
		zoomRatio : [0.5],
		//设置滚轮缩放比率 default: 0.1
		show: function () {
			this.viewer.zoomTo(0.5);
		},
		});
	//获得content中所有的图片， 不同主题可能有所不同
	//为了和其他的图片区别开来 所以在markdown中插入图片的时候使用独特的记号
	//为了一次性得到所有的图片我这里采用的是class = 'post-img'
	var article = document.querySelector('.markdown-body');
	var imageList = article.getElementsByClassName('post-img');
	//将获取到的HTMLCollections转化成Array
	var imageArray = new Array();
	Array.prototype.forEach.call(imageList, element => {
		imageArray.push(element);
	});
	//设置每个图片成为图片组
	Array.prototype.forEach.call(imageList, element => {
		var viewer1 = new Viewer(element);
		viewer1.images = imageArray;
		viewer1.length = imageArray.length;
	});
	</script>
{% endif %}

{% endif %}

{# 本地搜索 #}
{% if theme.local_search %}
{% if theme.service_workers %}
<script>searchFuncSW("{{ config.root }}")</script>
{% else %}
<script>searchFunc("{{ config.root }}")</script>
{% endif %}
{% endif %}

{# 百度 SEO #}
{% if theme.baidu %}
<script>
    (function(){
        var bp = document.createElement('script');
        var curProtocol = window.location.protocol.split(':')[0];
        if (curProtocol === 'https') {
            bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
        }
        else {
            bp.src = 'http://push.zhanzhang.baidu.com/push.js';
        }
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(bp, s);
    })();
    console.log("this theme is from https://github.com/xzhih/hexo-theme-casper")
</script>
{% endif %}