<h3><span class="glyphicon glyphicon-phone"></span> {{ __('Devices') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ device.name }}</p>
        </div>
    </div>
    {% set client = device.getClient()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Client') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ linkTo('admin/clients/details/' ~ client.id, client.fullName) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Type') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ devices__type(device.type) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('IP') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ long2ip(device.IP) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('MAC') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ device.MAC }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Last active') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ device.lastActive ? date('Y-m-d H:i:s', device.lastActive) : __('None') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ devices__status(device.status, 'color') }}"></span> {{ devices__status(device.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ device.description }}</p>
        </div>
    </div>
</div>
<hr />
<p>
    {{ linkTo(['admin/devices/edit/' ~ device.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/devices/delete/' ~ device.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>