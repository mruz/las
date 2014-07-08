<h3><span class="glyphicon glyphicon-briefcase"></span> {{ __('Services') }} / {{ __(action|capitalize) }}</h3><hr />
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
{% set field = 'chain' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', chain, 'useEmpty': true, 'emptyText': __('Choose...')]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'protocol' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', protocol, 'useEmpty': true, 'emptyText': __('Any...')]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-body">
        {% set field = 'direction' %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ selectStatic([field, 'class': 'form-control', direction, 'useEmpty': true, 'emptyText': __('Any...')]) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
        {% set field = 'client' %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
            <div class="col-lg-9">
                {{ select(field, clients, 'using': ['id', 'fullName'], 'class': 'form-control', 'useEmpty': true, 'emptyText': __('Any...')) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
        {% set field = 'device' %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
            <div class="col-lg-9">
                {{ select(field, devices, 'using': ['id', 'name'], 'class': 'form-control', 'useEmpty': true, 'emptyText': __('Any...')) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
        {% set field = 'IP' %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
            <div class="col-lg-9">
                {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
                {% if errors is defined and errors.filter(field) %}
                <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    </div>
</div>
{% set field = 'string' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __('eg :sth', [':sth': 'facebook.com']) ]) }}
        {% if errors is defined and errors.filter(field) %}
        <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-body">
        {% set field = 'portDirection' %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ selectStatic([field, 'class': 'form-control', portDirection, 'useEmpty': true, 'emptyText': __('Any...')]) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
        {% set fieldStart = 'startingPort' %}
        {% set fieldEnd = 'endingPort' %}
        <div class="form-group">
            <div class="{{ errors is defined and (errors.filter(fieldStart) or errors.filter(fieldEnd)) ? ' has-error' : (_POST[fieldStart]|isset or _POST[fieldEnd]|isset ? ' has-success' : '') }}">
                <label class="control-label col-lg-3" for={{ fieldStart }}>{{ __('Port') }}:</label>
            </div>
            <div class="col-lg-9">
                <div class="row">
                    <div class="col-lg-5 col-xs-5{{ errors is defined and errors.filter(fieldStart) ? ' has-error' : (_POST[fieldStart]|isset ? ' has-success' : '') }}">
                        {{ textField([ fieldStart, 'class' : 'form-control', 'placeholder' : '1-65535', 'title': __(fieldStart|label) ]) }}
                    </div>
                    <div class="col-lg-2 col-xs-2 text-center text-muted">&#8212;</div>
                    <div class="col-lg-5 col-xs-5{{ errors is defined and errors.filter(fieldEnd) ? ' has-error' : (_POST[fieldEnd]|isset ? ' has-success' : '') }}">
                        {{ textField([ fieldEnd, 'class' : 'form-control', 'placeholder' : '1-65535', 'title': __(fieldEnd|label) ]) }}
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
    </div>
</div>
{% set fieldStart = 'lengthMin' %}
{% set fieldEnd = 'lengthMax' %}
<div class="form-group">
    <div class="{{ errors is defined and (errors.filter(fieldStart) or errors.filter(fieldEnd)) ? ' has-error' : (_POST[fieldStart]|isset or _POST[fieldEnd]|isset ? ' has-success' : '') }}">
        <label class="control-label col-lg-3" for={{ fieldStart }}>{{ __('Length') }}:</label>
    </div>
    <div class="col-lg-9">
        <div class="row">
            <div class="col-lg-5 col-xs-5{{ errors is defined and errors.filter(fieldStart) ? ' has-error' : (_POST[fieldStart]|isset ? ' has-success' : '') }}">
                <div class="input-group">
                    {{ textField([ fieldStart, 'class' : 'form-control', 'placeholder' : __(fieldStart|label), 'title': __(fieldStart|label) ]) }}
                    <span class="input-group-addon" title="{{ __('Kilobytes') }}">KB</span>
                </div>
            </div>
            <div class="col-lg-2 col-xs-2 text-center text-muted">&#8212;</div>
            <div class="col-lg-5 col-xs-5{{ errors is defined and errors.filter(fieldEnd) ? ' has-error' : (_POST[fieldEnd]|isset ? ' has-success' : '') }}">
                <div class="input-group">
                    {{ textField([ fieldEnd, 'class' : 'form-control', 'placeholder' : __(fieldEnd|label), 'title': __(fieldEnd|label) ]) }}
                    <span class="input-group-addon" title="{{ __('Kilobytes') }}">KB</span>
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
{% set field = 'priority' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ selectStatic([field, 'class': 'form-control', priority, 'useEmpty': true, 'emptyText': __('Choose...')]) }}
        {% if errors is defined and errors.filter(field) %}
            <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
        {% endif %}
    </div>
</div>
{% set field = 'sorting' %}
<div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
    <label class="control-label col-lg-3" for={{ field }}>{{ __(field|capitalize) }}:</label>
    <div class="col-lg-9">
        {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize) ]) }}
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