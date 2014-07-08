<h3><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> {{ __('Tariffs') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.name }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Amount') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.amount }}{{ las['payments']['currency']|isset }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Priority') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.priority }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Download rate') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.downloadRate }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Download ceil') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.downloadCeil }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Upload rate') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.uploadRate }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Upload ceil') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.uploadCeil }} {{ bitRate }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Limit') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.limit ? tariff.limit ~ ' ' ~ __('packets/s') : __('unlimited') }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ tariffs__status(tariff.status, 'color') }}"></span> {{ tariffs__status(tariff.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ tariff.description }}</p>
        </div>
    </div>
</div>
<p class="clearfix"><span class="text-muted small pull-right">{{ tariff.date }}</span></p>
<hr />
<p>
    {{ linkTo(['admin/tariffs/edit/' ~ tariff.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/tariffs/delete/' ~ tariff.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>