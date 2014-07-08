<h3><span class="glyphicon glyphicon-usd"></span> {{ __('Payments') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Date') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ payment.date }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Amount') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ payment.amount }}{{ las['payments']['currency']|isset }}</p>
        </div>
    </div>
    {% set client = payment.getClient()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Client') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ linkTo('admin/clients/details/' ~ client.id, client.fullName) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ payments__status(payment.status, 'color') }}"></span> {{ payments__status(payment.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ payment.description }}</p>
        </div>
    </div>
</div>
<hr />
<p>
    {{ linkTo(['admin/payments/edit/' ~ payment.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/payments/delete/' ~ payment.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>