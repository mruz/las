<h3><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> {{ __('Tariffs') }}</h3><hr />
{{ linkTo(['admin/tariffs/add', 'class': 'btn btn-primary pull-right pull-none', __('Add')]) }}
{% if pagination.items %}
<table class="table table-striped table-hover table-responsive">
    <thead>
        <tr>
            <th title="{{ __('Status') }}">{{ tool__sortLink('status') }}</th>
            <th>{{ tool__sortLink('name', 'alphabet') }} {{ __('Name') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('priority') }} {{ __('Priority') }}</th>
            <th class="hidden-xs">{{ tool__sortLink('amount') }} {{ __('Amount') }}</th>
            <th>{{ tool__sortLink('downloadCeil') }} {{ __('Download') }}</th>
            <th>{{ tool__sortLink('uploadCeil') }} {{ __('Upload') }}</th>
            <th>{{ __('Action') }}</th>
        </tr>
    </thead>
    <tbody>
        {% for tariff in pagination.items %}
            <tr>
                <td><span class="glyphicon glyphicon-flash {{ tariffs__status(tariff.status, 'color') }}" title="{{ tariffs__status(tariff.status) }}"></span></td>
                <td>{{ linkTo('admin/tariffs/details/' ~ tariff.id, tariff.name) }}</td>
                <td class="hidden-xs">{{ tariff.priority }}</td>
                <td class="hidden-xs">{{ tariff.amount }}{{ las['payments']['currency']|isset }}</td>
                <td><span title="{{ __('Download rate') }}">{{ tariff.downloadRate }}</span>/<span title="{{ __('Download ceil') }}">{{ tariff.downloadCeil }}</span> <span title="{{ __('Bit rate') }}">{{ bitRate }}</span></td>
                <td><span title="{{ __('Upload rate') }}">{{ tariff.uploadRate }}</span>/<span title="{{ __('Upload ceil') }}">{{ tariff.uploadCeil }}</span> <span title="{{ __('Bit rate') }}">{{ bitRate }}</span></td>
                <td>{{ linkTo('admin/tariffs/edit/' ~ tariff.id, __('Edit')) }} | {{ linkTo(['admin/tariffs/delete/' ~ tariff.id, __('Delete'), 'data-toggle':'modal', 'data-target':"#modal", 'data-remote': url.get('admin/modal')]) }}</td>
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