<h3><span class="glyphicon glyphicon-random"></span> {{ __('Redirects') }}</h3><hr />
{{ linkTo(['admin/redirects/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th>{{ tool__sortLink('externalStartingPort') }} {{ __('External') }} {{ tool__sortLink('externalEndingPort') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('internalStartingPort') }} {{ __('Internal') }} {{ tool__sortLink('internalEndingPort') }}</th>
            <th>{{ tool__sortLink('device_id') }} {{ __('Device') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('type') }} {{ __('Type') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for redirect in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ redirects__status(redirect.status, 'color') }}" title="{{ redirects__status(redirect.status) }}"></span></td>
                <td>{{ linkTo('admin/redirects/details/' ~ redirect.id, redirect.name) }}</td>
                <td><span title="{{ __('External starting port') }}">{{ redirect.externalStartingPort }}</span><span title="{{ __('External ending port') }}">{{ redirect.externalEndingPort ? ':' ~ redirect.externalEndingPort : '' }}</span></td>
                <td class="hidden-xs"><span title="{{ __('Internal starting port') }}">{{ redirect.internalStartingPort }}</span><span title="{{ __('Internal ending port') }}">{{ redirect.internalEndingPort ? ':' ~ redirect.internalEndingPort : '' }}</span></td>
                <td>{% set device = redirect.getDevice() %}{{ linkTo('admin/devices/details/' ~ device.id, device.name) }}</td>
                <td class="hidden-xs">{{ redirects__type(redirect.type) }}</td>
                <td>{{ linkTo('admin/redirects/edit/' ~ redirect.id, __('Edit')) }} | {{ linkTo(['admin/redirects/delete/' ~ redirect.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
            </tr>
        {% endfor %}
    </tbody>
    <tfoot>
        <tr><td colspan="7">{{ tool__pagination(pagination) }}</td></tr>
    </tfoot>
</table>
{% else %}
    <p class="text-muted">{{ __('Not found') }}</p>
{% endif %}