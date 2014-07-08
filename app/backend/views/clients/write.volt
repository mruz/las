<h3><span class="glyphicon glyphicon-user"></span> {{ __('Clients') }} / {{ __(action|capitalize) }}</h3><hr />
{{ flashSession.output() }}
{{ form(null, 'class' : 'form-horizontal') }}
{% set field = 'fullName' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'address' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textarea([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize), 'rows':3 ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'tariff' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ select(field, tariffs, 'using': ['id', 'name'], 'class': 'form-control', 'useEmpty': true, 'emptyText': __('Choose...')) }}
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