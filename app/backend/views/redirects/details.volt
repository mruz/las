<h3><span class="glyphicon glyphicon-random"></span> {{ __('Redirects') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Type') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirects__type(redirect.type) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('External starting port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.externalStartingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('External ending port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.externalEndingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Internal starting port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.internalStartingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Internal ending port') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.internalEndingPort }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ redirects__status(redirect.status, 'color') }}"></span> {{ redirects__status(redirect.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ redirect.description }}</p>
        </div>
    </div>
</div>
<p class="clearfix"><span class="text-muted small pull-right">{{ redirect.date }}</span></p>
<hr />
<p>
    {{ linkTo(['admin/redirects/edit/' ~ redirect.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/redirects/delete/' ~ redirect.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>