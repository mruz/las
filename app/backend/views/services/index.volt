<h3><span class="glyphicon glyphicon-briefcase"></span> {{ __('Services') }}</h3><hr />
{{ linkTo(['admin/services/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('client_id') }} {{ __('Client') }}</th>
            <th>{{ tool__sortLink('startingPort') }} {{ __('Port') }} {{ tool__sortLink('endingPort') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('priority') }} {{ __('Priotity') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for service in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ services__status(service.status, 'color') }}" title="{{ services__status(service.status) }}"></span></td>
                <td>{{ linkTo('admin/services/details/' ~ service.id, service.name) }}</td>
                <td class="hidden-xs">{% set client = service.getClient() %}{{ client ? linkTo('admin/clients/details/' ~ client.id, client.fullName) : '' }}</td>
                <td><span title="{{ __('Starting port') }}">{{ service.startingPort }}</span><span title="{{ __('Ending port') }}">{{ service.endingPort ? ':' ~ service.endingPort : '' }}</span></td>
                <td class="hidden-xs">{{ services__priority(service.priority) }}</td>
                <td>{{ linkTo('admin/services/edit/' ~ service.id, __('Edit')) }} | {{ linkTo(['admin/services/delete/' ~ service.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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