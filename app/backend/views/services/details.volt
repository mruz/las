<h3><span class="glyphicon glyphicon-briefcase"></span> {{ __('Services') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Chain') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ services__chain(service.chain) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Protocol') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.protocol ? services__protocol(service.protocol) : __('Any') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Direction') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.direction ? services__direction(service.direction) : __('Any') }}</p>
        </div>
    </div>
    {% set client = service.getClient()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Client') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ client ? linkTo('admin/clients/details/' ~ client.id, client.fullName) : __('Any') }}</p>
        </div>
    </div>
    {% set device = service.getDevice()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Device') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ device ? linkTo('admin/devices/details/' ~ device.id, device.name) : __('Any') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('IP') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.IP ? long2ip(service.IP) : '' }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('String') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.string }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Port direction') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.portDirection ? services__portDirection(service.portDirection) : __('Any') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Starting port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.startingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Ending port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.endingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Length min') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.lengthMin }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Length max') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.lengthMax }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Priority') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ services__priority(service.priority) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ services__status(service.status, 'color') }}"></span> {{ services__status(service.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ service.description }}</p>
        </div>
    </div>
</div>
<p class="clearfix"><span class="text-muted small pull-right">{{ service.date }}</span></p>
<hr />
<p>
    {{ linkTo(['admin/services/edit/' ~ service.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/services/delete/' ~ service.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>