(function($) {
    $.fn.refresh = function(options) {
        var defaults = {
            base_uri: "/",
            refresh: 60
        };

        var options = $.extend(defaults, options);
        var node = this;
        
        setInterval(function() {
            $(node.selector).each(function() {
                refresh(this);
            });
        }, options.refresh * 1000);


        function refresh(element) {
            $.ajax({
                type: "POST",
                url: options.base_uri + "admin/ajax/refresh",
                data: {'type': element.id},
                success: function(result) {
                    $(element).html(result);
                }
            });
        }
    };
})(jQuery);