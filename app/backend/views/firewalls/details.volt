<h3><span class="glyphicon glyphicon-globe"></span> {{ __('Firewalls') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ firewall.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Content') }}:</label>
    </div>
    <pre class="form-control-static django" style="font-size: 11px">{{ firewall.content }}</pre>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ firewalls__status(firewall.status, 'color') }}"></span> {{ firewalls__status(firewall.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ firewall.description }}</p>
        </div>
    </div>
</div>
<p class="clearfix"><span class="text-muted small pull-right">{{ firewall.date }}</span></p>
<hr />
<p>
    {{ linkTo(['admin/firewalls/edit/' ~ firewall.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/firewalls/compile/' ~ firewall.id, __('Compile'), 'class': 'btn btn-success']) }}
    {{ linkTo(['admin/firewalls/display/' ~ firewall.id, __('Display'), 'class': 'btn btn-info']) }}
    {{ linkTo(['admin/firewalls/reload/' ~ firewall.id, __('Reload'), 'class': 'btn btn-warning', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal/reload')]) }}
    {{ linkTo(['admin/firewalls/delete/' ~ firewall.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>