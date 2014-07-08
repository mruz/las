<h3><span class="glyphicon glyphicon-time"></span> {{ __('Tasks') }}</h3><hr />
{{ linkTo(['admin/tasks/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('when', 'alphabet') }} {{ __('When') }}</th>
            <th>{{ tool__sortLink('type') }} {{ __('Type') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('next') }} {{ __('Next') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for task in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ tasks__status(task.status, 'color') }}" title="{{ tasks__status(task.status) }}"></span></td>
                <td>{{ linkTo('admin/tasks/details/' ~ task.id, task.name) }}</td>
                <td class="hidden-xs small">{{ task.when }}</td>
                <td>{% set firewall = task.getFirewall() %}{{ tasks__type(task.type) }}{{ task.type == tasks__FIREWALL() and firewall ? ': ' ~ linkTo('admin/firewalls/details/' ~ firewall.id, firewall.name) : '' }}</td>
                <td class="hidden-xs small text-muted">{{ task.next ? date('Y-m-d H:i', task.next) : __('None') }}</td>
                <td>{{ linkTo('admin/tasks/edit/' ~ task.id, __('Edit')) }} | {{ linkTo(['admin/tasks/delete/' ~ task.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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