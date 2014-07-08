{% if modalTitle is defined %}
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4 class="modal-title">{{ modalTitle }}</h4>
</div>
{% endif %}
<div class="modal-body">
    {{ content() }}
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">{{ __('Close') }}</button>
    {% if modalAccept is defined %}
    {{ modalAccept }}
    {% endif %}
</div>
