<h3><span class="glyphicon glyphicon-envelope"></span> {{ __('Messages') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Title') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ message.title }}</p>
        </div>
    </div>
    {% set client = message.getClient()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Client') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ linkTo('admin/clients/details/' ~ client.id, client.fullName) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ messages__status(message.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Content') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ message.content }}</p>
        </div>
    </div>
</div>
<hr />
<p>
    {{ linkTo(['admin/messages/edit/' ~ message.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/messages/delete/' ~ message.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>