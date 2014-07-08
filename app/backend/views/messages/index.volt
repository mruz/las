<h3><span class="glyphicon glyphicon-envelope"></span> {{ __('Messages') }}</h3><hr />
{{ linkTo(['admin/messages/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('date') }} {{ __('Date')}}</th>
            <th>{{ tool__sortLink('client_id') }} {{ __('Client') }}</th>
            <th>{{ tool__sortLink('title') }} {{ __('Title') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('content') }} {{ __('Content') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for message in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ messages__status(message.status, 'color') }}" title="{{ messages__status(message.status) }}"></span></td>
                <td><span class="small">{{ linkTo('admin/messages/details/' ~ message.id, message.date) }}</span></td>
                {% set client = message.getClient() %}
                <td>{{ client ? linkTo('admin/clients/details/' ~ client.id, client.fullName) : __('None') }}</td>
                <td>{{ message.title }}</td>
                <td class="hidden-xs">{{  message.content }}</td>
                <td>{{ linkTo('admin/messages/edit/' ~ message.id, __('Edit')) }} | {{ linkTo(['admin/messages/delete/' ~ message.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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