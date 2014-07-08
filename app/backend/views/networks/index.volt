<h3><span class="glyphicon glyphicon-globe"></span> {{ __('Networks') }}</h3><hr />
{{ linkTo(['admin/networks/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('type') }} {{ __('Type') }}</th>
            <th>{{ tool__sortLink('subnetwork') }} {{ __('Subnetwork') }}/{{ __('Mask') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('interface', 'alphabet') }} {{ __('Interface') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for network in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ networks__status(network.status, 'color') }}" title="{{ networks__status(network.status) }}"></span></td>
                <td>{{ linkTo('admin/networks/details/' ~ network.id, network.name) }}</td>
                <td class="hidden-xs">{{ networks__type(network.type) }}</td>
                <td>{{ long2ip(network.subnetwork) }}<span title="{{ networks__mask(network.mask)}}">{{ network.mask }}</span></td>
                <td class="hidden-xs">{{ network.interface }}</td>
                <td>{{ linkTo('admin/networks/edit/' ~ network.id, __('Edit')) }} | {{ linkTo(['admin/networks/delete/' ~ network.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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