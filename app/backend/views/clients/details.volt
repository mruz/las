<h3><span class="glyphicon glyphicon-user"></span> {{ __('Clients') }} / {{ __('Details') }}</h3><hr />
<div class="form-horizontal" role="form">
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Full name') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ client.fullName }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Address') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ client.address|nl2br }}</p>
        </div>
    </div>
        {% set tariff = client.getTariff()%}
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Tariff') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ linkTo('admin/tariffs/details/' ~ tariff.id, tariff.name) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Balance') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ array_sum(arr__from_model(client.getPayments('status = ' ~ payments__SUCCESS()), null, 'amount')) }}{{ las['payments']['currency']|isset }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Status') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static"><span class="glyphicon glyphicon-flash {{ clients__status(client.status, 'color') }}"></span> {{ clients__status(client.status) }}</p>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">{{ __('Description') }}:</label>
        <div class="col-sm-10">
            <p class="form-control-static">{{ client.description }}</p>
        </div>
    </div>
</div>
<hr />
<p>
    {{ linkTo(['admin/clients/edit/' ~ client.id, __('Edit'), 'class': 'btn btn-primary']) }}
    {{ linkTo(['admin/clients/delete/' ~ client.id, __('Delete'), 'class': 'btn btn-danger', 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}
</p>
<br />
<h4><span class="glyphicon glyphicon-phone"></span> {{ linkTo('admin/devices?client=' ~ client.id, __('Devices')) }}</h4><hr />
{% if client.getDevices() %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th>{{ __('Name')}}</th>
            <th class="hidden-xs">{{ __('Type') }}</th>
            <th>{{ __('IP') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
    {% for device in client.getDevices(['limit': 20, 'order': 'id DESC']) %}
        <tr>
            <td><span class="glyphicon glyphicon-flash {{ devices__status(device.status, 'color') }}" title="{{ devices__status(device.status) }}"></span> {{ linkTo('admin/devices/details/' ~ device.id, device.name) }}</td>
            <td class="hidden-xs">{{ devices__type(device.type) }}</td>
            <td>{{ long2ip(device.IP) }}<br /><span class="text-muted small">{{ device.MAC }}</span></td>
            <td>{{ linkTo('admin/devices/edit/' ~ device.id, __('Edit')) }} | {{ linkTo(['admin/devices/delete/' ~ device.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
        </tr>
    {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="4"></td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}
<br />
<h4><span class="glyphicon glyphicon-envelope"></span> {{ linkTo('admin/messages?client=' ~ client.id, __('Messages')) }}</h4><hr />
{% if client.getClientMessages() %}
<table class="table table-striped table-responsive">
    <thead>
        <th>{{ __('Date')}}</th>
        <th>{{ __('Title') }}</th>
        <th class="hidden-xs">{{ __('Content') }}</th>
        <th>{{ __('Action') }}</th>
    </thead>
    <tbody>
    {% for message in client.getClientMessages(['limit': 20, 'order': 'id DESC']) %}
        <td><span class="glyphicon glyphicon-flash {{ messages__status(message.status, 'color') }}" title="{{ messages__status(message.status) }}"></span> <span class="small">{{ linkTo('admin/messages/details/' ~ message.id, message.date) }}</span></td>
        <td>{{ message.title }}</td>
        <td class="hidden-xs">{{  message.content }}</td>
        <td>{{ linkTo('admin/messages/edit/' ~ message.id, __('Edit')) }} | {{ linkTo(['admin/messages/delete/' ~ message.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
    {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="4"></td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}
<br />
<h4><span class="glyphicon glyphicon-usd"></span> {{ linkTo('admin/payments?client=' ~ client.id, __('Payments')) }}</h4><hr />
{% if client.getPayments() %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th>{{ __('Date') }}</th>
            <th>{{ __('Amount') }}</th>
            <th class="hidden-xs">{{ __('Description') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
    {% for payment in client.getPayments(['limit': 20, 'order': 'id DESC']) %}
        <tr>
            <td><span class="glyphicon glyphicon-flash {{ payments__status(payment.status, 'color') }}" title="{{ payments__status(payment.status) }}"></span> <span class="small">{{ linkTo('admin/payments/details/' ~ payment.id, payment.date) }}</span></td>
            <td>{{ payment.amount }}{{ las['payments']['currency']|isset }}</span></td>
            <td class="hidden-xs">{{ payment.description }}</span></td>
            <td>{{ linkTo('admin/payments/edit/' ~ payment.id, __('Edit')) }} | {{ linkTo(['admin/payments/delete/' ~ payment.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
        </tr>
    {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="4"></td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}