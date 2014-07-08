<h3><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> {{ __('Tariffs') }} / {{ __(action|capitalize) }}</h3><hr />
{{ partial('help/bit') }}
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
{% set field = 'amount' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
            <span class="input-group-addon">{{ las['payments']['currency']|isset }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'priority' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'downloadRate' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'downloadCeil' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'uploadRate' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'uploadCeil' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'limit' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
            <span class="input-group-addon">{{ __('packets/s') }}</span>
        </div>
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