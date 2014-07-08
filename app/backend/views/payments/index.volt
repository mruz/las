<h3><span class="glyphicon glyphicon-usd"></span> {{ __('Payments') }}</h3><hr />
{{ linkTo(['admin/payments/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('date') }} {{ __('Date') }}</th>
            <th>{{ tool__sortLink('client', 'alphabet') }} {{ __('Client') }}</th>
            <th>{{ tool__sortLink('amount') }} {{ __('Amount') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('description') }} {{ __('Description') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for payment in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ payments__status(payment.status, 'color') }}" title="{{ payments__status(payment.status) }}"></span></td>
                <td><span class="small">{{ linkTo('admin/payments/details/' ~ payment.id, payment.date) }}</span></td>
                <td>{{ payment.client }}</td>
                <td>{{ payment.amount }}{{ las['payments']['currency']|isset }}</span></td>
                <td class="hidden-xs">{{ payment.description }}</td>
                <td>{{ linkTo('admin/payments/edit/' ~ payment.id, __('Edit')) }} | {{ linkTo(['admin/payments/delete/' ~ payment.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
            </tr>
        {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="6">{{ tool__pagination(pagination) }}</td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}