<h3><span class="glyphicon glyphicon-user"></span> {{ __('Clients') }}</h3><hr />
{{ linkTo(['admin/clients/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('fullName', 'alphabet') }} {{ __('Full name') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('address', 'alphabet') }} {{ __('Address') }}</th>
            <th>{{ tool__sortLink('balance') }} {{ __('Balance') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for client in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ clients__status(client.status, 'color') }}" title="{{ clients__status(client.status) }}"></span></td>
                <td>{{ linkTo('admin/clients/details/' ~ client.id, client.fullName) }}</td>
                <td class="hidden-xs small">{{ client.address|nl2br }}</td>
                <td>{{ client.balance !== null ? client.balance ~ las['payments']['currency']|isset : __('None') }}</td>
                <td>{{ linkTo('admin/clients/edit/' ~ client.id, __('Edit')) }} | {{ linkTo(['admin/clients/delete/' ~ client.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
            </tr>
        {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="5">{{ tool__pagination(pagination) }}</td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}