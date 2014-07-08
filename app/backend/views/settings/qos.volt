<h3><span class="glyphicon glyphicon-cog"></span> {{ __('Settings') }} / {{ __(action|capitalize) }}</h3><hr />
{{ flashSession.output() }}
{{ form(null, 'class' : 'form-horizontal') }}
{% set field = 'enableQos' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        {{ checkField(_POST[field] is defined and _POST[field] == 1 ? [ field, 'value': 1, 'checked': 'checked' ] : [ field, 'value': 1 ]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'defaultClass' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', priority]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set percents = array_combine(1..100, 1..100) %}
{% for field in ['highest', 'high', 'medium', 'low', 'lowest'] %}
    {% set fieldStart = field ~ 'Rate' %}
    {% set fieldEnd = field ~ 'Ceil' %}
    <div class="form-group">
        <div class="{{ errors is defined and (errors.filter(fieldStart) or errors.filter(fieldEnd)) ? ' has-error' : (_POST[fieldStart]|isset or _POST[fieldEnd]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ fieldStart }}>{{ __(field|label) }}:</label>
        </div>
        <div class="col-lg-9">
            <div class="row">
                <div class="col-lg-6 col-xs-6{{ errors is defined and errors.filter(fieldStart) ? ' has-error' : (_POST[fieldStart]|isset ? ' has-success' : '') }}">
                    <div class="input-group">
                        {{ selectStatic([fieldStart, 'class': 'form-control', percents]) }}
                        <span class="input-group-addon">%</span>
                    </div>
                </div>
                <div class="col-lg-6 col-xs-6{{ errors is defined and errors.filter(fieldEnd) ? ' has-error' : (_POST[fieldEnd]|isset ? ' has-success' : '') }}">
                    <div class="input-group">
                        {{ selectStatic([fieldEnd, 'class': 'form-control', percents]) }}
                        <span class="input-group-addon">%</span>
                    </div>
                </div>
            </div>
            {% if errors is defined and (errors.filter(fieldStart) or errors.filter(fieldEnd)) %}
                <div class="has-error">
                {% if errors is defined and errors.filter(fieldStart) %}
                    <span class="help-block has-error">{{ current(errors.filter(fieldStart)).getMessage() }}</span>
                {% endif %}
                {% if errors is defined and errors.filter(fieldEnd) %}
                    <span class="help-block">{{ current(errors.filter(fieldEnd)).getMessage() }}</span>
                {% endif %}
                </div>
            {% endif %}
        </div>
    </div>
{% endfor %}
<hr />
<div class="form-group">
    <div class="col-lg-offset-3 col-lg-9">
        <p><button type="submit" name="submit" class="btn btn-primary">{{ __('Save') }}</button></p>
    </div>
</div>
{{ endForm() }}