<h3><span class="glyphicon glyphicon-time"></span> {{ __('Tasks') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ task.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('When') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ task.when }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Type') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tasks__type(task.type) }}</p>
        </div>
    </div>
    {% set firewall = task.getFirewall()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Firewall') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ firewall ? linkTo('admin/firewalls/details/' ~ firewall.id, firewall.name) : '' }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Next') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ task.next ? date('Y-m-d H:i', task.next) : __('None') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ tasks__status(task.status, 'color') }}"></span> {{ tasks__status(task.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ task.description }}</p>
        </div>
    </div>
</div>
<hr />
<p>
    {{ linkTo(['admin/tasks/edit/' ~ task.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/tasks/delete/' ~ task.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>