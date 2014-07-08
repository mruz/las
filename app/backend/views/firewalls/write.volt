<h3><span class="glyphicon glyphicon-filter"></span> {{ __('Firewalls') }} / {{ __(action|capitalize) }}</h3><hr />
{{ flashSession.output() }}
{{ form(null, 'class' : 'form-horizontal') }}
{% set field = 'name' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'content' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textarea([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize), 'rows': 50, 'wrap': 'off', 'style': 'font-size: 11px' ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'description' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textarea([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize), 'rows':5 ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'status' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', status]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
<hr />
<div class="form-group">
    <div class="col-lg-offset-3 col-lg-9">
        <p><button type="submit" name="submit" class="btn btn-primary">{{ __(action|capitalize) }}</button></p>
    </div>
</div>
{{ endForm() }}