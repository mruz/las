<h3><span class="glyphicon glyphicon-phone"></span> {{ __('Devices') }}</h3><hr />
{{ linkTo(['admin/devices/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name')}} {{ tool__sortLink('lastActive') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('client_id') }} {{ __('Client') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('type') }} {{ __('Type') }}</th>
            <th>{{ tool__sortLink('IP') }} {{ __('IP') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for device in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ devices__status(device.status, 'color') }}" title="{{ devices__status(device.status) }}"></span></td>
                <td>{{ linkTo('admin/devices/details/' ~ device.id, device.name) }}{{ device.lastActive ? '<br />' ~ date('Y-m-d H:i:s', device.lastActive : '') }}</td>
                {% set client = device.getClient() %}
                <td class="hidden-xs">{{ client ? linkTo('admin/clients/details/' ~ client.id, client.fullName) : __('None') }}</td>
                <td class="hidden-xs">{{ devices__type(device.type) }}</td>
                <td>{{ long2ip(device.IP) }}<br /><span class="text-muted small">{{ device.MAC }}</span></td>
                <td>{{ linkTo('admin/devices/edit/' ~ device.id, __('Edit')) }} | {{ linkTo(['admin/devices/delete/' ~ device.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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