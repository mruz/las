<h3><span class="glyphicon glyphicon-filter"></span> {{ __('Firewalls') }} / {{ __('Display') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ firewall.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ firewalls__status(firewall.status, 'color') }}"></span> {{ firewalls__status(firewall.status) }}</p>
        </div>
    </div>
</div>
<pre style="word-wrap: normal; font-size: 11px" class="bash">{{ content }}</pre>