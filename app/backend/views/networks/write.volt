<h3><span class="glyphicon glyphicon-globe"></span> {{ __('Networks') }} / {{ __(action|capitalize) }}</h3><hr />
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
{% set field = 'interface' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': 'eth0']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'subnetwork' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': '192.168.1.0']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'type' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', type, 'useEmpty': true, 'emptyText': __('Choose...')]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'IP' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': '192.168.1.2']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'mask' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', networks__mask()]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'gateway' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': '192.168.1.1']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'DNS' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': '208.67.222.222, 208.67.220.220, 8.8.8.8']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'DHCP' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': '192.168.1.100-192.168.1.200']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'download' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': 10]) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
        </div>
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'upload' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        <div class="input-group">
            {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': 2]) ]) }}
            <span class="input-group-addon">{{ bitRate }}</span>
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