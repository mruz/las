<h3><span class="glyphicon glyphicon-filter"></span> {{ __('Firewalls') }}</h3><hr />
{{ linkTo(['admin/firewalls/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for firewall in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ firewalls__status(firewall.status, 'color') }}" title="{{ firewalls__status(firewall.status) }}"></span></td>
                <td>{{ linkTo('admin/firewalls/details/' ~ firewall.id, firewall.name) }}</td>
                <td>{{ linkTo('admin/firewalls/edit/' ~ firewall.id, __('Edit')) }} | {{ linkTo('admin/firewalls/compile/' ~ firewall.id, __('Compile')) }} | {{ linkTo(['admin/firewalls/reload/' ~ firewall.id, __('Reload'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal/reload')]) }} | {{ linkTo(['admin/firewalls/delete/' ~ firewall.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
            </tr>
        {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="3">{{ tool__pagination(pagination) }}</td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}