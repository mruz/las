<h3><span class="glyphicon glyphicon-globe"></span> {{ __('Networks') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Type') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ networks__type(network.type) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Interface') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.interface }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Subnetwork') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ long2ip(network.subnetwork) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('IP') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ long2ip(network.IP) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Mask') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ networks__mask(network.mask) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Gateway') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ long2ip(network.gateway) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('DNS') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.DNS }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('DHCP') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.DHCP }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Download') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.download }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Upload') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.upload }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ networks__status(network.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ network.description }}</p>
        </div>
    </div>
</div>
<p class="clearfix"><span class="text-muted small pull-right">{{ network.date }}</span></p>
<hr />
<p>
    {{ linkTo(['admin/networks/edit/' ~ network.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/networks/delete/' ~ network.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>